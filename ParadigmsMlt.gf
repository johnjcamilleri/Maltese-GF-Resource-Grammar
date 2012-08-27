-- ParadigmsMlt.gf: morphological paradigms
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2012
-- Licensed under LGPL

--# -path=.:../abstract:../../prelude:../common

resource ParadigmsMlt = open
  Predef,
  Prelude,
  MorphoMlt,
  ResMlt,
  CatMlt
  in {

  flags
    optimize=noexpand ;
    coding=utf8 ;

  oper

    {- ===== Parameters ===== -}

    -- Abstraction over gender names
    Gender : Type ;
    masculine : Gender ; --%
    feminine : Gender ; --%

    Gender = ResMlt.Gender ;
    masculine = Masc ;
    feminine = Fem ;

    {- ===== Noun Paradigms ===== -}

    -- Helper function for inferring noun plural from singulative
    -- Nouns with collective & determinate forms should not use this...
    inferNounPlural : Str -> Str = \sing ->
      case sing of {
        _ + "na" => init sing + "iet" ; -- eg WIDNIET
        _ + "i" => sing + "n" ; -- eg BAĦRIN, DĦULIN, RAĦLIN
        _ + ("a"|"u") => init(sing) + "i" ; -- eg ROTI
        _ + "q" => sing + "at" ; -- eg TRIQAT
        _ => sing + "i"
      } ;

    -- Helper function for inferring noun gender from singulative
    -- Refer {MDG pg190}
    inferNounGender : Str -> Gender = \sing ->
      case sing of {
        _ + "aġni" => Fem ;
        _ + "anti" => Fem ;
        _ + "zzjoni" => Fem ;
        _ + "ġenesi" => Fem ;
        _ + "ite" => Fem ;
        _ + "itù" => Fem ;
        _ + "joni" => Fem ;
        _ + "ojde" => Fem ;
        _ + "udni" => Fem ;
        _ + ("a"|"à") => Fem ;
        _ => Masc
      } ;


    -- Smart paradigm for building a noun
    mkN : N = overload {

      -- Take the singular and infer gender & plural.
      -- Assume no special plural forms.
      -- Params:
        -- Singular, eg AJRUPLAN
      mkN : Str -> N = \sing ->
        let
          plural = inferNounPlural sing ;
          gender = inferNounGender sing ;
        in
          mk5N sing [] [] plural [] gender ;

      -- Take an explicit gender.
      -- Assume no special plural forms.
      -- Params:
        -- Singular, eg AJRUPLAN
        -- Gender
      mkN : Str -> Gender -> N = \sing,gender ->
        let
          plural = inferNounPlural sing ;
        in
          mk5N sing [] [] plural [] gender ;

      -- Take the singular, plural. Infer gender.
      -- Assume no special plural forms.
      -- Params:
        -- Singular, eg KTIEB
        -- Plural, eg KOTBA
      mkN : Str -> Str -> N = \sing,plural ->
        let
          gender = inferNounGender sing ;
        in
          mk5N sing [] [] plural [] gender ;

      -- Take the singular, plural and gender.
      -- Assume no special plural forms.
      -- Params:
        -- Singular, eg KTIEB
        -- Plural, eg KOTBA
        -- Gender
      mkN : Str -> Str -> Gender -> N = \sing,plural,gender ->
          mk5N sing [] [] plural [] gender ;


      -- Takes all 5 forms, inferring gender
      -- Params:
        -- Singulative, eg KOXXA
        -- Collective, eg KOXXOX
        -- Double, eg KOXXTEJN
        -- Determinate Plural, eg KOXXIET
        -- Indeterminate Plural
      mkN : Str -> Str -> Str -> Str -> Str -> N = \sing,coll,dual,det,ind ->
        let
          gender = if_then_else (Gender) (isNil sing) (inferNounGender coll) (inferNounGender sing) ;
        in
          mk5N sing coll dual det ind gender ;

    } ; --end of mkN overload

    -- Take the singular and infer gender.
    -- No other plural forms.
    -- Params:
      -- Singular, eg ARTI
    mkNNoPlural : N = overload {

      mkNNoPlural : Str -> N = \sing ->
        let  gender = inferNounGender sing ;
        in  mk5N sing [] [] [] [] gender
      ;

      mkNNoPlural : Str -> Gender -> N = \sing,gender ->
        mk5N sing [] [] [] [] gender
      ;

    } ; --end of mkNNoPlural overload


    -- Take the singular and infer dual, plural & gender
    -- Params:
      -- Singular, eg AJRUPLAN
    mkNDual : Str -> N = \sing ->
      let
        dual : Str = case sing of {
          _ + ("għ"|"'") => sing + "ajn" ;
          _ + ("a") => init(sing) + "ejn" ;
          _ => sing + "ejn"
        } ;
        plural = inferNounPlural sing ;
        gender = inferNounGender sing ;
      in
        mk5N sing [] dual plural [] gender ;


    -- Take the collective, and infer singulative, determinate plural, and gender.
    -- Params:
      -- Collective Plural, eg TUFFIEĦ
    mkNColl : Str -> N = \coll ->
      let
        stem : Str = case coll of {
          -- This can only apply when there are 2 syllables in the word
          _ + #Vowel + #Consonant + #Vowel + K@#Consonant => dropSfx 2 coll + K ; -- eg GĦADAM -> GĦADM-

          _ => coll
        } ;
        sing : Str = case stem of {
          _ => stem + "a"
        } ;
        det : Str = case stem of {
          _ => stem + "iet"
        } ;
        -- gender = inferNounGender sing ;
        gender = Masc ; -- Collective noun is always treated as Masculine
      in
        mk5N sing coll [] det [] gender ;

    -- Build a noun using 5 forms, and a gender
    mk5N : (_,_,_,_,_ : Str) -> Gender -> N ;
    mk5N = \sing,coll,dual,det,ind,gen ->
--      lin N (mkNoun sing coll dual det ind gen) ;
      lin N (mkNoun
               (nullSuffixTable sing)
               (nullSuffixTable coll)
               (nullSuffixTable dual)
               (nullSuffixTable det)
               (nullSuffixTable ind)
               gen) ;

{-
    -- Correctly abbreviate definite prepositions and join with noun
    -- Params:
      -- preposition (eg TAL, MAL, BĦALL)
      -- noun
    abbrevPrepositionDef : Str -> Str -> Str = \prep,noun ->
      let
        -- Remove either 1 or 2 l's
        prepStem : Str = case prep of {
          _ + "ll" => dropSfx 2 prep ;
          _ + "l"  => dropSfx 1 prep ;
          _ => prep -- this should never happen, I don't think
        }
      in
      case noun of {
        ("s"|#LiquidCons) + #Consonant + _ => prep + "-i" + noun ;
        ("għ" | #Vowel) + _ => case prep of {
          ("fil"|"bil") => (takePfx 1 prep) + "l-" + noun ;
          _ => prep + "-" + noun
        };
        K@#CoronalConsonant + _ => prepStem + K + "-" + noun ;
        #Consonant + _ => prep + "-" + noun ;
        _ => []
      } ;
-}
    -- Correctly abbreviate indefinite prepositions and join with noun
    -- Params:
      -- preposition (eg TA', MA', BĦAL)
      -- noun
    abbrevPrepositionIndef : Str -> Str -> Str = \prep,noun ->
      let
        initPrepLetter = takePfx 1 prep ;
        initNounLetter = takePfx 1 noun
      in
      if_then_Str (isNil noun) [] (
      case prep of {

        -- TA', MA', SA
        _ + ("a'"|"a") =>
          case noun of {
            #Vowel + _  => initPrepLetter + "'" + noun ;
            ("għ" | "h") + #Vowel + _ => initPrepLetter + "'" + noun ;
            _ => prep ++ noun
          } ;

        -- FI, BI
        _ + "i" =>
        if_then_Str (pbool2bool (eqStr initPrepLetter initNounLetter))
          (prep ++ noun)
          (case noun of {
            -- initPrepLetter + _ => prep ++ noun ;
            #Vowel + _  => initPrepLetter + "'" + noun ;
            #Consonant + #Vowel + _  => initPrepLetter + "'" + noun ;
            #Consonant + "r" + #Vowel + _ => initPrepLetter + "'" + noun ;
            _ => prep ++ noun
          }) ;

        -- Else leave untouched
        _ => prep ++ noun

      });


    mkN2 = overload {
      mkN2 : N -> Prep -> N2 = prepN2 ;
      mkN2 : N -> Str -> N2 = \n,s -> prepN2 n (mkPrep s);
--      mkN2 : Str -> Str -> N2 = \n,s -> prepN2 (regN n) (mkPrep s);
      mkN2 : N -> N2         = \n -> prepN2 n (mkPrep "ta'") ;
--      mkN2 : Str -> N2       = \s -> prepN2 (regN s) (mkPrep "ta'")
    } ;

    prepN2 : N -> Prep -> N2 ;
    prepN2 = \n,p -> lin N2 (n ** {c2 = p.s}) ;

    mkPrep : Str -> Prep ; -- e.g. "in front of"
    noPrep : Prep ;  -- no preposition

    mkPrep p = lin Prep (ss p) ;
    noPrep = mkPrep [] ;


    {- ===== Verb paradigms ===== -}

    -- Takes a verb as a string and returns the VType and root/pattern.
    -- Used in smart paradigm below and elsewhere.
    -- Params: "Mamma" (Perf Per3 Sg Masc) as string (eg KITEB or ĦAREĠ)
    classifyVerb : Str -> VerbInfo = \mamma ->
      case mamma of {

        -- Defective, BELA'
        c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel + c3@( "għ" | "'" ) =>
          mkVerbInfo (Weak Defective) FormI (mkRoot c1 c2 "għ") (mkPattern v1 v2) ;

        -- Lacking, MEXA
        c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel =>
          mkVerbInfo (Weak Lacking) FormI (mkRoot c1 c2 "j") (mkPattern v1 v2) ;

        -- Hollow, SAB
        -- --- determining of middle radical is not right, e.g. SAB = S-J-B
        c1@#Consonant + v1@"a"  + c3@#Consonant =>
          mkVerbInfo (Weak Hollow) FormI (mkRoot c1 "w" c3) (mkPattern v1) ;
        c1@#Consonant + v1@"ie" + c3@#Consonant =>
          mkVerbInfo (Weak Hollow) FormI (mkRoot c1 "j" c3) (mkPattern v1) ;

        -- Weak Assimilative, WAQAF
        c1@#WeakCons + v1@#Vowel + c2@#Consonant + v2@#Vowel  + c3@#Consonant =>
          mkVerbInfo (Weak Assimilative) FormI (mkRoot c1 c2 c3) (mkPattern v1 v2) ;

        -- Strong Geminated, ĦABB
        c1@#Consonant + v1@#Vowel + c2@#Consonant + c3@#Consonant =>
          mkVerbInfo (Strong Geminated) FormI (mkRoot c1 c2 c3) (mkPattern v1) ;

        -- Strong LiquidMedial, ŻELAQ
        c1@#Consonant + v1@#Vowel + c2@(#LiquidCons | "għ") + v2@#Vowel + c3@#Consonant =>
          mkVerbInfo (Strong LiquidMedial) FormI (mkRoot c1 c2 c3) (mkPattern v1 v2) ;

        -- Strong Regular, QATEL
        c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel + c3@#Consonant =>
          mkVerbInfo (Strong Regular) FormI (mkRoot c1 c2 c3) (mkPattern v1 v2) ;

        -- Strong Quad, QAĊĊAT
        c1@#Consonant + v1@#Vowel + c2@#Consonant + c3@#Consonant + v2@#Vowel + c4@#Consonant =>
          mkVerbInfo (Quad QStrong) FormI (mkRoot c1 c2 c3 c4) (mkPattern v1 v2) ;

        -- Weak-Final Quad, PINĠA
        c1@#Consonant + v1@#Vowel + c2@#Consonant + c3@#Consonant + v2@#Vowel =>
          mkVerbInfo (Quad QWeak) FormI (mkRoot c1 c2 c3 "j") (mkPattern v1 v2) ;

        -- Assume it is a loan verb
        _ => mkVerbInfo Loan FormI
      } ;

    -- Smart paradigm for building a verb
    mkV : V = overload {

      -- Tries to do everything just from the mamma of the verb
      -- Params: mamma
      mkV : Str -> V = \mamma ->
        let
          info = classifyVerb mamma ;
        in
        case info.class of {
          Strong Regular      => strongV info.root info.patt ;
          Strong LiquidMedial => liquidMedialV info.root info.patt ;
          Strong Geminated=> geminatedV info.root info.patt ;
          Weak Assimilative   => assimilativeV info.root info.patt ;
          Weak Hollow         => hollowV info.root info.patt ;
          Weak Lacking        => lackingV info.root info.patt ;
          Weak Defective      => defectiveV info.root info.patt ;
          Quad QStrong        => quadV info.root info.patt ;
          Quad QWeak          => quadWeakV info.root info.patt ;
          Loan                => loanV mamma
        } ;

      -- Takes an explicit root, when it is not obvious from the mamma
      -- Params: mamma, root
      mkV : Str -> Root -> V = \mamma,root ->
        let
          info = classifyVerb mamma ;
        in
        case info.class of {
          Strong Regular      => strongV root info.patt ;
          Strong LiquidMedial => liquidMedialV root info.patt ;
          Strong Geminated    => geminatedV root info.patt ;
          Weak Assimilative   => assimilativeV root info.patt ;
          Weak Hollow         => hollowV root info.patt ;
          Weak Lacking        => lackingV root info.patt ;
          Weak Defective      => defectiveV root info.patt ;
          Quad QStrong        => quadV root info.patt ;
          Quad QWeak          => quadWeakV root info.patt ;
          Loan                => loanV mamma
        } ;

      -- Takes takes an Imperative of the word for when it behaves less predictably
      -- Params: mamma, imperative P2Sg
      mkV : Str -> Str -> V = \mamma,imp_sg ->
        let
          info = classifyVerb mamma ;
        in
        case info.class of {
          Strong Regular      => strongV info.root info.patt imp_sg ;
          Strong LiquidMedial => liquidMedialV info.root info.patt imp_sg ;
          Strong Geminated    => geminatedV info.root info.patt imp_sg ;
          Weak Assimilative   => assimilativeV info.root info.patt imp_sg ;
          Weak Hollow         => hollowV info.root info.patt imp_sg ;
          Weak Lacking        => lackingV info.root info.patt imp_sg ;
          Weak Defective      => defectiveV info.root info.patt imp_sg ;
          Quad QStrong        => quadV info.root info.patt imp_sg ;
          Quad QWeak          => quadWeakV info.root info.patt imp_sg ;
          Loan                => loanV mamma
        } ;

      -- Params: mamma, root, imperative P2Sg
      -- mkV : Str -> Root -> Str -> V = \mamma,root,imp_sg ->
      --   let
      --     info = classifyVerb mamma ;
      --   in
      --   case info.class of {
      --     Strong Regular      => strongV root info.patt imp_sg ;
      --     Strong LiquidMedial => liquidMedialV root info.patt imp_sg ;
      --     Strong Geminated    => geminatedV root info.patt imp_sg ;
      --     Weak Assimilative   => assimilativeV root info.patt imp_sg ;
      --     Weak Hollow         => hollowV root info.patt imp_sg ;
      --     Weak Lacking        => lackingV root info.patt imp_sg ;
      --     Weak Defective      => defectiveV root info.patt imp_sg ;
      --     Quad QStrong        => quadV root info.patt imp_sg ;
      --     Quad QWeak          => quadWeakV root info.patt imp_sg ;
      --     Loan                => loanV mamma
      --   } ;

      -- All forms! :S
      -- mkV (Strong Regular) (FormI) (mkRoot "k-t-b") (mkPattern "i" "e") "ktibt" "ktibt" "kiteb" "kitbet" "ktibna" "ktibtu" "kitbu" "nikteb" "tikteb" "jikteb" "tikteb" "niktbu" "tiktbu" "jiktbu" "ikteb" "iktbu"
      mkV : VClass -> VDerivedForm -> Root -> Pattern -> (_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_ : Str) -> V =
        \class, form, root, patt,
        perfP1Sg, perfP2Sg, perfP3SgMasc, perfP3SgFem, perfP1Pl, perfP2Pl, perfP3Pl,
        impfP1Sg, impfP2Sg, impfP3SgMasc, impfP3SgFem, impfP1Pl, impfP2Pl, impfP3Pl,
        impSg, impPl ->
        let
          tbl : (VForm => Str) = table {
            VPerf (AgP1 Sg) => perfP1Sg ;
            VPerf (AgP2 Sg) => perfP2Sg ;
            VPerf (AgP3Sg Masc) => perfP3SgMasc ;
            VPerf (AgP3Sg Fem) => perfP3SgFem ;
            VPerf (AgP1 Pl) => perfP1Pl ;
            VPerf (AgP2 Pl) => perfP2Pl ;
            VPerf (AgP3Pl) => perfP3Pl ;
            VImpf (AgP1 Sg) => impfP1Sg ;
            VImpf (AgP2 Sg) => impfP2Sg ;
            VImpf (AgP3Sg Masc) => impfP3SgMasc ;
            VImpf (AgP3Sg Fem) => impfP3SgFem ;
            VImpf (AgP1 Pl) => impfP1Pl ;
            VImpf (AgP2 Pl) => impfP2Pl ;
            VImpf (AgP3Pl) => impfP3Pl ;
            VImp (Pl) => impSg ;
            VImp (Sg) => impPl
            } ;
          info : VerbInfo = mkVerbInfo class form root patt impSg ;
        in lin V  {
          s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
          i = info ;
        } ;

      } ; --end of mkV overload


    {- ~~~ Strong Verb ~~~ -}

    -- Regular strong verb ("sħiħ"), eg KITEB
    strongV : V = overload {

      -- Params: root, pattern
      strongV : Root -> Pattern -> V = \root,patt ->
        let imp = conjStrongImp root patt
        in strongVWorst root patt imp ;

      -- Params: root, pattern, imperative P2Sg
      strongV : Root -> Pattern -> Str -> V =\root,patt,imp_sg ->
        let
          imp = table {
            Sg => imp_sg ;
            Pl => (takePfx 3 imp_sg) + root.C3 + "u" -- IFTAĦ > IFTĦU
            } ;
        in strongVWorst root patt imp ;

      } ;

    -- Worst case for strong verb
    strongVWorst : Root -> Pattern -> (Number => Str) -> V = \root,patt,imp ->
      let
        tbl : (VForm => Str) = table {
          VPerf agr => ( conjStrongPerf root patt ) ! agr ;
          VImpf agr => ( conjStrongImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        info : VerbInfo = mkVerbInfo (Strong Regular) (FormI) root patt (imp ! Sg) ;
      in lin V {
        s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
        i = info ;
      } ;


    {- ~~~ Liquid-Medial Verb ~~~ -}

    -- Liquid-medial strong verb, eg ŻELAQ
    liquidMedialV : V = overload {

      -- Params: root, pattern
      liquidMedialV : Root -> Pattern -> V = \root,patt ->
        let imp = conjLiquidMedialImp root patt
        in liquidMedialVWorst root patt imp ;

      -- Params: root, pattern, imperative P2Sg
      liquidMedialV : Root -> Pattern -> Str -> V = \root,patt,imp_sg ->
        let
          vowels = extractPattern imp_sg ;
          imp = table {
            Sg => imp_sg ;
            Pl => case root.C1 of {
              "għ" => vowels.V1 + root.C1 + root.C2 + root.C3 + "u" ; -- AGĦMEL > AGĦMLU
                _ => vowels.V1 + root.C1 + vowels.V2 + root.C2 + root.C3 + "u" -- OĦROĠ > OĦORĠU
              }
            } ;
        in liquidMedialVWorst root patt imp ;

      } ;

    -- Worst case for liquid medial strong verb
    liquidMedialVWorst : Root -> Pattern -> (Number => Str) -> V = \root,patt,imp ->
      let
        tbl : (VForm => Str) = table {
          VPerf agr => ( conjLiquidMedialPerf root patt ) ! agr ;
          VImpf agr => ( conjLiquidMedialImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        info : VerbInfo = mkVerbInfo (Strong LiquidMedial) (FormI) root patt (imp ! Sg) ;
      in lin V {
        s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
        i = info ;
      } ;

    {- ~~~ Geminated Verb ~~~ -}

    -- Geminated strong verb ("trux"), eg ĦABB
    geminatedV : V = overload {

      -- Params: root, pattern
      geminatedV : Root -> Pattern -> V = \root,patt ->
        let imp = conjGeminatedImp root patt
        in geminatedVWorst root patt imp ;
        
      -- Params: root, pattern, imperative P2Sg
      geminatedV : Root -> Pattern -> Str -> V = \root,patt,imp_sg ->
        let
          imp = table {
            Sg => imp_sg ;
            Pl => imp_sg + "u" -- ŻOMM > ŻOMMU
            } ;
        in geminatedVWorst root patt imp ;

      };

    -- Worst case for reduplicated verb
    geminatedVWorst : Root -> Pattern -> (Number => Str) -> V = \root,patt,imp ->
      let
        tbl : (VForm => Str) = table {
          VPerf agr => ( conjGeminatedPerf root patt ) ! agr ;
          VImpf agr => ( conjGeminatedImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        info : VerbInfo = mkVerbInfo (Strong Geminated) (FormI) root patt (imp ! Sg) ;
      in lin V {
        s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
        i = info ;
      } ;

    {- ~~~ Assimilative Verb ~~~ -}

    -- Assimilative weak verb, eg WASAL
    assimilativeV : V = overload {

      -- Params: root, pattern
      assimilativeV : Root -> Pattern -> V = \root,patt ->
        let imp = conjAssimilativeImp root patt
        in assimilativeVWorst root patt imp ;

      -- Params: root, pattern, imperative P2Sg
      assimilativeV : Root -> Pattern -> Str -> V =\root,patt,imp_sg ->
        let
          imp = table {
            Sg => imp_sg ;
            Pl => (dropSfx 2 imp_sg) + root.C3 + "u" -- ASAL > ASLU
            } ;
        in assimilativeVWorst root patt imp ;

      } ;

    -- Worst case for assimilative verb
    assimilativeVWorst : Root -> Pattern -> (Number => Str) -> V = \root,patt,imp ->
      let
        tbl : (VForm => Str) = table {
          VPerf agr => ( conjAssimilativePerf root patt ) ! agr ;
          VImpf agr => ( conjAssimilativeImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        info : VerbInfo = mkVerbInfo (Weak Assimilative) (FormI) root patt (imp ! Sg) ;
      in lin V {
        s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
        i = info ;
      } ;

    {- ~~~ Hollow Verb ~~~ -}

    -- Hollow weak verb, eg SAR (S-J-R)
    hollowV : V = overload {

      -- Params: root, pattern
      hollowV : Root -> Pattern -> V = \root,patt ->
        let imp = conjHollowImp root patt
        in hollowVWorst root patt imp ;

      -- Params: root, pattern, imperative P2Sg
      hollowV : Root -> Pattern -> Str -> V =\root,patt,imp_sg ->
        let
          imp = table {
            Sg => imp_sg ;
            Pl => imp_sg + "u" -- SIR > SIRU
            } ;
        in hollowVWorst root patt imp ;

      } ;

    -- Worst case for hollow verb
    hollowVWorst : Root -> Pattern -> (Number => Str) -> V = \root,patt,imp ->
      let
        tbl : (VForm => Str) = table {
          VPerf agr => ( conjHollowPerf root patt ) ! agr ;
          VImpf agr => ( conjHollowImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        info : VerbInfo = mkVerbInfo (Weak Hollow) (FormI) root patt (imp ! Sg) ;
      in lin V {
        s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
        i = info ;
      } ;

    {- ~~~ Lacking Verb ~~~ -}

    -- Lacking (nieqes) verb, eg MEXA (M-X-J)
    lackingV : V = overload {

      -- Params: root, pattern
      lackingV : Root -> Pattern -> V = \root,patt ->
        let imp = conjLackingImp root patt
        in lackingVWorst root patt imp ;

      -- Params: root, pattern, imperative P2Sg
      lackingV : Root -> Pattern -> Str -> V =\root,patt,imp_sg ->
        let
          imp = table {
            Sg => imp_sg ;
            Pl => (takePfx 3 imp_sg) + "u" -- IMXI > IMXU
            } ;
        in lackingVWorst root patt imp ;

      } ;

    -- Worst case for lacking verb
    lackingVWorst : Root -> Pattern -> (Number => Str) -> V = \root,patt,imp ->
      let
        tbl : (VForm => Str) = table {
          VPerf agr => ( conjLackingPerf root patt ) ! agr ;
          VImpf agr => ( conjLackingImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        info : VerbInfo = mkVerbInfo (Weak Lacking) (FormI) root patt (imp ! Sg) ;
      in lin V {
        s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
        i = info ;
      } ;

    {- ~~~ Defective Verb ~~~ -}

    -- Defective verb, eg QALA' (Q-L-GĦ)
    defectiveV : V = overload {

      -- Params: root, pattern
      defectiveV : Root -> Pattern -> V = \root,patt ->
        let imp = conjDefectiveImp root patt
        in defectiveVWorst root patt imp ;

      -- Params: root, pattern, imperative P2Sg
      defectiveV : Root -> Pattern -> Str -> V =\root,patt,imp_sg ->
        let
          imp = table {
            Sg => imp_sg ;
            Pl => (takePfx 2 imp_sg) + "i" + root.C2 + "għu" -- ISMA' > ISIMGĦU
            } ;
        in defectiveVWorst root patt imp ;

      } ;

    -- Worst case for defective verb
    defectiveVWorst : Root -> Pattern -> (Number => Str) -> V = \root,patt,imp ->
      let
        tbl : (VForm => Str) = table {
          VPerf agr => ( conjDefectivePerf root patt ) ! agr ;
          VImpf agr => ( conjDefectiveImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        info : VerbInfo = mkVerbInfo (Weak Defective) (FormI) root patt (imp ! Sg) ;
      in lin V {
        s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
        i = info ;
      } ;

    {- ~~~ Quadriliteral Verb (Strong) ~~~ -}

    -- Make a Quad verb, eg DENDEL (D-L-D-L)
    quadV : V = overload {

      -- Params: root, pattern
      quadV : Root -> Pattern -> V = \root,patt ->
        let imp = conjQuadImp root patt
        in quadVWorst root patt imp ;

      -- Params: root, pattern, imperative P2Sg
      quadV : Root -> Pattern -> Str -> V =\root,patt,imp_sg ->
        let
          imp = table {
            Sg => imp_sg ;
            Pl => (takePfx 4 imp_sg) + root.C4 + "u" -- ĦARBAT > ĦARBTU
            } ;
        in quadVWorst root patt imp ;

      } ;

    -- Worst case for quad verb
    quadVWorst : Root -> Pattern -> (Number => Str) -> V = \root,patt,imp ->
      let
        tbl : (VForm => Str) = table {
          VPerf agr => ( conjQuadPerf root patt ) ! agr ;
          VImpf agr => ( conjQuadImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        info : VerbInfo = mkVerbInfo (Quad QStrong) (FormI) root patt (imp ! Sg) ;
      in lin V {
        s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
        i = info ;
      } ;

    {- ~~~ Quadriliteral Verb (Weak Final) ~~~ -}

    -- Make a weak-final Quad verb, eg SERVA (S-R-V-J)
    quadWeakV : V = overload {

      -- Params: root, pattern
      quadWeakV : Root -> Pattern -> V = \root,patt ->
        let imp = conjQuadWeakImp root patt
        in quadWeakVWorst root patt imp ;

      -- Params: root, pattern, imperative P2Sg
      quadWeakV : Root -> Pattern -> Str -> V =\root,patt,imp_sg ->
        let
          imp = table {
            Sg => imp_sg ;
            Pl => case (takeSfx 1 imp_sg) of {
              "a" => imp_sg + "w" ; -- KANTA > KANTAW
              _ => (dropSfx 1 imp_sg) + "u" -- SERVI > SERVU
              }
            } ;
        in quadWeakVWorst root patt imp ;

      } ;

    -- Worst case for quadWeak verb
    quadWeakVWorst : Root -> Pattern -> (Number => Str) -> V = \root,patt,imp ->
      let
        tbl : (VForm => Str) = table {
          VPerf agr => ( conjQuadWeakPerf root patt (imp ! Sg) ) ! agr ;
          VImpf agr => ( conjQuadWeakImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        info : VerbInfo = mkVerbInfo (Quad QWeak) (FormI) root patt (imp ! Sg) ;
      in lin V {
        s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
        i = info ;
      } ;

    {- ~~~ Non-semitic verbs ~~~ -}

    -- Make a loan verb, eg IPPARKJA
    -- Params: mamma
    loanV : Str -> V = \mamma ->
      let
        imp = conjLoanImp mamma ;
        tbl : (VForm => Str) = table {
          VPerf agr => ( conjLoanPerf mamma ) ! agr ;
          VImpf agr => ( conjLoanImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        info : VerbInfo = mkVerbInfo (Loan) (FormI) (imp ! Sg) ;
      in lin V {
        s = verbPolarityTable info (verbPronSuffixTable info tbl) ;
        i = info ;
      } ;


    {- ===== Adjective Paradigms ===== -}

    -- Overloaded function for building an adjective
    mkA : A = overload {

      -- Same form for gender and number; no comparative form.
      -- Params:
        -- Adjective, eg BLU
      mkA : Str -> A = sameA ;

      -- Infer feminine from masculine; no comparative form.
      -- Params:
        -- Masculine, eg SABIĦ
        -- Plural, eg SBIEĦ
      mkA : Str -> Str -> A = brokenA ;

      -- Infer feminine from masculine; no comparative form.
      -- Params:
        -- Masculine, eg SABIĦ
        -- Feminine, eg SABIĦA
        -- Plural, eg SBIEĦ
      mkA : Str -> Str -> Str -> A = mk3A ;

      -- Take all forms.
      -- Params:
        -- Masculine, eg SABIĦ
        -- Feminine, eg SABIĦA
        -- Plural, eg SBIEĦ
        -- Comparative, eg ISBAĦ
      mkA : Str -> Str -> Str -> Str -> A = mk4A ;

    } ;

    -- Regular adjective with predictable feminine and plural forms
    regA : Str -> A ;
    regA masc =
      let
        fem = determineAdjFem masc ;
        plural = determineAdjPlural fem
      in
      mk3A masc fem plural ;

    -- Adjective with same forms for masculine, feminine and plural.
    sameA : Str -> A ;
    sameA a = mk3A a a a ;

    -- Adjective with predictable feminine but broken plural
    brokenA = overload {

      -- without comparative form
      brokenA : Str -> Str -> A = \masc,plural ->
        let
          fem = determineAdjFem masc
        in
        mk3A masc fem plural ;

      -- with comparative form
      brokenA : Str -> Str -> Str -> A = \masc,plural,compar ->
        let
          fem = determineAdjFem masc
        in
        mk4A masc fem plural compar ;

      } ;

    -- Build an adjective noun using all 3 forms, when it has no comparative form
    mk3A : (_,_,_ : Str) -> A ;
    mk3A = \masc,fem,plural ->
      lin A (mkAdjective masc fem plural []) ** {hasComp = False} ;

    -- Build an adjective noun using all 4 forms (superlative is trivial)
    mk4A : (_,_,_,_ : Str) -> A ;
    mk4A = \masc,fem,plural,compar ->
      lin A (mkAdjective masc fem plural compar) ** {hasComp = True} ;

    -- Determine femininine form of adjective from masculine
    determineAdjFem : Str -> Str ;
    determineAdjFem masc = case masc of {
      _ + "ef" => (dropSfx 2 masc) + "fa" ; -- NIEXEF
      _ + "u" => (init masc) + "a" ; -- BRAVU
      _ + "i" => masc + "ja" ; -- MIMLI
      _ => masc + "a" -- VOJT
      } ;

    -- Determine plural form of adjective from feminine
    determineAdjPlural : Str -> Str ;
    determineAdjPlural fem = case fem of {
      _ + ("f"|"j"|"ġ") + "a" => (init fem) + "in" ; -- NIEXFA, MIMLIJA, MAĦMUĠA
      _ => (init fem) + "i" -- BRAVA
      } ;

}
