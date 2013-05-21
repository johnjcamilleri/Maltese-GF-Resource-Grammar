{-# LANGUAGE FlexibleContexts #-}

import System.Environment
import Control.Monad.Reader
import Data.String.Utils
import qualified Data.Map as Map
import PGF
import Text.Printf

data Env = Env {
  pgf :: PGF,
  langEng :: Language,
  langMlt :: Language
  }

main :: IO ()
main = do

  -- Load PGF
  pgf <- readPGF "../../PGF/LangEngMlt.pgf"
  let lang_eng = (languages pgf) !! 0
  let lang_mlt = (languages pgf) !! 1
  let env = Env pgf lang_eng lang_mlt

  args <- getArgs
  case args of
    [] -> error "Must specify argument"
    fs -> mapM_ (\f -> runReaderT (runFile f) env) fs

-- | Run a single file
runFile :: (MonadIO m, MonadReader Env m) => FilePath -> m ()
runFile filepath = do
  c <- liftIO (readFile filepath)
  liftIO $ putStrLn $ "-- " ++ filepath
  run . (drop 2) . lines $ c

-- | Process the table contents
run :: (MonadIO m, MonadReader Env m) => [String] -> m ()
run lines = do
  results <- mapM line lines
  let good = length $ filter (==True) results
  let total = length results
  liftIO $ putStrLn $ printf "Passed %d/%d" good total

-- | Expects line of an org-mode table
line ::  (MonadIO m, MonadReader Env m) => String -> m Bool
line l = do
  let bits = map strip $ wordsWhen (=='|') l
  res <- check (bits!!0) (bits!!1) (bits!!2)
  case res of
    Right s -> do ok $ "+ " ++ s ; return True
    Left s  -> do err $ "- " ++ s ; return False

type Result = Either String String

check :: (MonadIO m, MonadReader Env m) => String -> String -> String -> m Result
check ast eng mlt = do
  pgf <- asks pgf
  lang_eng <- asks langEng
  lang_mlt <- asks langMlt
  case readExpr ast of
    Just tree -> do
      let m = Map.fromList $ linearizeAllLang pgf tree
          Just out_eng = Map.lookup lang_eng m
          Just out_mlt' = Map.lookup lang_mlt m
          out_mlt = bind out_mlt'
      unless (out_eng == eng) $ warn $ printf "! English mismatch: expected \"%s\" but got \"%s\"" eng out_eng
      return $ if out_mlt == mlt then Right mlt else Left $ printf "Expected \"%s\" but got \"%s\"" mlt out_mlt
    Nothing -> return $ Left $ "Invalid AST: " ++ ast

ok s   = liftIO $ putStrLn $ color green $ s
warn s = liftIO $ putStrLn $ color yellow $ s
err s  = liftIO $ putStrLn $ color red $ s

-- | See: http://stackoverflow.com/a/4981265/98600
wordsWhen     :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'

bind :: String -> String
bind = replace " &+ " ""

--
-- * Terminal output colors
--

type Color = Int

color :: Color -> String -> String
color c s = fgcol c ++ s ++ normal

highlight = "\ESC[7m"
bold      = "\ESC[1m"
underline = "\ESC[4m"
normal    = "\ESC[0m"
fgcol col = "\ESC[0" ++ show (30+col) ++ "m"
bgcol col = "\ESC[0" ++ show (40+col) ++ "m"

red, green, blue :: Color
red = 1
green = 2
blue = 4
yellow = 3
