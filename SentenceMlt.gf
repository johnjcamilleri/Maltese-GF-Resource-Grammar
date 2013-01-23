-- SentenceMlt.gf: clauses and sentences
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2012
-- Licensed under LGPL

--# -path=.:abstract:common:prelude

concrete SentenceMlt of Sentence = CatMlt ** open
  Prelude,
  ResMlt,
  ParamX,
  CommonX in {

  flags optimize=all_subs ;

  lin
    -- NP -> VP -> Cl
    -- John walks
    PredVP np vp = {
      s = \\tense,ant,pol => np.s ! Nom ++ vp.s ! VPIndicat tense (toVAgr np.a) ! ant ! pol
      } ;

-- Cl
-- Imp
-- QS
-- RS
-- S
-- SC
-- SSlash

}
