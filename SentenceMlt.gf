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
            False => np.s ! NPNom
            } ;
          v = joinVParts (vp.s ! VPIndicat tense (toVAgr np.a) ! ant ! pol) ;
          o = vp.s2 ! np.a ;
        } ;
      } ;

    -- Temp -> Pol -> Cl -> S
    UseCl t p cl = {
      s = t.s ++ p.s ++ cl.s ! t.t ! t.a ! p.p ! ODir
      } ;

    -- Temp -> Pol -> QCl -> QS
    UseQCl t p qcl = {
      s = \\q => t.s ++ p.s ++ qcl.s ! t.t ! t.a ! p.p ! q
    } ;

    -- Temp -> Pol -> RCl -> RS
    UseRCl t p rcl = {
      s = \\r => t.s ++ p.s ++ rcl.s ! t.t ! t.a ! p.p ! r ;
      -- c = cl.c
    } ;

    -- Temp -> Pol -> ClSlash -> SSlash
    UseSlash t p clslash = {
      s = t.s ++ p.s ++ clslash.s ! t.t ! t.a ! p.p ! ODir ;
      -- c2 = cl.c2
    } ;

}
