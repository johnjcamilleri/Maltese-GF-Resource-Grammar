-- Lookup each entry in lexicon-dict mapping and replace
-- declarations in lexicon with corresponding ones from dict

import Text.Regex
import Data.Maybe

mapFile="lex-dict-mapping.txt"
dicFile="DictMlt.gf"
lexFile="LexiconMlt.gf"

-- Strip whitespace from a string
strip = lstrip . rstrip
lstrip = dropWhile (`elem` " \t")
rstrip = reverse . lstrip . reverse

-- Read file into lines, splitting each at given separator
readAndSplitAt :: FilePath -> String -> IO [(String,String)]
readAndSplitAt file sep = do
  content <- readFile file
  return [ (strip (x!!0), strip (x!!1))
         | x <- map (splitRegex (mkRegex sep)) (lines content)
         , length x > 1]

main = do
  -- Load map and construct replacements
  ms <- readAndSplitAt mapFile "="
  ds <- readAndSplitAt dicFile "="
  let rs = [ (k, fromJust (lookup v1 ds))
          | (k,v1) <- ms
          , isJust (lookup v1 ds) ]

  -- Perform replacements
  content <- readFile lexFile
  let ls' = map replaceLine (lines content)
      replaceLine :: String -> String
      replaceLine l =
        let k = strip $ takeWhile (/='=') l
        in case lookup k rs of
          Just v -> "    " ++ k ++ " = " ++ v -- ++ " -- auto-replaced"
          _ -> l
  
  -- Output contents
  -- writeFile lexFile (unlines ls')
  putStr $ unlines ls'
  
