-- AdverbMlt.gf: adverbial phrases
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Licensed under LGPL

concrete AdverbMlt of Adverb = CatMlt ** open ResMlt, Prelude in {

  lin
    -- Prep -> NP -> Adv
    PrepNP prep np = {s = prepNP prep np};

}
