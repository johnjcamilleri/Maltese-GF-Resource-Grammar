module PGFTest where
       
import PGF
import Data.Maybe

main :: IO ()
main = do
  pgf <- readPGF "lib/src/maltese/PGF/Lang.pgf"
  let mlt = head $ languages pgf
  let love = mkCId "love_V2"
  
  -- Parsing
  let (Just typ) = functionType pgf love
  let trees = parse pgf mlt typ "ħabb"
  print trees
  
  -- Linearize with table
  let table = head $ tabularLinearizes pgf mlt (mkApp love [])
  putStrLn $ unlines $ map (\(f,s) -> f ++ " = " ++ s) table
  
  -- Morpho analysis
  let morpho = buildMorpho pgf mlt
  print $ lookupMorpho morpho "ħabb"
