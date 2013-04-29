-- VerbMlt.gf: verb phrases
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Angelo Zammit 2012
-- Licensed under LGPL

concrete VerbMlt of Verb = CatMlt ** open Prelude, ResMlt in {
  flags optimize=all_subs ;

  lin
    -- V -> VP
    UseV = predV ;

    -- V2 -> VPSlash
    -- love (it)
    SlashV2a = predV ;

    -- -- V3 -> NP -> VPSlash
    -- -- give it (to her)
    -- Slash2V3 v np =
    --   insertObjc (\\_ => v.c2 ++ np.s ! NPAcc) (predV v ** {c2 = v.c3 ; gapInMiddle = False}) ;

    -- -- V3  -> NP -> VPSlash
    -- -- give (it) to her
    -- Slash3V3 v np =
    --   insertObjc (\\_ => v.c3 ++ np.s ! NPAcc) (predVc v) ; ----

    -- VV -> VP -> VP
    -- want to run
--     ComplVV v vp = insertObj (\\a => infVP v.typ vp Simul CPos a) (predVV v) ;

    -- VS -> S -> VP
    -- say that she runs
    ComplVS v s = insertObj (\\_ => conjLi ++ s.s) (predV v) ;

    -- VQ -> QS -> VP
    -- wonder who runs
    ComplVQ v q  = insertObj (\\_ => q.s ! QIndir) (predV v) ;

    -- VA -> AP -> VP
    -- they become red
    ComplVA v ap = insertObj (\\agr => ap.s ! mkGenNum agr) (predV v) ;

    -- -- V2V -> VP -> VPSlash
    -- -- beg (her) to go
    -- SlashV2V v vp = insertObjc (\\a => v.c3 ++ infVP v.typ vp Simul CPos a) (predVc v) ;

    -- -- V2S -> S  -> VPSlash
    -- -- answer (to him) that it is good
    -- SlashV2S v s  = insertObjc (\\_ => conjThat ++ s.s) (predVc v) ;

    -- -- V2Q -> QS -> VPSlash
    -- -- ask (him) who came
    -- SlashV2Q v q  = insertObjc (\\_ => q.s ! QIndir) (predVc v) ;

    -- -- V2A -> AP -> VPSlash
    -- -- paint (it) red
    -- SlashV2A v ap = insertObjc (\\a => ap.s ! a) (predVc v) ;

    -- VPSlash -> NP -> VP
    -- love it
    ComplSlash vp np =
      case np.isPron of {
        -- Join pron to verb
        True => {
            s = \\vpf,ant,pol =>
              let bits = vp.s ! vpf ! ant ! pol in
              mkVParts (glue bits.stem (np.s ! NPCPrep)) bits.pol ;
            s2 = \\agr => [] ;
          } ;

        -- Insert obj to VP
        _ => insertObj (\\agr => np.s ! NPCPrep) vp
      } ;

    -- -- VV -> VPSlash -> VPSlash
    -- -- want to buy
    -- SlashVV vv vp =
    --   insertObj (\\a => infVP vv.typ vp Simul CPos a) (predVV vv) **
    --     {c2 = vp.c2 ; gapInMiddle = vp.gapInMiddle} ;

    -- -- V2V -> NP -> VPSlash -> VPSlash
    -- -- beg me to buy
    -- SlashV2VNP vv np vp =
    --   insertObjPre (\\_ => vv.c2 ++ np.s ! NPAcc)
    --     (insertObjc (\\a => vv.c3 ++ infVP vv.typ vp Simul CPos a) (predVc vv)) **
    --       {c2 = vp.c2 ; gapInMiddle = vp.gapInMiddle} ;

    -- Comp -> VP
    -- be warm
    UseComp comp = insertObj comp.s (predV copula_kien) ;

    -- VP -> Adv -> VP
    -- sleep here
    AdvVP vp adv = insertObj (\\_ => adv.s) vp ;

    -- AdV -> VP -> VP
    -- always sleep
--     AdVVP adv vp = insertAdV adv.s vp ;

    -- VPSlash -> Adv -> VPSlash
    -- use (it) here
    AdvVPSlash vp adv = insertObj (\\_ => adv.s) vp ** {c2 = vp.c2} ;

    -- AdV -> VPSlash -> VPSlash
    -- always use (it)
--     AdVVPSlash adv vp = insertAdV adv.s vp ** {c2 = vp.c2 ; gapInMiddle = vp.gapInMiddle} ;

    -- VPSlash -> VP
    -- love himself
--     ReflVP v = insertObjPre (\\a => v.c2 ++ reflPron ! a) v ;

    -- V2 -> VP
    -- be loved
--     PassV2 v = insertObj (\\_ => v.s ! VPPart ++ v.p) (predAux auxBe) ;

    -- AP -> Comp
    -- (be) small
    CompAP ap = {
      s = \\agr => ap.s ! mkGenNum agr
      } ;

    -- NP -> Comp
    -- (be) the man
    CompNP np = {
      s = \\_ => np.s ! NPAcc
      } ;

    -- Adv -> Comp
    -- (be) here
    CompAdv adv = {
      s = \\_ => adv.s
      } ;

    -- CN -> Comp
    -- (be) a man/men
    CompCN cn = {
      s = \\agr => case agr.n of {
        Sg => artIndef ++ cn.s ! Singulative ;
        Pl => cn.s ! Plural
        }
    } ;

    -- VP
    -- be
    UseCopula = predV copula_kien ;

    -- VP -> Prep -> VPSlash
    -- live in (it)
    VPSlashPrep vp p = vp ** {
      c2 = \\agr => p ! Definite
      } ;

}
