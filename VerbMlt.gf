-- VerbMlt.gf: verb phrases
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2012
-- Licensed under LGPL

concrete VerbMlt of Verb = CatMlt ** open Prelude, ResMlt in {
  flags optimize=all_subs ;

  lin
    -- V -> VP ;
    UseV = predV ;

    -- V2 -> VPSlash
    SlashV2a = predV ;

    -- VPSlash -> NP -> VP
    ComplSlash vp np =
      case np.isPron of {
        -- Join pron to verb
        True => {
            s = \\vpf,ant,pol => glue (vp.s ! vpf ! ant ! pol) (np.s ! CPrep) ;
            s2 = \\agr => [] ;
          } ;

        -- Insert obj to VP
        _ => insertObj (\\agr => np.s ! CPrep) vp
      } ;

-- Comp
-- VP
-- VPSplash

}
