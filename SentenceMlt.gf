--# -path=.:abstract:common:prelude

concrete SentenceMlt of Sentence = CatMlt ** open 
  ResMlt,
  Prelude, 
  ResMlt,
  ParamX,
  CommonX in {

  flags optimize=all_subs ;
        

}
