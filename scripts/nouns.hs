{-# LANGUAGE ScopedTypeVariables #-}

import System.Environment
import System.FilePath

import Control.Monad (unless)

import Text.Printf
import Data.String.Utils

main :: IO ()
main = do
  c <- readFile "../msc-thesis/Appendix/Nouns.org"
  mapM_ line ((drop 29) . lines $ c)

-- | Process a single line (expects line of an org-mode table)
line :: String -> IO ()
line l = do
  let bits = map strip $ wordsWhen (=='|') l
  unless (length bits < 7) $ do
    case (bits!!1) of
      "1"   -> make bits "mkN" [2,5]
      "1x"  -> make bits "mkN" [2,5,6]
      "2"   -> make bits "mkNColl" [2,3,5]
      "2x"  -> make bits "mkNColl" [2,3,5,6]
      "2b"  -> make bits "mkNColl" [3,5]
      "2bx" -> make bits "mkNColl" [3,5]
      "2c"  -> make bits "mkNColl" [3]
      "3"   -> make bits "mkNNoPlural" [2]
      "4"   -> make bits "mkNDual" [2,4,5]
      "4x"  -> make bits "mkNDual" [2,4,5,6]
      x     -> error $ "Don't know about " ++ x

make :: [String] -> String -> [Int] -> IO ()
make bits const ixs = do
  let fun = takeWhile (/='=') $ tail $ bits!!0
  let format = "%s = %s" ++ (concat $ replicate (length ixs) " \"%s\"") ++ " ;"
  let args :: [String] = map (bits!!) ixs
  case (length args) of
    1 -> putStrLn $ printf format fun const (args!!0)
    2 -> putStrLn $ printf format fun const (args!!0) (args!!1)
    3 -> putStrLn $ printf format fun const (args!!0) (args!!1) (args!!2)
    4 -> putStrLn $ printf format fun const (args!!0) (args!!1) (args!!2) (args!!3)

-- | See: http://stackoverflow.com/a/4981265/98600
wordsWhen     :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = break p s'
