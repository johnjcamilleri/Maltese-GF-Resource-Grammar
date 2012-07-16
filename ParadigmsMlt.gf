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
    -- Refer {MDG} pg190
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


    -- Overloaded function for building a noun
    -- Return: Noun
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
          _ + #Vowel + #Consonant + #Vowel + K@#Consonant => tk 2 coll + K ; -- eg GĦADAM -> GĦADM-

          _ => coll
        } ;
        -------
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
          _ + "ll" => tk 2 prep ;
          _ + "l"  => tk 1 prep ;
          _ => prep -- this should never happen, I don't think
        }
      in
      case noun of {
        ("s"|#LiquidCons) + #Consonant + _ => prep + "-i" + noun ;
        ("għ" | #Vowel) + _ => case prep of {
          ("fil"|"bil") => (take 1 prep) + "l-" + noun ;
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
        initPrepLetter = take 1 prep ;
        initNounLetter = take 1 noun
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


    {- ========== Verb paradigms ========== -}

    -- Takes a verb as a string and returns the VType and root/pattern.
    -- Used in smart paradigm below and elsewhere.
    -- Params: "Mamma" (Perf Per3 Sg Masc) as string (eg KITEB or ĦAREĠ)
    classifyVerb : Str -> { c:VClass ; r:Root ; p:Pattern } = \mamma -> case mamma of {

      -- Defective, BELA'
      c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel + c3@( "għ" | "'" ) =>
        { c=Weak Defective ; r=(mkRoot c1 c2 "għ") ; p=(mkPattern v1 v2) } ;

      -- Weak Final, MEXA
      c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel =>
        { c=Weak WeakFinal ; r=(mkRoot c1 c2 "j") ; p=(mkPattern v1 v2) } ;

      -- Hollow, SAB
      --- TODO determining of middle radical is not right, e.g. SAB = S-J-B
      c1@#Consonant + v1@"a"  + c3@#Consonant =>
        { c=Weak Hollow ; r=(mkRoot c1 "w" c3) ; p=(mkPattern v1) } ;
      c1@#Consonant + v1@"ie" + c3@#Consonant =>
        { c=Weak Hollow ; r=(mkRoot c1 "j" c3) ; p=(mkPattern v1) } ;

      -- Weak Assimilative, WAQAF
      c1@#WeakCons + v1@#Vowel + c2@#Consonant + v2@#Vowel  + c3@#Consonant =>
        { c=Weak Assimilative ; r=(mkRoot c1 c2 c3) ; p=(mkPattern v1 v2) } ;

      -- Strong Reduplicated, ĦABB
      c1@#Consonant + v1@#Vowel + c2@#Consonant + c3@#Consonant =>
        { c=Strong Reduplicated ; r=(mkRoot c1 c2 c3) ; p=(mkPattern v1) } ;

      -- Strong LiquidMedial, ŻELAQ
      c1@#Consonant + v1@#Vowel + c2@(#LiquidCons | "għ") + v2@#Vowel + c3@#Consonant =>
        { c=Strong LiquidMedial ; r=(mkRoot c1 c2 c3) ; p=(mkPattern v1 v2) } ;

      -- Strong Regular, QATEL
      c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel + c3@#Consonant =>
        { c=Strong Regular ; r=(mkRoot c1 c2 c3) ; p=(mkPattern v1 v2) } ;

      -- Quad, QAĊĊAT
      c1@#Consonant + v1@#Vowel + c2@#Consonant + c3@#Consonant + v2@#Vowel + c4@#Consonant =>
        { c=Quad ; r=(mkRoot c1 c2 c3 c4) ; p=(mkPattern v1 v2) } ;

      -- Assume it is a loan verb
      _ => { c=Loan ; r=mkRoot ; p=mkPattern }
    } ;

    -- Smart paradigm for building a verb
    mkV : V = overload {

      -- Tries to do everything just from the mamma of the verb
      -- Params:
      -- "Mamma" (Perf Per3 Sg Masc) as string (eg KITEB or ĦAREĠ)
      mkV : Str -> V = \mamma ->
        let
          class = classifyVerb mamma
        in
        case class.c of {
          Strong Regular      => strongV class.r class.p ;
          Strong LiquidMedial => liquidMedialV class.r class.p ;
          Strong Reduplicated => reduplicatedV class.r class.p ;
          Weak Assimilative   => assimilativeV class.r class.p ;
          Weak Hollow         => hollowV class.r class.p ;
          Weak WeakFinal      => weakFinalV class.r class.p ;
          Weak Defective      => defectiveV class.r class.p ;
          Quad                => quadV class.r class.p ;
          Loan                => loanV mamma
--          _ => Predef.error("Unimplemented")
        } ;

      -- Same as above but also takes an Imperative of the word for when it behaves less predictably
      -- Params:
      -- "Mamma" (Perf Per3 Sg Masc) as string (eg KITEB or ĦAREĠ )
      -- Imperative Singular as a string (eg IKTEB or OĦROĠ )
      -- Imperative Plural as a string (eg IKTBU or OĦORĠU )
      mkV : Str -> Str -> Str -> V = \mamma,imp_sg,imp_pl ->
        let
          class = classifyVerb mamma
        in lin V {
          s = table {
            VPerf agr => case class.c of {
              Strong Regular      => (conjStrongPerf class.r class.p) ! agr ;
              Strong LiquidMedial => (conjLiquidMedialPerf class.r class.p) ! agr ;
              Strong Reduplicated => (conjReduplicatedPerf class.r class.p) ! agr ;
              Weak Assimilative   => (conjAssimilativePerf class.r class.p) ! agr ;
              Weak Hollow         => (conjHollowPerf class.r class.p) ! agr ;
              Weak WeakFinal      => (conjWeakFinalPerf class.r class.p) ! agr ;
              Weak Defective      => (conjDefectivePerf class.r class.p) ! agr ;
              Quad                => (conjQuadPerf class.r class.p) ! agr ;
              Loan                => (loanV mamma imp_sg).s ! VPerf agr
              } ;
            VImpf agr => case class.c of {
              Strong Regular      => (conjStrongImpf imp_sg imp_pl) ! agr ;
              Strong LiquidMedial => (conjLiquidMedialImpf imp_sg imp_pl) ! agr ;
              Strong Reduplicated => (conjReduplicatedImpf imp_sg imp_pl) ! agr ;
              Weak Assimilative   => (conjAssimilativeImpf imp_sg imp_pl) ! agr ;
              Weak Hollow         => (conjHollowImpf imp_sg imp_pl) ! agr ;
              Weak WeakFinal      => (conjWeakFinalImpf imp_sg imp_pl) ! agr ;
              Weak Defective      => (conjDefectiveImpf imp_sg imp_pl) ! agr ;
              Quad                => (conjQuadImpf imp_sg imp_pl) ! agr ;
              Loan                => (loanV mamma imp_sg).s ! VImpf agr
              } ;
            VImp n => table { Sg => imp_sg ; Pl => imp_pl } ! n
            } ;
          c = class.c ;
        } ;

      } ; --end of mkV overload

    -- Conjugate imperfect tense from imperative by adding initial letters
    -- Ninu, Toninu, Jaħasra, Toninu; Ninu, Toninu, Jaħasra
    conjGenericImpf : Str -> Str -> (Agr => Str) = \stem_sg,stem_pl ->
      table {
        AgP1 Sg    => "n" + stem_sg ;  -- Jiena NIŻLOQ
        AgP2 Sg    => "t" + stem_sg ;  -- Inti TIŻLOQ
        AgP3Sg Masc  => "j" + stem_sg ;  -- Huwa JIŻLOQ
        AgP3Sg Fem  => "t" + stem_sg ;  -- Hija TIŻLOQ
        AgP1 Pl    => "n" + stem_pl ;  -- Aħna NIŻOLQU
        AgP2 Pl    => "t" + stem_pl ;  -- Intom TIŻOLQU
        AgP3Pl    => "j" + stem_pl  -- Huma JIŻOLQU
      } ;

    {- ----- Strong Verb ----- -}

    -- Regular strong verb ("sħiħ"), eg KITEB
    -- Params: Root, Pattern
    strongV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjStrongImp r p ;
      in lin V {
        s = table {
          VPerf agr => ( conjStrongPerf r p ) ! agr ;
          VImpf agr => ( conjStrongImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
        } ;
        c = Strong Regular ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjStrongPerf : Root -> Pattern -> (Agr => Str) = \root,p ->
      let
        ktib = root.C1 + root.C2 + (case p.V2 of {"e" => "i" ; _ => p.V2 }) + root.C3 ;
        kitb = root.C1 + p.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => ktib + "t" ;  -- Jiena KTIBT
          AgP2 Sg    => ktib + "t" ;  -- Inti KTIBT
          AgP3Sg Masc  => root.C1 + p.V1 + root.C2 + p.V2 + root.C3 ;  -- Huwa KITEB
          AgP3Sg Fem  => kitb + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija KITBET
          AgP1 Pl    => ktib + "na" ;  -- Aħna KTIBNA
          AgP2 Pl    => ktib + "tu" ;  -- Intom KTIBTU
          AgP3Pl    => kitb + "u"  -- Huma KITBU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
    conjStrongImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjStrongImp : Root -> Pattern -> (Number => Str) = \root,p ->
      let
        stem_sg = case (p.V1 + p.V2) of {
          "aa" => "o" + root.C1 + root.C2 + "o" + root.C3 ; -- RABAT > ORBOT
          "ae" => "a" + root.C1 + root.C2 + "e" + root.C3 ; -- GĦAMEL > AGĦMEL
          "ee" => "i" + root.C1 + root.C2 + "e" + root.C3 ; -- FEHEM > IFHEM
          "ea" => "i" + root.C1 + root.C2 + "a" + root.C3 ; -- FETAĦ > IFTAĦ
          "ie" => "i" + root.C1 + root.C2 + "e" + root.C3 ; -- KITEB > IKTEB
          "oo" => "o" + root.C1 + root.C2 + "o" + root.C3   -- GĦOĠOB > OGĦĠOB
        } ;
        stem_pl = case (p.V1 + p.V2) of {
          "aa" => "o" + root.C1 + root.C2 + root.C3 ; -- RABAT > ORBTU
          "ae" => "a" + root.C1 + root.C2 + root.C3 ; -- GĦAMEL > AGĦMLU
          "ee" => "i" + root.C1 + root.C2 + root.C3 ; -- FEHEM > IFHMU
          "ea" => "i" + root.C1 + root.C2 + root.C3 ; -- FETAĦ > IFTĦU
          "ie" => "i" + root.C1 + root.C2 + root.C3 ; -- KITEB > IKTBU
          "oo" => "o" + root.C1 + root.C2 + root.C3   -- GĦOĠOB > OGĦĠBU
        } ;
      in
        table {
          Sg => stem_sg ;  -- Inti:  IKTEB
          Pl => stem_pl + "u"  -- Intom: IKTBU
        } ;

    {- ----- Liquid-Medial Verb ----- -}

    -- Liquid-medial strong verb, eg ŻELAQ
    -- Params: Root, Pattern
    liquidMedialV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjLiquidMedialImp r p ;
      in lin V {
        s = table {
          VPerf agr => ( conjLiquidMedialPerf r p ) ! agr ;
          VImpf agr => ( conjLiquidMedialImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
        } ;
        c = Strong LiquidMedial ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjLiquidMedialPerf : Root -> Pattern -> (Agr => Str) = \root,p ->
      let
        zlaq = root.C1 + root.C2 + (case p.V2 of {"e" => "i" ; _ => p.V2 }) + root.C3 ;
        zelq = root.C1 + p.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => zlaq + "t" ;  -- Jiena ŻLAQT
          AgP2 Sg    => zlaq + "t" ;  -- Inti ŻLAQT
          AgP3Sg Masc  => root.C1 + p.V1 + root.C2 + p.V2 + root.C3 ;  -- Huwa ŻELAQ
          AgP3Sg Fem  => zelq + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija ŻELQET
          AgP1 Pl    => zlaq + "na" ;  -- Aħna ŻLAQNA
          AgP2 Pl    => zlaq + "tu" ;  -- Intom ŻLAQTU
          AgP3Pl    => zelq + "u"  -- Huma ŻELQU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IŻLOQ), Imperative Plural (eg IŻOLQU)
    conjLiquidMedialImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjLiquidMedialImp : Root -> Pattern -> (Number => Str) = \root,p ->
      let
        stem_sg = case (p.V1 + p.V2) of {
          "aa" => "i" + root.C1 + root.C2 + "o" + root.C3 ; -- TALAB > ITLOB
          "ae" => "o" + root.C1 + root.C2 + "o" + root.C3 ; -- ĦAREĠ > OĦROĠ
          "ee" => "e" + root.C1 + root.C2 + "e" + root.C3 ; -- ĦELES > EĦLES
          "ea" => "i" + root.C1 + root.C2 + "o" + root.C3 ; -- ŻELAQ > IŻLOQ
          "ie" => "i" + root.C1 + root.C2 + "e" + root.C3 ; -- DILEK > IDLEK
          "oo" => "i" + root.C1 + root.C2 + "o" + root.C3   -- XOROB > IXROB
        } ;
        stem_pl = case (p.V1 + p.V2) of {
          "aa" => "i" + root.C1 + "o" + root.C2 + root.C3 ; -- TALAB > ITOLBU
          "ae" => "o" + root.C1 + "o" + root.C2 + root.C3 ; -- ĦAREĠ > OĦORĠU
          "ee" => "e" + root.C1 + "i" + root.C2 + root.C3 ; -- ĦELES > EĦILSU
          "ea" => "i" + root.C1 + "o" + root.C2 + root.C3 ; -- ŻELAQ > IŻOLQU
          "ie" => "i" + root.C1 + "i" + root.C2 + root.C3 ; -- DILEK > IDILKU
          "oo" => "i" + root.C1 + "o" + root.C2 + root.C3   -- XOROB > IXORBU
        } ;
      in
        table {
          Sg => stem_sg ;  -- Inti: IŻLOQ
          Pl => stem_pl + "u"  -- Intom: IŻOLQU
        } ;

    {- ----- Reduplicated Verb ----- -}

    -- Reduplicated strong verb ("trux"), eg ĦABB
    -- Params: Root, Pattern
    reduplicatedV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjReduplicatedImp r p ;
      in lin V {
        s = table {
          VPerf agr => ( conjReduplicatedPerf r p ) ! agr ;
          VImpf agr => ( conjReduplicatedImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
        } ;
        c = Strong Reduplicated ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjReduplicatedPerf : Root -> Pattern -> (Agr => Str) = \root,p ->
      let
        habb = root.C1 + p.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => habb + "ejt" ;  -- Jiena ĦABBEJT
          AgP2 Sg    => habb + "ejt" ;  -- Inti ĦABBEJT
          AgP3Sg Masc  => habb ;  -- Huwa ĦABB
          AgP3Sg Fem  => habb + "et" ;  -- Hija ĦABBET
          AgP1 Pl    => habb + "ejna" ;  -- Aħna ĦABBEJNA
          AgP2 Pl    => habb + "ejtu" ;  -- Intom ĦABBEJTU
          AgP3Pl    => habb + "ew"  -- Huma ĦABBU/ĦABBEW
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
    conjReduplicatedImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjReduplicatedImp : Root -> Pattern -> (Number => Str) = \root,p ->
      let
        stem_sg = case p.V1 of {
          "e" => root.C1 + p.V1 + root.C2 + root.C3 ; -- BEXX > BEXX (?)
          _ => root.C1 + "o" + root.C2 + root.C3 -- ĦABB > ĦOBB
        } ;
      in
        table {
          Sg => stem_sg ;  -- Inti: ĦOBB
          Pl => stem_sg + "u"  -- Intom: ĦOBBU
        } ;

    {- ----- Assimilative Verb ----- -}

    -- Assimilative weak verb, eg WASAL
    -- Params: Root, Pattern
    assimilativeV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjAssimilativeImp r p ;
      in lin V {
        s = table {
          VPerf agr => ( conjAssimilativePerf r p ) ! agr ;
          VImpf agr => ( conjAssimilativeImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
        } ;
        c = Weak Assimilative ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjAssimilativePerf : Root -> Pattern -> (Agr => Str) = \root,p ->
      let
        wasal = root.C1 + p.V1 + root.C2 + p.V2 + root.C3 ;
        wasl  = root.C1 + p.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => wasal + "t" ;  -- Jiena WASALT
          AgP2 Sg    => wasal + "t" ;  -- Inti WASALT
          AgP3Sg Masc  => wasal ;  -- Huwa WASAL
          AgP3Sg Fem  => wasl + "et" ;  -- Hija WASLET
          AgP1 Pl    => wasal + "na" ;  -- Aħna WASALNA
          AgP2 Pl    => wasal + "tu" ;  -- Intom WASALTU
          AgP3Pl    => wasl + "u"  -- Huma WASLU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg ASAL), Imperative Plural (eg ASLU)
    conjAssimilativeImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjAssimilativeImp : Root -> Pattern -> (Number => Str) = \root,p ->
      table {
        Sg => p.V1 + root.C2 + p.V2 + root.C3 ;  -- Inti: ASAL
        Pl => p.V1 + root.C2 + root.C3 + "u"  -- Intom: ASLU
      } ;

    {- ----- Hollow Verb ----- -}

    -- Hollow weak verb, eg SAR (S-J-R)
    -- Params: Root, Pattern
    hollowV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjHollowImp r p ;
      in lin V {
        s = table {
          VPerf agr => ( conjHollowPerf r p ) ! agr ;
          VImpf agr => ( conjHollowImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
        } ;
        c = Weak Hollow ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjHollowPerf : Root -> Pattern -> (Agr => Str) = \root,p ->
      let
        sar = root.C1 + p.V1 + root.C3 ;
        sir = case root.C2 of { --- this is not really backed up
          "j" => root.C1 + "i" + root.C3 ; -- SAR (S-J-R) > SIR-
          "w" => root.C1 + "o" + root.C3 ; -- DAM (D-W-M) > DOM-
          _ => root.C1 + p.V1 + root.C3
          }
      in
      table {
        AgP1 Sg    => sir + "t" ;  -- Jiena SIRT
        AgP2 Sg    => sir + "t" ;  -- Inti SIRT
        AgP3Sg Masc  => sar ;  -- Huwa SAR
        AgP3Sg Fem  => sar + "et" ;  -- Hija SARET
        AgP1 Pl    => sir + "na" ;  -- Aħna SIRNA
        AgP2 Pl    => sir + "tu" ;  -- Intom SIRTU
        AgP3Pl    => sar + "u"  -- Huma SARU
      } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IMXI), Imperative Plural (eg IMXU)
    conjHollowImpf = conjGenericImpf ; --- TODO!

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjHollowImp : Root -> Pattern -> (Number => Str) = \root,p ->
      let
        sir = case root.C2 of { --- this is not really backed up
          "j" => root.C1 + "i" + root.C3 ; -- SAR (S-J-R) > SIR
          "w" => root.C1 + "u" + root.C3 ; -- DAM (D-W-M) > DUM
          _ => root.C1 + p.V1 + root.C3
          }
      in
      table {
        Sg => sir ;  -- Inti: SIR
        Pl => sir + "u"  -- Intom: SIRU
      } ;

    {- ----- Weak-Final Verb ----- -}

    -- Weak-Final verb, eg MEXA (M-X-J)
    -- Make a verb by calling generate functions for each tense
    weakFinalV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjWeakFinalImp r p ;
      in lin V {
        s = table {
          VPerf agr => ( conjWeakFinalPerf r p ) ! agr ;
          VImpf agr => ( conjWeakFinalImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
        } ;
        c = Weak WeakFinal ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjWeakFinalPerf : Root -> Pattern -> (Agr => Str) = \root,p ->
      let
        stem_12 = root.C1 + root.C2 + (case p.V2 of {"e" => "i" ; _ => p.V2 }) + "j" ; -- "AGĦ" -> "AJ"
        stem_3 = root.C1 + p.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => stem_12 + "t" ;  -- Jiena IMXEJT
          AgP2 Sg    => stem_12 + "t" ;  -- Inti IMXEJT
          AgP3Sg Masc  => root.C1 + p.V1 + root.C2 + p.V2 + "'" ;  -- Huwa MEXA
          AgP3Sg Fem  => stem_3 + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija IMXIET
          AgP1 Pl    => stem_12 + "na" ;  -- Aħna IMXEJNA
          AgP2 Pl    => stem_12 + "tu" ;  -- Intom IMXEJTU
          AgP3Pl    => stem_3 + "u"  -- Huma IMXEW
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IMXI), Imperative Plural (eg IMXU)
    conjWeakFinalImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjWeakFinalImp : Root -> Pattern -> (Number => Str) = \root,p ->
      let
        v1 = case p.V1 of { "e" => "i" ; _ => p.V1 } ;
        v_pl = case p.V1 of { "a" => "i" ; _ => "" } ; -- some verbs require "i" insertion in middle (eg AQILGĦU)
      in
        table {
          Sg => v1 + root.C1 + root.C2 + p.V2 + "'" ;  -- Inti: IMXI
          Pl => v1 + root.C1 + v_pl + root.C2 + root.C3 + "u"  -- Intom: IMXU
        } ;

    {- ----- Defective Verb ----- -}

    -- Defective verb, eg SAMA' (S-M-GĦ)
    -- Make a verb by calling generate functions for each tense
    -- Params: Root, Pattern
    defectiveV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjDefectiveImp r p ;
      in lin V {
        s = table {
          VPerf agr => ( conjDefectivePerf r p ) ! agr ;
          VImpf agr => ( conjDefectiveImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
        } ;
        c = Weak Defective ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjDefectivePerf : Root -> Pattern -> ( Agr => Str ) = \root,p ->
      let
        stem_12 = root.C1 + root.C2 + (case p.V2 of {"e" => "i" ; _ => p.V2 }) + "j" ; -- "AGĦ" -> "AJ"
        stem_3 = root.C1 + p.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => stem_12 + "t" ;  -- Jiena QLAJT
          AgP2 Sg    => stem_12 + "t" ;  -- Inti QLAJT
          AgP3Sg Masc  => root.C1 + p.V1 + root.C2 + p.V2 + "'" ;  -- Huwa QALA'
          AgP3Sg Fem  => stem_3 + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija QALGĦET
          AgP1 Pl    => stem_12 + "na" ;  -- Aħna QLAJNA
          AgP2 Pl    => stem_12 + "tu" ;  -- Intom QLAJTU
          AgP3Pl    => stem_3 + "u"  -- Huma QALGĦU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
    conjDefectiveImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjDefectiveImp : Root -> Pattern -> ( Number => Str ) = \root,p ->
      let
        v1 = case p.V1 of { "e" => "i" ; _ => p.V1 } ;
        v_pl = case p.V1 of { "a" => "i" ; _ => "" } ; -- some verbs require "i" insertion in middle (eg AQILGĦU)
      in
        table {
          Sg => v1 + root.C1 + root.C2 + p.V2 + "'" ;  -- Inti:  AQLA' / IBŻA'
          Pl => v1 + root.C1 + v_pl + root.C2 + root.C3 + "u"  -- Intom: AQILGĦU / IBŻGĦU
        } ;

    {- ----- Quadriliteral Verb ----- -}

    -- Make a Quad verb, eg QARMEĊ (Q-R-M-Ċ)
    -- Make a verb by calling generate functions for each tense
    -- Params: Root, Pattern
    quadV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjQuadImp r p ;
      in lin V {
        s = table {
          VPerf agr => ( conjQuadPerf r p ) ! agr ;
          VImpf agr => ( conjQuadImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        c = Quad ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    -- Return: Lookup table of Agr against Str
    conjQuadPerf : Root -> Pattern -> ( Agr => Str ) = \root,p ->
      let
        stem_12 = root.C1 + p.V1 + root.C2 + root.C3 + (case p.V2 of {"e" => "i" ; _ => p.V2 }) + root.C4 ;
        stem_3 = root.C1 + p.V1 + root.C2 + root.C3 + root.C4 ;
      in
      table {
        AgP1 Sg    => stem_12 + "t" ;  -- Jiena DARDART
        AgP2 Sg    => stem_12 + "t" ;  -- Inti DARDART
        AgP3Sg Masc  => root.C1 + p.V1 + root.C2 + root.C3 + p.V2 + root.C4 ;  -- Huwa DARDAR
        AgP3Sg Fem  => stem_3 + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija DARDRET
        AgP1 Pl    => stem_12 + "na" ;  -- Aħna DARDARNA
        AgP2 Pl    => stem_12 + "tu" ;  -- Intom DARDARTU
        AgP3Pl    => stem_3 + "u"  -- Huma DARDRU
      } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg ____), Imperative Plural (eg ___)
    -- Return: Lookup table of Agr against Str
    conjQuadImpf : Str -> Str -> ( Agr => Str ) = \stem_sg,stem_pl ->
      let
        prefix_dbl:Str = case stem_sg of {
          X@( "d" | "t" ) + _ => "i" + X ;
          _ => "t"
          } ;
      in
      table {
        AgP1 Sg    => "in" + stem_sg ;      -- Jiena INDARDAR
        AgP2 Sg    => prefix_dbl + stem_sg ;  -- Inti IDDARDAR
        AgP3Sg Masc  => "i" + stem_sg ;      -- Huwa IDARDAR
        AgP3Sg Fem  => prefix_dbl + stem_sg ;  -- Hija IDDARDAR
        AgP1 Pl    => "in" + stem_pl ;      -- Aħna INDARDRU
        AgP2 Pl    => prefix_dbl + stem_pl ;  -- Intom IDDARDRU
        AgP3Pl    => "i" + stem_pl      -- Huma IDARDRU
      } ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    -- Return: Lookup table of Number against Str
    conjQuadImp : Root -> Pattern -> ( Number => Str ) = \root,p ->
      table {
        Sg => root.C1 + p.V1 + root.C2 + root.C3 + p.V2 + root.C4 ;  -- Inti:  DARDAR
        Pl => root.C1 + p.V1 + root.C2 + root.C3 + root.C4 + "u"  -- Intom: DARDRU
      } ;


    {- ----- Non-semitic verbs ----- -}

    loanV : V = overload {

    -- Loan verb: Italian integrated -ARE, eg KANTA
    -- Follows Maltese weak verb class 2 {MDG pg249,379}
    -- Params: mamma
    loanV : Str -> V = \kanta ->
      let
        kantaw = kanta + "w" ;
      in lin V {
        s = table {
          VPerf agr => table {
            AgP1 Sg    => kanta + "jt" ;  -- Jiena KANTAJT
            AgP2 Sg    => kanta + "jt" ;  -- Inti KANTAJT
            AgP3Sg Masc  => kanta ; -- Huwa KANTA
            AgP3Sg Fem  => kanta + "t" ;  -- Hija KANTAT
            AgP1 Pl    => kanta + "jna" ;  -- Aħna KANTAJNA
            AgP2 Pl    => kanta + "jtu" ;  -- Intom KANTAJTU
            AgP3Pl    => kanta + "w"  -- Huma KANTAW
            } ! agr ;
          VImpf agr => table {
            AgP1 Sg    => "n" + kanta ;  -- Jiena NKANTA
            AgP2 Sg    => "t" + kanta ;  -- Inti TKANTA
            AgP3Sg Masc  => "j" + kanta ;  -- Huwa JKANTA
            AgP3Sg Fem  => "t" + kanta ;  -- Hija TKANTA
            AgP1 Pl    => "n" + kantaw ;  -- Aħna NKANTAW
            AgP2 Pl    => "t" + kantaw ;  -- Intom TKANTAW
            AgP3Pl    => "j" + kantaw  -- Huma JKANTAW
            } ! agr ;
          VImp n => table {
            Sg => kanta ;  -- Inti:  KANTA
            Pl => kantaw  -- Intom: KANTAW
            } ! n
          } ;
        c = Loan ;
        } ;

    -- Loan verb: Italian integrated -ERE/-IRE, eg VINĊA
    -- Follows Maltese weak verb class 1 {MDG pg249,379}
    -- Params: mamma, imperative P2Sg
    loanV : Str -> Str -> V = \vinca,vinci ->
      let
        vinc = tk 1 vinca ;
        vincu = vinc + "u" ;
      in lin V {
        s = table {
          VPerf agr => table {
            AgP1 Sg    => vinc + "ejt" ;  -- Jiena VINĊEJT
            AgP2 Sg    => vinc + "ejt" ;  -- Inti VINĊEJT
            AgP3Sg Masc  => vinca ; -- Huwa VINĊA
            AgP3Sg Fem  => vinc + "iet" ;  -- Hija VINĊIET
            AgP1 Pl    => vinc + "ejna" ;  -- Aħna VINĊEJNA
            AgP2 Pl    => vinc + "ejtu" ;  -- Intom VINĊEJTU
            AgP3Pl    => vinc + "ew"  -- Huma VINĊEJTU
            } ! agr ;
          VImpf agr => table {
            AgP1 Sg    => "in" + vinci ;  -- Jiena INVINĊI
            AgP2 Sg    => "t" + vinci ;  -- Inti TVINĊI
            AgP3Sg Masc  => "j" + vinci ;  -- Huwa JVINĊI
            AgP3Sg Fem  => "t" + vinci ;  -- Hija TVINĊI
            AgP1 Pl    => "n" + vincu ;  -- Aħna INVINĊU
            AgP2 Pl    => "t" + vincu ;  -- Intom TVINĊU
            AgP3Pl    => "j" + vincu  -- Huma JVINĊU
            } ! agr ;
          VImp n => table {
            Sg => vinci ;  -- Inti:  VINĊI
            Pl => vincu  -- Intom: VINĊU
            } ! n
          } ;
        c = Loan ;
        } ;

      } ;


    {- ===== Adjective Paradigms ===== -}

    -- Overloaded function for building an adjective
    -- Return: Adjective
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
      _ + "ef" => (tk 2 masc) + "fa" ; -- NIEXEF
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
