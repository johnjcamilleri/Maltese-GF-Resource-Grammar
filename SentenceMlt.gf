-- Maltese Resource Grammar Library
-- (c) 2011 John J. Camilleri [john@johnjcamilleri.com]
-- Licensed under LGPL

--# -path=.:abstract:common:prelude

concrete SentenceMlt of Sentence = CatMlt ** open
  ResMlt,
  Prelude,
  ResMlt,
  ParamX,
  CommonX in {

  flags optimize=all_subs ;


}
