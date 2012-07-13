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
      lin N (mkNoun sing coll dual det ind gen) ;

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

      -- Quad, QAĊĊAT
      c1@#Consonant + v1@#Vowel + c2@#Consonant + c3@#Consonant + v2@#Vowel + c4@#Consonant =>
        { c=Quad ; r=(mkRoot c1 c2 c3 c4) ; p=(mkPattern v1 v2) } ;

      -- Defective, BELA'
      c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel + c3@( "għ" | "'" ) =>
        { c=Weak Defective ; r=(mkRoot c1 c2 "għ") ; p=(mkPattern v1 v2) } ;

      -- Weak Final, MEXA
      c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel =>
        { c=Weak WeakFinal ; r=(mkRoot c1 c2 "j") ; p=(mkPattern v1 v2) } ;

      -- Hollow, SAB
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
      c1@#Consonant + v1@#Vowel + c2@#LiquidCons + v2@#Vowel + c3@#Consonant =>
        { c=Strong LiquidMedial ; r=(mkRoot c1 c2 c3) ; p=(mkPattern v1 v2) } ;

      -- Strong Regular, QATEL
      c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel + c3@#Consonant =>
        { c=Strong Regular ; r=(mkRoot c1 c2 c3) ; p=(mkPattern v1 v2) } ;

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
          Strong _ => strongV class.r class.p ;
          Weak Defective => defectiveV class.r class.p ;
          Quad => quadV class.r class.p ;
          Loan => loanV mamma ;
          _ => Predef.error("Unimplemented")
        } ;

      -- Same as above but also takes an Imperative of the word for when it behaves less predictably
      -- Params:
      -- "Mamma" (Perf Per3 Sg Masc) as string (eg KITEB or ĦAREĠ )
      -- Imperative Singular as a string (eg IKTEB or OĦROĠ )
      -- Imperative Plural as a string (eg IKTBU or OĦORĠU )
      mkV : Str -> Str -> Str -> V = \mamma,imp_sg,imp_pl ->
        let
          class = classifyVerb mamma
        in
        case class.c of {
          Strong _ => {
            s = table {
              VPerf pgn => ( conjStrongPerf class.r class.p ) ! pgn ;
              VImpf pgn => ( conjStrongImpf imp_sg imp_pl ) ! pgn ;
              VImp n =>    table { Sg => imp_sg ; Pl => imp_pl } ! n
              } ;
            c = class.c ;
            } ;
          Weak Defective => {
            s = table {
              VPerf pgn => ( conjDefectivePerf class.r class.p ) ! pgn ;
              VImpf pgn => ( conjDefectiveImpf imp_sg imp_pl ) ! pgn ;
              VImp n =>    table { Sg => imp_sg ; Pl => imp_pl } ! n
              } ;
            c = class.c ;
            } ;
          Quad => {
            s = table {
              VPerf pgn => ( conjQuadPerf class.r class.p ) ! pgn ;
              VImpf pgn => ( conjQuadImpf imp_sg imp_pl ) ! pgn ;
              VImp n =>    table { Sg => imp_sg ; Pl => imp_pl } ! n
              } ;
            c = class.c ;
            } ;
          Loan => loanV mamma ;
          _ => Predef.error ( "Unimplemented" )
        } ;

      } ; --end of mkV overload


    {- ----- Strong Verb ----- -}

    -- strong verb, eg ĦAREĠ (Ħ-R-Ġ)
    -- Make a verb by calling generate functions for each tense
    -- Params: Root, Pattern
    strongV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjStrongImp r p ;
      in lin V {
        s = table {
          VPerf pgn => ( conjStrongPerf r p ) ! pgn ;
          VImpf pgn => ( conjStrongImpf (imp ! Sg) (imp ! Pl) ) ! pgn ;
          VImp n =>    imp ! n
        } ;
        c = Strong Regular ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjStrongPerf : Root -> Pattern -> ( Agr => Str ) = \root,p ->
      let
        stem_12 = root.C1 + root.C2 + (case p.V2 of {"e" => "i" ; _ => p.V2 }) + root.C3 ;
        stem_3 = root.C1 + p.V1 + root.C2 + root.C3 ;
      in
        table {
          Per1 Sg    => stem_12 + "t" ;  -- Jiena KTIBT
          Per2 Sg    => stem_12 + "t" ;  -- Inti KTIBT
          Per3Sg Masc  => root.C1 + p.V1 + root.C2 + p.V2 + root.C3 ;  -- Huwa KITEB
          Per3Sg Fem  => stem_3 + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija KITBET
          Per1 Pl    => stem_12 + "na" ;  -- Aħna KTIBNA
          Per2 Pl    => stem_12 + "tu" ;  -- Intom KTIBTU
          Per3Pl    => stem_3 + "u"  -- Huma KITBU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
    conjStrongImpf : Str -> Str -> ( Agr => Str ) = \stem_sg,stem_pl ->
      table {
        Per1 Sg    => "n" + stem_sg ;  -- Jiena NIKTEB
        Per2 Sg    => "t" + stem_sg ;  -- Inti TIKTEB
        Per3Sg Masc  => "j" + stem_sg ;  -- Huwa JIKTEB
        Per3Sg Fem  => "t" + stem_sg ;  -- Hija TIKTEB
        Per1 Pl    => "n" + stem_pl ;  -- Aħna NIKTBU
        Per2 Pl    => "t" + stem_pl ;  -- Intom TIKTBU
        Per3Pl    => "j" + stem_pl  -- Huma JIKTBU
      } ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjStrongImp : Root -> Pattern -> ( Number => Str ) = \root,p ->
      let
        stem_sg = case (p.V1 + p.V2) of {
          "aa" => "i" + root.C1 + root.C2 + "o" + root.C3 ;
          "ae" => "o" + root.C1 + root.C2 + "o" + root.C3 ;
          "ee" => "i" + root.C1 + root.C2 + "e" + root.C3 ;
          "ea" => "i" + root.C1 + root.C2 + "a" + root.C3 ;
          "ie" => "i" + root.C1 + root.C2 + "e" + root.C3 ;
          "oo" => "o" + root.C1 + root.C2 + "o" + root.C3
        } ;
        stem_pl = case (p.V1 + p.V2) of {
          "aa" => "i" + root.C1 + "o" + root.C2 + root.C3 ;
          "ae" => "o" + root.C1 + "o" + root.C2 + root.C3 ;
          "ee" => "i" + root.C1 + "e" + root.C2 + root.C3 ;
          "ea" => "i" + root.C1 + "i" + root.C2 + root.C3 ;
          "ie" => "i" + root.C1 + "e" + root.C2 + root.C3 ;
          "oo" => "o" + root.C1 + "o" + root.C2 + root.C3
        } ;
      in
        table {
          Sg => stem_sg ;  -- Inti:  IKTEB
          Pl => stem_pl + "u"  -- Intom: IKTBU
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
          VPerf pgn => ( conjDefectivePerf r p ) ! pgn ;
          VImpf pgn => ( conjDefectiveImpf (imp ! Sg) (imp ! Pl) ) ! pgn ;
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
          Per1 Sg    => stem_12 + "t" ;  -- Jiena QLAJT
          Per2 Sg    => stem_12 + "t" ;  -- Inti QLAJT
          Per3Sg Masc  => root.C1 + p.V1 + root.C2 + p.V2 + "'" ;  -- Huwa QALA'
          Per3Sg Fem  => stem_3 + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija QALGĦET
          Per1 Pl    => stem_12 + "na" ;  -- Aħna QLAJNA
          Per2 Pl    => stem_12 + "tu" ;  -- Intom QLAJTU
          Per3Pl    => stem_3 + "u"  -- Huma QALGĦU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
    conjDefectiveImpf : Str -> Str -> ( Agr => Str ) = \stem_sg,stem_pl ->
      table {
        Per1 Sg    => "n" + stem_sg ;  -- Jiena NIKTEB
        Per2 Sg    => "t" + stem_sg ;  -- Inti TIKTEB
        Per3Sg Masc  => "j" + stem_sg ;  -- Huwa JIKTEB
        Per3Sg Fem  => "t" + stem_sg ;  -- Hija TIKTEB
        Per1 Pl    => "n" + stem_pl ;  -- Aħna NIKTBU
        Per2 Pl    => "t" + stem_pl ;  -- Intom TIKTBU
        Per3Pl    => "j" + stem_pl  -- Huma JIKTBU
      } ;

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

    {- ----- Weak Verb ----- -}

    -- Weak verb, eg MEXA (M-X-J)
    -- Make a verb by calling generate functions for each tense
    -- Params: Root, Pattern
    weakV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjWeakImp r p ;
      in lin V {
        s = table {
          VPerf pgn => ( conjWeakPerf r p ) ! pgn ;
          VImpf pgn => ( conjWeakImpf (imp ! Sg) (imp ! Pl) ) ! pgn ;
          VImp n =>    imp ! n
        } ;
        c = Weak WeakFinal ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    -- Return: Lookup table of Agr against Str
    conjWeakPerf : Root -> Pattern -> ( Agr => Str ) = \root,p ->
      let
        stem_12 = root.C1 + root.C2 + (case p.V2 of {"e" => "i" ; _ => p.V2 }) + "j" ; -- "AGĦ" -> "AJ"
        stem_3 = root.C1 + p.V1 + root.C2 + root.C3 ;
      in
        table {
          Per1 Sg    => stem_12 + "t" ;  -- Jiena IMXEJT
          Per2 Sg    => stem_12 + "t" ;  -- Inti IMXEJT
          Per3Sg Masc  => root.C1 + p.V1 + root.C2 + p.V2 + "'" ;  -- Huwa MEXA
          Per3Sg Fem  => stem_3 + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija IMXIET
          Per1 Pl    => stem_12 + "na" ;  -- Aħna IMXEJNA
          Per2 Pl    => stem_12 + "tu" ;  -- Intom IMXEJTU
          Per3Pl    => stem_3 + "u"  -- Huma IMXEW
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IMXI), Imperative Plural (eg IMXU)
    -- Return: Lookup table of Agr against Str
    conjWeakImpf : Str -> Str -> ( Agr => Str ) = \stem_sg,stem_pl ->
      table {
        Per1 Sg    => "n" + stem_sg ;  -- Jiena NIMXI
        Per2 Sg    => "t" + stem_sg ;  -- Inti TIMXI
        Per3Sg Masc  => "j" + stem_sg ;  -- Huwa JIMXI
        Per3Sg Fem  => "t" + stem_sg ;  -- Hija TIMXI
        Per1 Pl    => "n" + stem_pl ;  -- Aħna NIMXU
        Per2 Pl    => "t" + stem_pl ;  -- Intom TIMXU
        Per3Pl    => "j" + stem_pl  -- Huma JIMXU
      } ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    -- Return: Lookup table of Number against Str
    conjWeakImp : Root -> Pattern -> ( Number => Str ) = \root,p ->
      let
        v1 = case p.V1 of { "e" => "i" ; _ => p.V1 } ;
        v_pl = case p.V1 of { "a" => "i" ; _ => "" } ; -- some verbs require "i" insertion in middle (eg AQILGĦU)
      in
        table {
          Sg => v1 + root.C1 + root.C2 + p.V2 + "'" ;  -- Inti: IMXI
          Pl => v1 + root.C1 + v_pl + root.C2 + root.C3 + "u"  -- Intom: IMXU
        } ;

    {- ----- Quadriliteral Verb ----- -}

    -- Make a Quad verb, eg QARMEĊ (Q-R-M-Ċ)
    -- Make a verb by calling generate functions for each tense
    -- Params: Root, Pattern
    -- Return: Verb
    quadV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjQuadImp r p ;
      in lin V {
        s = table {
          VPerf pgn => ( conjQuadPerf r p ) ! pgn ;
          VImpf pgn => ( conjQuadImpf (imp ! Sg) (imp ! Pl) ) ! pgn ;
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
        Per1 Sg    => stem_12 + "t" ;  -- Jiena DARDART
        Per2 Sg    => stem_12 + "t" ;  -- Inti DARDART
        Per3Sg Masc  => root.C1 + p.V1 + root.C2 + root.C3 + p.V2 + root.C4 ;  -- Huwa DARDAR
        Per3Sg Fem  => stem_3 + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija DARDRET
        Per1 Pl    => stem_12 + "na" ;  -- Aħna DARDARNA
        Per2 Pl    => stem_12 + "tu" ;  -- Intom DARDARTU
        Per3Pl    => stem_3 + "u"  -- Huma DARDRU
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
        Per1 Sg    => "in" + stem_sg ;      -- Jiena INDARDAR
        Per2 Sg    => prefix_dbl + stem_sg ;  -- Inti IDDARDAR
        Per3Sg Masc  => "i" + stem_sg ;      -- Huwa IDARDAR
        Per3Sg Fem  => prefix_dbl + stem_sg ;  -- Hija IDDARDAR
        Per1 Pl    => "in" + stem_pl ;      -- Aħna INDARDRU
        Per2 Pl    => prefix_dbl + stem_pl ;  -- Intom IDDARDRU
        Per3Pl    => "i" + stem_pl      -- Huma IDARDRU
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
    loanV : Str -> V = \kanta ->
      let
        kantaw = kanta + "w" ;
      in lin V {
        s = table {
          VPerf pgn => table {
            Per1 Sg    => kanta + "jt" ;  -- Jiena KANTAJT
            Per2 Sg    => kanta + "jt" ;  -- Inti KANTAJT
            Per3Sg Masc  => kanta ; -- Huwa KANTA
            Per3Sg Fem  => kanta + "t" ;  -- Hija KANTAT
            Per1 Pl    => kanta + "jna" ;  -- Aħna KANTAJNA
            Per2 Pl    => kanta + "jtu" ;  -- Intom KANTAJTU
            Per3Pl    => kanta + "w"  -- Huma KANTAW
            } ! pgn ;
          VImpf pgn => table {
            Per1 Sg    => "n" + kanta ;  -- Jiena NKANTA
            Per2 Sg    => "t" + kanta ;  -- Inti TKANTA
            Per3Sg Masc  => "j" + kanta ;  -- Huwa JKANTA
            Per3Sg Fem  => "t" + kanta ;  -- Hija TKANTA
            Per1 Pl    => "n" + kantaw ;  -- Aħna NKANTAW
            Per2 Pl    => "t" + kantaw ;  -- Intom TKANTAW
            Per3Pl    => "j" + kantaw  -- Huma JKANTAW
            } ! pgn ;
          VImp n => table {
            Sg => kanta ;  -- Inti:  KANTA
            Pl => kantaw  -- Intom: KANTAW
            } ! n
          } ;
        c = Loan ;
        } ;

    -- Loan verb: Italian integrated -ERE/-IRE, eg VINĊA
    -- Follows Maltese weak verb class 1 {MDG pg249,379}
    loanV : Str -> Str -> V = \vinca,vinci ->
      let
        vinc = tk 1 vinca ;
        vincu = vinc + "u" ;
      in lin V {
        s = table {
          VPerf pgn => table {
            Per1 Sg    => vinc + "ejt" ;  -- Jiena VINĊEJT
            Per2 Sg    => vinc + "ejt" ;  -- Inti VINĊEJT
            Per3Sg Masc  => vinca ; -- Huwa VINĊA
            Per3Sg Fem  => vinc + "iet" ;  -- Hija VINĊIET
            Per1 Pl    => vinc + "ejna" ;  -- Aħna VINĊEJNA
            Per2 Pl    => vinc + "ejtu" ;  -- Intom VINĊEJTU
            Per3Pl    => vinc + "ew"  -- Huma VINĊEJTU
            } ! pgn ;
          VImpf pgn => table {
            Per1 Sg    => "in" + vinci ;  -- Jiena INVINĊI
            Per2 Sg    => "t" + vinci ;  -- Inti TVINĊI
            Per3Sg Masc  => "j" + vinci ;  -- Huwa JVINĊI
            Per3Sg Fem  => "t" + vinci ;  -- Hija TVINĊI
            Per1 Pl    => "n" + vincu ;  -- Aħna INVINĊU
            Per2 Pl    => "t" + vincu ;  -- Intom TVINĊU
            Per3Pl    => "j" + vincu  -- Huma JVINĊU
            } ! pgn ;
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
