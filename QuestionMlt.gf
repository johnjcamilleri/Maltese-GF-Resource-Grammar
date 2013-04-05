-- QuestionMlt.gf: questions and interrogatives
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Licensed under LGPL

concrete QuestionMlt of Question = CatMlt ** open ResMlt, ParamX, Prelude in {

  flags optimize=all_subs ;

  lin
    QuestCl cl = {
      s = \\t,a,p => 
        let cls = cl.s ! t ! a ! p 
        in table {
          QDir   => cls ! OQuest ;
          QIndir => "kieku" ++ cls ! ODir
        }
      } ;

}
