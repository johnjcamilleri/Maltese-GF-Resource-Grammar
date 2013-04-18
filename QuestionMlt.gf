-- QuestionMlt.gf: questions and interrogatives
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Licensed under LGPL

concrete QuestionMlt of Question = CatMlt ** open ResMlt, ParamX, Prelude in {

  flags optimize=all_subs ;

  lin

    -- Cl -> QCl
    -- does John walk
    QuestCl cl = {
      s = \\t,a,p =>
        let cls = cl.s ! t ! a ! p
        in table {
          QDir   => cls ! OQuest ;
          QIndir => "kieku" ++ cls ! ODir
        }
      } ;

    -- IP -> VP -> QCl
    -- who walks
    QuestVP qp vp =
      let
        -- cl = mkClause (qp.s ! npNom) (agrP3 qp.n) vp
        cl = mkClause qp.s (agrP3 qp.n Masc) vp
      in {
        s = \\t,a,p,_ => cl.s ! t ! a ! p ! ODir
      } ;

    -- -- IP -> ClSlash -> QCl
    -- -- whom does John love
    -- QuestSlash ip slash =
    --   mkQuestion (ss (slash.c2 ++ ip.s ! NPAcc)) slash ;
    --   --- stranding in ExratEng

    -- -- IAdv -> Cl -> QCl
    -- -- why does John walk
    -- QuestIAdv iadv cl = mkQuestion iadv cl ;

    -- -- IComp -> NP -> QCl
    -- -- where is John
    -- QuestIComp icomp np =
    --   mkQuestion icomp (mkClause (np.s ! npNom) np.a (predAux auxBe)) ;

  lincat
    QVP = ResMlt.VerbPhrase ;
}
