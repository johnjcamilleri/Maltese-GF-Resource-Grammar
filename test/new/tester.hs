{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}

import System.Environment
import System.FilePath

import Control.Monad.Reader
import Control.Monad.State

import Text.Printf
import Data.String.Utils
import qualified Data.Map as Map

import PGF

data Env = Env {
  pgf :: PGF,
  langEng :: Language,
  langMlt :: Language
  }

-- | The result of processing a whole file
data Summary = Summary { file :: FilePath , passed :: Int , total :: Int }

-- | The result of processing a single line
data Result =
    Error String
  | Warning String
  | Ok String
  | Ignore

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
    fs -> do
      summaries <- mapM (\f -> runReaderT (runFile f) env) fs
      putStrLn ""
      mapM_ (\summary -> do
                let good' = passed summary
                let total' = total summary
                let perc = fromIntegral (good' * 100) / fromIntegral total' :: Float
                putStrLn $ printf "%s: %d/%d (%.1f%%)" (file summary) good' total' perc
            ) summaries

-- | Run a single file
runFile :: (MonadIO m, MonadReader Env m) => FilePath -> m Summary
runFile filepath = do
  c <- liftIO (readFile filepath)
  liftIO $ putStrLn $ "# " ++ filepath
  let summ = Summary filepath 0 0
  execStateT (run . (drop 2) . lines $ c) summ

-- | Process the table contents
run :: (MonadIO m, MonadReader Env m, MonadState Summary m) => [String] -> m ()
run lines = do
  results :: [Result] <- mapM line lines
  mapM (\(ln,res) -> do
           -- Output
           liftIO $ putStr $ printf "%3d " (ln :: Int)
           case res of
             Ok s      -> ok   $ s
             Warning s -> warn $ s
             Error s   -> err  $ s
             _         -> liftIO $ putStrLn "-"
       ) (zip [3..] results)

  -- Put back in state
  let good = length $ filter (\x->case x of {Ok _ -> True; _ -> False}) results
  let total = length $ filter (\x->case x of {Ignore -> False; _ -> True}) results
  modify $ \summary -> summary { passed = good , total = total }

-- | Process a single line (expects line of an org-mode table)
line :: (MonadIO m, MonadReader Env m) => String -> m Result
line l = do
  let bits
        = map strip $ wordsWhen (=='|') l
  if (length bits < 3)
    then return Ignore
    else check (bits!!0) (bits!!1) (bits!!2)

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

-- highlight = "\ESC[7m"
-- bold      = "\ESC[1m"
-- underline = "\ESC[4m"
normal    = "\ESC[0m"
fgcol col = "\ESC[0;" ++ show (30+col) ++ "m"
bgcol col = "\ESC[0;" ++ show (40+col) ++ "m"

red, green, blue :: Color
red = 1
green = 2
blue = 4
yellow = 3
