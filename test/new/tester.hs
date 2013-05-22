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
  liftIO $ putStrLn $ "# " ++ filepath
  run . (drop 2) . lines $ c

-- | Process the table contents
run :: (MonadIO m, MonadReader Env m) => [String] -> m ()
run lines = do
  results <- mapM line lines
  let good = length $ filter (\x->case x of {Ok _ -> True; _ -> False}) results
  let total = length $ filter (\x->case x of {Ignore -> False; _ -> True}) results
  let perc = fromIntegral (good * 100) / fromIntegral total :: Float
  liftIO $ putStrLn $ printf "Passed %d/%d (%.1f%%)" good total perc

-- | Process a single line (expects line of an org-mode table)
line :: (MonadIO m, MonadReader Env m) => String -> m Result
line l = do
  let bits
        = map strip $ wordsWhen (=='|') l
  if (length bits < 3)
    then do
    liftIO $ putStrLn "-"
    return Ignore
    else do
    res <- check (bits!!0) (bits!!1) (bits!!2)
    case res of
      Ok s      -> ok   $ "+ " ++ s
      Warning s -> warn $ "! " ++ s
      Error s   -> err  $ "x " ++ s
    return res

-- | The result of processing a single line
data Result =
    Error String
  | Warning String
  | Ok String
  | Ignore

-- | Check linearisation against gold standard
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
      case () of _
                   | out_eng /= eng -> return $ Warning $ printf "English mismatch: expected \"%s\" but got \"%s\"" eng out_eng
                   | out_mlt /= mlt -> return $ Error   $ printf "%s (expected \"%s\")" out_mlt mlt
                   | out_mlt == mlt -> return $ Ok      $ mlt
    Nothing -> return $ Warning $ "Invalid AST: " ++ ast

ok   s = liftIO $ putStrLn $ color green $ s
warn s = liftIO $ putStrLn $ color yellow $ s
err  s = liftIO $ putStrLn $ color red $ s

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
