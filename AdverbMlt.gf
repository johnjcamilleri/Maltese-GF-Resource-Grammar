-- AdverbMlt.gf: adverbial phrases
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Licensed under LGPL

concrete AdverbMlt of Adverb = CatMlt ** open ResMlt, Prelude in {

-- AdN
-- Adv

  lin
    -- Prep -> NP -> Adv
    PrepNP prep np = {
      s = case np.isDefn of {
        True  => prep.s ! Definite ! Full ++ np.s ! CPrep ; -- FIT-TRIQ
        False => prep.s ! Indefinite ! Full ++ np.s ! Nom -- FI TRIQ
        }
      } ;
}
