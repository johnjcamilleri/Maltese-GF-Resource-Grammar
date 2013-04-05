-- SentenceMlt.gf: clauses and sentences
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Angelo Zammit 2012
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
      s = \\tense,ant,pol,ord =>
        case ord of {
          ODir => (s ++ v ++ o) ; -- ĠANNI JIEKOL ĦUT
          OQuest => (v ++ o ++ s) -- JIEKOL ĦUT ĠANNI ?
        }
        where {
          s = case np.isPron of {
            True => [] ; -- omit subject pronouns
            False => np.s ! Nom
            } ;
          v = joinVParts (vp.s ! VPIndicat tense (toVAgr np.a) ! ant ! pol) ;
          o = vp.s2 ! np.a ;
        } ;
      } ;

    -- Temp -> Pol -> Cl -> S
    UseCl t p cl = {
      -- t and p never have any linearization
      s = t.s ++ p.s ++ cl.s ! t.t ! t.a ! p.p ! ODir
      } ;

-- Cl
-- Imp
-- QS
-- RS
-- S
-- SC
-- SSlash

}
