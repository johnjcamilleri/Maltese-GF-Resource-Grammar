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
          _ + #Vowel + #Consonant + #Vowel + K@#Consonant => tk 2 coll + K ; -- eg GĦADAM -> GĦADM-

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


    {- ===== Verb paradigms ===== -}

    -- Takes a verb as a string and returns the VType and root/pattern.
    -- Used in smart paradigm below and elsewhere.
    -- Params: "Mamma" (Perf Per3 Sg Masc) as string (eg KITEB or ĦAREĠ)
    classifyVerb : Str -> { c:VClass ; f:VDerivedForm ; r:Root ; p:Pattern } = \mamma ->
      let
        ret : VClass -> VDerivedForm -> Root -> Pattern -> { c:VClass ; f:VDerivedForm ; r:Root ; p:Pattern } = \c,f,r,p ->
        { c=c ; f=f ; r=r ; p=p } ;
      in
      case mamma of {

        -- Defective, BELA'
        c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel + c3@( "għ" | "'" ) =>
          ret (Weak Defective) FormI (mkRoot c1 c2 "għ") (mkPattern v1 v2) ;

        -- Weak Final, MEXA
        c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel =>
          ret (Weak WeakFinal) FormI (mkRoot c1 c2 "j") (mkPattern v1 v2) ;

        -- Hollow, SAB
        -- --- determining of middle radical is not right, e.g. SAB = S-J-B
        c1@#Consonant + v1@"a"  + c3@#Consonant =>
          ret (Weak Hollow) FormI (mkRoot c1 "w" c3) (mkPattern v1) ;
        c1@#Consonant + v1@"ie" + c3@#Consonant =>
          ret (Weak Hollow) FormI (mkRoot c1 "j" c3) (mkPattern v1) ;

        -- Weak Assimilative, WAQAF
        c1@#WeakCons + v1@#Vowel + c2@#Consonant + v2@#Vowel  + c3@#Consonant =>
          ret (Weak Assimilative) FormI (mkRoot c1 c2 c3) (mkPattern v1 v2) ;

        -- Strong Reduplicative, ĦABB
        c1@#Consonant + v1@#Vowel + c2@#Consonant + c3@#Consonant =>
          ret (Strong Reduplicative) FormI (mkRoot c1 c2 c3) (mkPattern v1) ;

        -- Strong LiquidMedial, ŻELAQ
        c1@#Consonant + v1@#Vowel + c2@(#LiquidCons | "għ") + v2@#Vowel + c3@#Consonant =>
          ret (Strong LiquidMedial) FormI (mkRoot c1 c2 c3) (mkPattern v1 v2) ;

        -- Strong Regular, QATEL
        c1@#Consonant + v1@#Vowel + c2@#Consonant + v2@#Vowel + c3@#Consonant =>
          ret (Strong Regular) FormI (mkRoot c1 c2 c3) (mkPattern v1 v2) ;

        -- Strong Quad, QAĊĊAT
        c1@#Consonant + v1@#Vowel + c2@#Consonant + c3@#Consonant + v2@#Vowel + c4@#Consonant =>
          ret (Strong Quad) FormI (mkRoot c1 c2 c3 c4) (mkPattern v1 v2) ;

        -- Weak-Final Quad, PINĠA
        c1@#Consonant + v1@#Vowel + c2@#Consonant + c3@#Consonant + v2@#Vowel =>
          ret (Weak QuadWeakFinal) FormI (mkRoot c1 c2 c3 "j") (mkPattern v1 v2) ;

        -- Assume it is a loan verb
        _ => ret Loan FormI mkRoot mkPattern
      } ;
{-
    -- Smart paradigm for building a verb
    mkV : V = overload {

      -- Tries to do everything just from the mamma of the verb
      -- Params: mamma
      mkV : Str -> V = \mamma ->
        let
          class = classifyVerb mamma ;
        in
        mkVWorst mamma class.r class.p [] class.c class.f ;

      -- Takes an explicit root, when it is not obvious from the mamma
      -- Params: mamma, root
      mkV : Str -> Root -> V = \mamma,root ->
        let
          class = classifyVerb mamma ;
        in
        mkVWorst mamma root class.p [] class.c class.f ;

      -- Takes takes an Imperative of the word for when it behaves less predictably
      -- Params: mamma, imperative P2Sg
      mkV : Str -> Str -> V = \mamma,imp_sg ->
        let
          class = classifyVerb mamma ;
        in
        mkVWorst mamma class.r class.p imp_sg class.c class.f ;

      } ; --end of mkV overload
-}

    -- Smart paradigm for building a verb
    mkV : V = overload {

      -- Tries to do everything just from the mamma of the verb
      -- Params: mamma
      mkV : Str -> V = \mamma ->
        let
          class = classifyVerb mamma ;
        in
        case class.c of {
          Strong Regular      => strongV class.r class.p ;
          Strong LiquidMedial => liquidMedialV class.r class.p ;
          Strong Reduplicative=> reduplicativeV class.r class.p ;
          Weak Assimilative   => assimilativeV class.r class.p ;
          Weak Hollow         => hollowV class.r class.p ;
          Weak WeakFinal      => weakFinalV class.r class.p ;
          Weak Defective      => defectiveV class.r class.p ;
          Strong Quad         => quadV class.r class.p ;
          Weak QuadWeakFinal  => quadWeakV class.r class.p ;
          Loan                => loanV mamma
        } ;

      -- Takes an explicit root, when it is not obvious from the mamma
      -- Params: mamma, root
      mkV : Str -> Root -> V = \mamma,root ->
        let
          class = classifyVerb mamma ;
        in
        case class.c of {
          Strong Regular      => strongV root class.p ;
          Strong LiquidMedial => liquidMedialV root class.p ;
          Strong Reduplicative=> reduplicativeV root class.p ;
          Weak Assimilative   => assimilativeV root class.p ;
          Weak Hollow         => hollowV root class.p ;
          Weak WeakFinal      => weakFinalV root class.p ;
          Weak Defective      => defectiveV root class.p ;
          Strong Quad         => quadV root class.p ;
          Weak QuadWeakFinal  => quadWeakV root class.p ;
          Loan                => loanV mamma
        } ;

      -- Takes takes an Imperative of the word for when it behaves less predictably
      -- Params: mamma, imperative P2Sg
      mkV : Str -> Str -> V = \mamma,imp_sg ->
        let
          class = classifyVerb mamma ;
        in
        case class.c of {
          Strong Regular      => strongV class.r class.p imp_sg ;
          Strong LiquidMedial => liquidMedialV class.r class.p imp_sg ;
          Strong Reduplicative=> reduplicativeV class.r class.p imp_sg ;
          Weak Assimilative   => assimilativeV class.r class.p imp_sg ;
          Weak Hollow         => hollowV class.r class.p imp_sg ;
          Weak WeakFinal      => weakFinalV class.r class.p imp_sg ;
          Weak Defective      => defectiveV class.r class.p imp_sg ;
          Strong Quad         => quadV class.r class.p imp_sg ;
          Weak QuadWeakFinal  => quadWeakV class.r class.p imp_sg ;
          Loan                => loanV mamma imp_sg
        } ;

      --- Do we need a version for: mamma, root, imp_sg ?

      } ; --end of mkV overload


    impPlFromSg : Root -> Pattern -> Str -> VClass = \root,patt,imp_sg,class ->
      case class of {
        Strong Regular      => (take 3 imp_sg) + root.C3 + "u" ; -- IFTAĦ > IFTĦU
        Strong LiquidMedial => (take 2 imp_sg) + (charAt 3 imp_sg) + root.C2 + root.C3 + "u" ; -- OĦROĠ > OĦORĠU
        Strong Reduplicative=> imp_sg + "u" ; -- ŻOMM > ŻOMMU
        Weak Assimilative   => (take 2 imp_sg) + root.C3 + "u" ; -- ASAL > ASLU
        Weak Hollow         => imp_sg + "u" ; -- SIR > SIRU
        Weak WeakFinal      => (take 3 imp_sg) + "u" ; -- IMXI > IMXU
        Weak Defective      => (take 2 imp_sg) + "i" + root.C2 + "għu" ; -- ISMA' > ISIMGĦU
        Strong Quad         => (take 4 imp_sg) + root.C4 + "u" ; -- ĦARBAT > ĦARBTU
        Weak QuadWeakFinal  => case (dp 1 imp_sg) of {
          "a" => imp_sg + "w" ; -- KANTA > KANTAW
          "i" => (tk 1 imp_sg) + "u" ; -- SERVI > SERVU
          _ => Predef.error("Unaccounted case FH4748J")
          } ;
        Loan                => case imp_sg of {
            _ + "ixxi" => (tk 1 imp_sg) + "u" ; -- IDDIŻUBIDIXXI > IDDIŻUBIDIXXU
            _ => imp_sg + "w" -- IPPARKJA > IPPARKJAW
          }
      } ;


    {- ~~~ General use verb operations ~~~ -}

    -- Conjugate imperfect tense from imperative by adding initial letters
    -- Ninu, Toninu, Jaħasra, Toninu; Ninu, Toninu, Jaħasra
    conjGenericImpf : Str -> Str -> (Agr => Str) = \imp_sg,imp_pl ->
      table {
        AgP1 Sg    => "n" + imp_sg ;  -- Jiena NIŻLOQ
        AgP2 Sg    => "t" + imp_sg ;  -- Inti TIŻLOQ
        AgP3Sg Masc  => "j" + imp_sg ;  -- Huwa JIŻLOQ
        AgP3Sg Fem  => "t" + imp_sg ;  -- Hija TIŻLOQ
        AgP1 Pl    => "n" + imp_pl ;  -- Aħna NIŻOLQU
        AgP2 Pl    => "t" + imp_pl ;  -- Intom TIŻOLQU
        AgP3Pl    => "j" + imp_pl  -- Huma JIŻOLQU
      } ;

    -- Build table of pronominal suffixes
    -- Perfective tense
    verbPerfPronSuffixTable : (Agr => Str) -> (Agr => VSuffixForm => Str) = \tbl ->
      table {
        AgP1 Sg => -- Jiena FTAĦT
          let
            ftaht = tbl ! AgP1 Sg ;
          in
          table {
            VSuffixNone => ftaht ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftaht + "ek" ;  -- Jiena FTAĦTEK
                AgP3Sg Masc  => ftaht + "u" ;  -- Jiena FTAĦTU
                AgP3Sg Fem  => ftaht + "ha" ;  -- Jiena FTAĦTHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftaht + "kom" ;  -- Jiena FTAĦTKOM
                AgP3Pl    => ftaht + "hom"  -- Jiena FTAĦTHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftaht + "lek" ;  -- Jiena FTAĦTLEK
                AgP3Sg Masc  => ftaht + "lu" ;  -- Jiena FTAĦTLU
                AgP3Sg Fem  => ftaht + "ilha" ;  -- Jiena FTAĦTILHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftaht + "ilkom" ;  -- Jiena FTAĦTILKOM
                AgP3Pl    => ftaht + "ilhom"  -- Jiena FTAĦTILHOM
              } ;
            VSuffixDirInd (GSg Masc) agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftaht + "hulek" ;  -- Jiena FTAĦTHULEK
                AgP3Sg Masc  => ftaht + "hulu" ;  -- Jiena FTAĦTHULU
                AgP3Sg Fem  => ftaht + "hulha" ;  -- Jiena FTAĦTHULHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftaht + "hulkom" ;  -- Jiena FTAĦTHULKOM
                AgP3Pl    => ftaht + "hulhom"  -- Jiena FTAĦTHULHOM
              } ;
            VSuffixDirInd (GSg Fem) agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftaht + "hielek" ;  -- Jiena FTAĦTHIELEK
                AgP3Sg Masc  => ftaht + "hielu" ;  -- Jiena FTAĦTHIELU
                AgP3Sg Fem  => ftaht + "hielha" ;  -- Jiena FTAĦTHIELHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftaht + "hielkom" ;  -- Jiena FTAĦTHIELKOM
                AgP3Pl    => ftaht + "hielhom"  -- Jiena FTAĦTHIELHOM
              } ;
            VSuffixDirInd (GPl) agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftaht + "homlok" ;  -- Jiena FTAĦTHOMLOK
                AgP3Sg Masc  => ftaht + "homlu" ;  -- Jiena FTAĦTHOMLU
                AgP3Sg Fem  => ftaht + "homlha" ;  -- Jiena FTAĦTOMHLA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftaht + "homlkom" ;  -- Jiena FTAĦTHOMLKOM
                AgP3Pl    => ftaht + "homlhom"  -- Jiena FTAĦTHOMLHOM
              }
          } ;
        AgP2 Sg => -- Inti FTAĦT
          let
            ftaht = tbl ! AgP2 Sg ;
          in
          table {
            VSuffixNone => ftaht ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => ftaht + "ni" ; -- Inti FTAĦTNI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ftaht + "u" ;  -- Inti FTAĦTU
                AgP3Sg Fem  => ftaht + "ha" ;  -- Inti FTAĦTHA
                AgP1 Pl    => ftaht + "na" ; -- Inti FTAĦTNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ftaht + "hom"  -- Inti FTAĦTHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => ftaht + "li" ; -- Inti FTAĦTLI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ftaht + "lu" ;  -- Inti FTAĦTLU
                AgP3Sg Fem  => ftaht + "ilha" ;  -- Inti FTAĦTILHA
                AgP1 Pl    => ftaht + "ilna" ; -- Inti FTAĦTILNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ftaht + "ilhom"  -- Inti FTAĦTILHOM
              } ;
            VSuffixDirInd (GSg Masc) agr =>
              case agr of {
                AgP1 Sg    => ftaht + "huli" ; -- Inti FTAĦTHULI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ftaht + "hulu" ;  -- Inti FTAĦTHULU
                AgP3Sg Fem  => ftaht + "hulha" ;  -- Inti FTAĦTHULHA
                AgP1 Pl    => ftaht + "hulna" ; -- Inti FTAĦTHULNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ftaht + "hulhom"  -- Inti FTAĦTHULHOM
              } ;
            VSuffixDirInd (GSg Fem) agr =>
              case agr of {
                AgP1 Sg    => ftaht + "hieli" ; -- Inti FTAĦTHIELI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ftaht + "hielu" ;  -- Inti FTAĦTHIELU
                AgP3Sg Fem  => ftaht + "hielha" ;  -- Inti FTAĦTHIELHA
                AgP1 Pl    => ftaht + "hielna" ; -- Inti FTAĦTHIELNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ftaht + "hielhom"  -- Inti FTAĦTHIELHOM
              } ;
            VSuffixDirInd (GPl) agr =>
              case agr of {
                AgP1 Sg    => ftaht + "homli" ; -- Inti FTAĦTHOMLI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ftaht + "homlu" ;  -- Inti FTAĦTHOMLU
                AgP3Sg Fem  => ftaht + "homlha" ;  -- Inti FTAĦTHOMLHA
                AgP1 Pl    => ftaht + "homlna" ; -- Inti FTAĦTHOMLNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ftaht + "homlhom"  -- Inti FTAĦTHOMLHOM
              }
          } ;
        AgP3Sg Masc => -- Huwa FETAĦ
          let
            fetah = tbl ! AgP3Sg Masc ;
            feth = tk 2 fetah + dp 1 fetah ; --- this will likely fail in many cases
          in
          table {
            VSuffixNone => fetah ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => fetah + "ni" ; -- Huwa FETAĦNI
                AgP2 Sg    => feth + "ek" ; -- Huwa FETĦEK
                AgP3Sg Masc  => feth + "u" ;  -- Huwa FETĦU
                AgP3Sg Fem  => fetah + "ha" ;  -- Huwa FETAĦHA
                AgP1 Pl    => fetah + "na" ; -- Huwa FETAĦNA
                AgP2 Pl    => fetah + "kom" ; -- Huwa FETAĦKOM
                AgP3Pl    => fetah + "hom"  -- Huwa FETAĦHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => fetah + "li" ; -- Huwa FETAĦLI
                AgP2 Sg    => fetah + "lek" ; -- Huwa FETAĦLEK
                AgP3Sg Masc  => fetah + "lu" ;  -- Huwa FETAĦLU
                AgP3Sg Fem  => feth + "ilha" ;  -- Huwa FETĦILHA
                AgP1 Pl    => feth + "ilna" ; -- Huwa FETĦILNA
                AgP2 Pl    => feth + "ilkom" ; -- Huwa FETĦILKOM
                AgP3Pl    => feth + "ilhom"  -- Huwa FETĦILHOM
              } ;
            VSuffixDirInd (GSg Masc) agr =>
              case agr of {
                AgP1 Sg    => fetah + "huli" ; -- Huwa FETAĦHULI
                AgP2 Sg    => fetah + "hulek" ; -- Huwa FETAĦHULEK
                AgP3Sg Masc  => fetah + "hulu" ;  -- Huwa FETAĦHULU
                AgP3Sg Fem  => fetah + "hulha" ;  -- Huwa FETAĦHULHA
                AgP1 Pl    => fetah + "hulna" ; -- Huwa FETAĦHULNA
                AgP2 Pl    => fetah + "hulkom" ; -- Huwa FETAĦHULKOM
                AgP3Pl    => fetah + "hulhom"  -- Huwa FETAĦHULHOM
              } ;
            VSuffixDirInd (GSg Fem) agr =>
              case agr of {
                AgP1 Sg    => fetah + "hieli" ; -- Huwa FETAĦHIELI
                AgP2 Sg    => fetah + "hielek" ; -- Huwa FETAĦHIELEK
                AgP3Sg Masc  => fetah + "hielu" ;  -- Huwa FETAĦHIELU
                AgP3Sg Fem  => fetah + "hielha" ;  -- Huwa FETAĦHIELHA
                AgP1 Pl    => fetah + "hielna" ; -- Huwa FETAĦHIELNA
                AgP2 Pl    => fetah + "hielkom" ; -- Huwa FETAĦIELKOM
                AgP3Pl    => fetah + "hielhom"  -- Huwa FETAĦHIELHOM
              } ;
            VSuffixDirInd (GPl) agr =>
              case agr of {
                AgP1 Sg    => fetah + "homli" ; -- Huwa FETAĦHOMLI
                AgP2 Sg    => fetah + "homlok" ; -- Huwa FETAĦHOMLOK
                AgP3Sg Masc  => fetah + "homlu" ;  -- Huwa FETAĦHOMLU
                AgP3Sg Fem  => fetah + "homlha" ;  -- Huwa FETAĦHOMLHA
                AgP1 Pl    => fetah + "homlna" ; -- Huwa FETAĦHOMLNA
                AgP2 Pl    => fetah + "homlkom" ; -- Huwa FETAĦHOMLKOM
                AgP3Pl    => fetah + "homlhom"  -- Huwa FETAĦHOMLHOM
              }
          } ;
        AgP3Sg Fem => -- Hija FETĦET
          let
            fethet = tbl ! AgP3Sg Fem ;
            fethit = tk 2 fethet + "it" ; --- this will likely fail in many cases
          in
          table {
            VSuffixNone => fethet ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => fethit + "ni" ; -- Hija FETĦITNI
                AgP2 Sg    => fethit + "ek" ; -- Hija FETĦITEK
                AgP3Sg Masc  => fethit + "u" ;  -- Hija FETĦITU
                AgP3Sg Fem  => fethit + "ha" ;  -- Hija FETĦITHA
                AgP1 Pl    => fethit + "na" ; -- Hija FETĦITNA
                AgP2 Pl    => fethit + "kom" ; -- Hija FETĦITKOM
                AgP3Pl    => fethit + "hom"  -- Hija FETĦITHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => fethit + "li" ; -- Hija FETĦITLI
                AgP2 Sg    => fethit + "lek" ; -- Hija FETĦITLEK
                AgP3Sg Masc  => fethit + "lu" ;  -- Hija FETĦITLU
                AgP3Sg Fem  => fethit + "ilha" ;  -- Hija FETĦITILHA
                AgP1 Pl    => fethit + "ilna" ; -- Hija FETĦITILNA
                AgP2 Pl    => fethit + "ilkom" ; -- Hija FETĦITILKOM
                AgP3Pl    => fethit + "ilhom"  -- Hija FETĦITILHOM
              } ;
            VSuffixDirInd (GSg Masc) agr =>
              case agr of {
                AgP1 Sg    => fethit + "huli" ; -- Hija FETĦITHULI
                AgP2 Sg    => fethit + "hulek" ; -- Hija FETĦITHULEK
                AgP3Sg Masc  => fethit + "hulu" ;  -- Hija FETĦITHULU
                AgP3Sg Fem  => fethit + "hunlha" ;  -- Hija FETĦITHULHA
                AgP1 Pl    => fethit + "hulna" ; -- Hija FETĦITHULNA
                AgP2 Pl    => fethit + "hulkom" ; -- Hija FETĦITHULKOM
                AgP3Pl    => fethit + "hulhom"  -- Hija FETĦITHULHOM
              } ;
            VSuffixDirInd (GSg Fem) agr =>
              case agr of {
                AgP1 Sg    => fethit + "hieli" ; -- Hija FETĦITHIELI
                AgP2 Sg    => fethit + "hielek" ; -- Hija FETĦITHIELEK
                AgP3Sg Masc  => fethit + "hielu" ;  -- Hija FETĦITHIELU
                AgP3Sg Fem  => fethit + "hielha" ;  -- Hija FETĦITHIELHA
                AgP1 Pl    => fethit + "hielna" ; -- Hija FETĦITHIELNA
                AgP2 Pl    => fethit + "hielkom" ; -- Hija FETĦITHIELKOM
                AgP3Pl    => fethit + "hielhom"  -- Hija FETĦITHIELHOM
              } ;
            VSuffixDirInd (GPl) agr =>
              case agr of {
                AgP1 Sg    => fethit + "homli" ; -- Hija FETĦITHOMLI
                AgP2 Sg    => fethit + "homlok" ; -- Hija FETĦITHOMLOK
                AgP3Sg Masc  => fethit + "homlu" ;  -- Hija FETĦITHOMLU
                AgP3Sg Fem  => fethit + "homlha" ;  -- Hija FETĦITHOMLHA
                AgP1 Pl    => fethit + "homlna" ; -- Hija FETĦITHOMLNA
                AgP2 Pl    => fethit + "homlkom" ; -- Hija FETĦITHOMLKOM
                AgP3Pl    => fethit + "homlhom"  -- Hija FETĦITHOMLHOM
              }
          } ;
        AgP1 Pl => -- Aħna FTAĦNA
          let
            ftahna = tbl ! AgP1 Pl ;
            ftahn = tk 1 ftahna ;
          in
          table {
            VSuffixNone => ftahna ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftahn + "iek" ;  -- Aħna FTAĦNIEK
                AgP3Sg Masc  => ftahn + "ieh" ;  -- Aħna FTAĦNIEH
                AgP3Sg Fem  => ftahn + "ieha" ;  -- Aħna FTAĦNIEHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftahn + "iekom" ;  -- Aħna FTAĦNIEKOM
                AgP3Pl    => ftahn + "iehom"  -- Aħna FTAĦNIEHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftahn + "ielek" ;  -- Aħna FTAĦNIELEK
                AgP3Sg Masc  => ftahn + "ielu" ;  -- Aħna FTAĦNIELU
                AgP3Sg Fem  => ftahn + "ielha" ;  -- Aħna FTAĦNIELHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftahn + "ielkom" ;  -- Aħna FTAĦNIELKOM
                AgP3Pl    => ftahn + "ielhom"  -- Aħna FTAĦNIELHOM
              } ;
            VSuffixDirInd (GSg Masc) agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftahn + "iehulek" ;  -- Aħna FTAĦNIEHULEK
                AgP3Sg Masc  => ftahn + "iehulu" ;  -- Aħna FTAĦNIEHULU
                AgP3Sg Fem  => ftahn + "iehulha" ;  -- Aħna FTAĦNIEHULHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftahn + "iehulkom" ;  -- Aħna FTAĦNIEHULKOM
                AgP3Pl    => ftahn + "iehulhom"  -- Aħna FTAĦNIEHULHOM
              } ;
            VSuffixDirInd (GSg Fem) agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftahn + "ihielek" ;  -- Aħna FTAĦNIHIELEK
                AgP3Sg Masc  => ftahn + "ihielu" ;  -- Aħna FTAĦNIHIELU
                AgP3Sg Fem  => ftahn + "ihielha" ;  -- Aħna FTAĦNIHIELHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftahn + "ihielkom" ;  -- Aħna FTAĦNIHIELKOM
                AgP3Pl    => ftahn + "ihielhom"  -- Aħna FTAĦNIHIELHOM
              } ;
            VSuffixDirInd (GPl) agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftahn + "iehomlok" ;  -- Aħna FTAĦNIEHOMLOK
                AgP3Sg Masc  => ftahn + "iehomlu" ;  -- Aħna FTAĦNIEHOMLU
                AgP3Sg Fem  => ftahn + "iehomlha" ;  -- Aħna FTAĦNIEHOMLHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftahn + "iehomlkom" ;  -- Aħna FTAĦNIEHOMLKOM
                AgP3Pl    => ftahn + "iehomlhom"  -- Aħna FTAĦNIEHOMLHOM
              }
          } ;
        AgP2 Pl => -- Intom FTAĦTU
          let
            ftahtu = tbl ! AgP2 Pl ;
          in
          table {
            VSuffixNone => ftahtu ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => ftahtu + "ni" ; -- Intom FTAĦTUNI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ftahtu + "h" ;  -- Intom FTAĦTUH
                AgP3Sg Fem  => ftahtu + "ha" ;  -- Intom FTAĦTUHA
                AgP1 Pl    => ftahtu + "na" ; -- Intom FTAĦTUNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ftahtu + "hom"  -- Intom FTAĦTUHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => ftahtu + "li" ; -- Intom FTAĦTULI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ftahtu + "lu" ;  -- Intom FTAĦTULU
                AgP3Sg Fem  => ftahtu + "lha" ;  -- Intom FTAĦTULHA
                AgP1 Pl    => ftahtu + "la" ; -- Intom FTAĦTULNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ftahtu + "lhom"  -- Intom FTAĦTULHOM
              } ;
            VSuffixDirInd (GSg Masc) agr =>
              case agr of {
                AgP1 Sg    => ftahtu + "huli" ; -- Intom FTAĦTUHULI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ftahtu + "hulu" ;  -- Intom FTAĦTUHULU
                AgP3Sg Fem  => ftahtu + "hulha" ;  -- Intom FTAĦTUHULHA
                AgP1 Pl    => ftahtu + "hulna" ; -- Intom FTAĦTUHULNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ftahtu + "hulhom"  -- Intom FTAĦTUHULHOM
              } ;
            VSuffixDirInd (GSg Fem) agr =>
              case agr of {
                AgP1 Sg    => ftahtu + "hieli" ; -- Intom FTAĦTUHIELI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ftahtu + "hielu" ;  -- Intom FTAĦTUHIELU
                AgP3Sg Fem  => ftahtu + "hielha" ;  -- Intom FTAĦTUHIELHA
                AgP1 Pl    => ftahtu + "hielna" ; -- Intom FTAĦTUHIELNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ftahtu + "hielhom"  -- Intom FTAĦTUHIELHOM
              } ;
            VSuffixDirInd (GPl) agr =>
              case agr of {
                AgP1 Sg    => ftahtu + "homli" ; -- Intom FTAĦTUHOMLI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ftahtu + "homlu" ;  -- Intom FTAĦTUHOMLU
                AgP3Sg Fem  => ftahtu + "homlha" ;  -- Intom FTAĦTUHOMLHA
                AgP1 Pl    => ftahtu + "homlna" ; -- Intom FTAĦTUHOMLNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ftahtu + "homlhom"  -- Intom FTAĦTUHOMLHOM
              }
          } ;
        AgP3Pl => -- Huma FETĦU
          let
            fethu = tbl ! AgP3Pl ;
          in
          table {
            VSuffixNone => fethu ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => fethu + "ni" ; -- Huma FETĦUNI
                AgP2 Sg    => fethu + "k" ; -- Huma FETĦUK
                AgP3Sg Masc  => fethu + "h" ;  -- Huma FETĦUH
                AgP3Sg Fem  => fethu + "ha" ;  -- Huma FETĦUHA
                AgP1 Pl    => fethu + "na" ; -- Huma FETĦUNA
                AgP2 Pl    => fethu + "kom" ; -- Huma FETĦUKOM
                AgP3Pl    => fethu + "hom"  -- Huma FETĦUHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => fethu + "li" ; -- Huma FETĦULI
                AgP2 Sg    => fethu + "lek" ; -- Huma FETĦULEK
                AgP3Sg Masc  => fethu + "lu" ;  -- Huma FETĦULU
                AgP3Sg Fem  => fethu + "lha" ;  -- Huma FETĦULHA
                AgP1 Pl    => fethu + "lna" ; -- Huma FETĦULNA
                AgP2 Pl    => fethu + "lkom" ; -- Huma FETĦULKOM
                AgP3Pl    => fethu + "lhom"  -- Huma FETĦULHOM
              } ;
            VSuffixDirInd (GSg Masc) agr =>
              case agr of {
                AgP1 Sg    => fethu + "huli" ; -- Huma FETĦUHULI
                AgP2 Sg    => fethu + "hulek" ; -- Huma FETĦUHULEK
                AgP3Sg Masc  => fethu + "hulu" ;  -- Huma FETĦUHULU
                AgP3Sg Fem  => fethu + "hulha" ;  -- Huma FETĦUHULHA
                AgP1 Pl    => fethu + "hulna" ; -- Huma FETĦUHULNA
                AgP2 Pl    => fethu + "hulkom" ; -- Huma FETĦUHULKOM
                AgP3Pl    => fethu + "hulhom"  -- Huma FETĦUHULHOM
              } ;
            VSuffixDirInd (GSg Fem) agr =>
              case agr of {
                AgP1 Sg    => fethu + "hieli" ; -- Huma FETĦUHIELI
                AgP2 Sg    => fethu + "hielek" ; -- Huma FETĦUHIELEK
                AgP3Sg Masc  => fethu + "hielu" ;  -- Huma FETĦUHIELU
                AgP3Sg Fem  => fethu + "hielha" ;  -- Huma FETĦUHIELHA
                AgP1 Pl    => fethu + "hielna" ; -- Huma FETĦUHIELNA
                AgP2 Pl    => fethu + "hielkom" ; -- Huma FETĦUHIELKOM
                AgP3Pl    => fethu + "hielhom"  -- Huma FETĦUHIELHOM
              } ;
            VSuffixDirInd (GPl) agr =>
              case agr of {
                AgP1 Sg    => fethu + "homli" ; -- Huma FETĦUHOMLI
                AgP2 Sg    => fethu + "homlok" ; -- Huma FETĦUHOMLOK
                AgP3Sg Masc  => fethu + "homlu" ;  -- Huma FETĦUHOMLU
                AgP3Sg Fem  => fethu + "homlha" ;  -- Huma FETĦUHOMLHA
                AgP1 Pl    => fethu + "homlna" ; -- Huma FETĦUHOMLNA
                AgP2 Pl    => fethu + "homlkom" ; -- Huma FETĦUHOMLKOM
                AgP3Pl    => fethu + "homlhom"  -- Huma FETĦUHOMLHOM
              }
          }
        } ;


    {- ~~~ Strong Verb ~~~ -}

    -- Regular strong verb ("sħiħ"), eg KITEB
    -- Params: Root, Pattern
    strongV : V = overload {

      strongV : Root -> Pattern -> V = \root,patt ->
        let
          imp = conjStrongImp root patt ;
        in
        strongVWorst root patt imp ;

      strongV : Root -> Pattern -> Str -> V =\root,patt,imp_sg ->
        let
          imp = table {
            Sg => imp_sg ;
            Pl => (take 3 imp_sg) + root.C3 + "u" ;
            } ;
        in
        strongVWorst root patt imp ;

      } ;

    strongVWorst : Root -> Pattern -> (Number => Str) -> V = \root,patt,imp ->
      lin V {
        s = table {
          VPerf agr => ( conjStrongPerf r p ) ! agr ;
          VImpf agr => ( conjStrongImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
        } ;
        c = Strong Regular ;
        f = FormI ;
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

    {- ~~~ Liquid-Medial Verb ~~~ -}

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
        f = FormI ;
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

    {- ~~~ Reduplicative Verb ~~~ -}

    -- Reduplicative strong verb ("trux"), eg ĦABB
    -- Params: Root, Pattern
    reduplicativeV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjReduplicativeImp r p ;
      in lin V {
        s = table {
          VPerf agr => ( conjReduplicativePerf r p ) ! agr ;
          VImpf agr => ( conjReduplicativeImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
        } ;
        c = Strong Reduplicative ;
        f = FormI ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjReduplicativePerf : Root -> Pattern -> (Agr => Str) = \root,p ->
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
    conjReduplicativeImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjReduplicativeImp : Root -> Pattern -> (Number => Str) = \root,p ->
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

    {- ~~~ Assimilative Verb ~~~ -}

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
        f = FormI ;
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

    {- ~~~ Hollow Verb ~~~ -}

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
        f = FormI ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    -- Refer: http://blog.johnjcamilleri.com/2012/07/vowel-patterns-maltese-hollow-verb/
    conjHollowPerf : Root -> Pattern -> (Agr => Str) = \root,p ->
      let
        sar = root.C1 + p.V1 + root.C3 ;
        sir = case p.V1 + root.C2 of {
          "aw" => root.C1 + "o" + root.C3 ; -- DAM, FAR, SAQ (most common case)
          _ => root.C1 + "i" + root.C3
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
    conjHollowImpf : Str -> Str -> (Agr => Str) = \imp_sg,imp_pl ->
      let
        d = take 1 imp_sg ;
      in
      case d of {
        --- Basing the reduplication based on first letter alone is pure speculation. Seems fine though.
        #ImpfDoublingCons => table {
          AgP1 Sg    => "in" + imp_sg ;  -- Jiena INDUM
          AgP2 Sg    => "i" + d + imp_sg ;  -- Inti IDDUM
          AgP3Sg Masc  => "i" + imp_sg ;  -- Huwa IDUM
          AgP3Sg Fem  => "i" + d + imp_sg ;  -- Hija IDDUM
          AgP1 Pl    => "in" + imp_pl ;  -- Aħna INDUMU
          AgP2 Pl    => "i" + d + imp_pl ;  -- Intom IDDUMU
          AgP3Pl    => "i" + imp_pl  -- Huma IDUMU
          } ;
        _ => table {
          AgP1 Sg    => "in" + imp_sg ;  -- Jiena INĦIT
          AgP2 Sg    => "t" + imp_sg ;  -- Inti TĦIT
          AgP3Sg Masc  => "i" + imp_sg ;  -- Huwa IĦIT
          AgP3Sg Fem  => "t" + imp_sg ;  -- Hija TĦIT
          AgP1 Pl    => "in" + imp_pl ;  -- Aħna INĦITU
          AgP2 Pl    => "t" + imp_pl ;  -- Intom TĦITU
          AgP3Pl    => "i" + imp_pl  -- Huma IĦITU
          }
      } ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    -- Refer: http://blog.johnjcamilleri.com/2012/07/vowel-patterns-maltese-hollow-verb/
    conjHollowImp : Root -> Pattern -> (Number => Str) = \root,p ->
      let
        sir = case p.V1 + root.C2 of {
          "aw" => root.C1 + "u" + root.C3 ; -- DAM, FAR, SAQ (most common case)
          "aj" => root.C1 + "i" + root.C3 ; -- ĠAB, SAB, TAR
          "iej" => root.C1 + "i" + root.C3 ; -- FIEQ, RIED, ŻIED
          "iew" => root.C1 + "u" + root.C3 ; -- MIET
          _ => Predef.error("Unhandled case in hollow verb. G390KDJ")
          }
      in
      table {
        Sg => sir ;  -- Inti: SIR
        Pl => sir + "u"  -- Intom: SIRU
      } ;

    {- ~~~ Weak-Final Verb ~~~ -}

    -- Weak-Final verb, eg MEXA (M-X-J)
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
        f = FormI ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjWeakFinalPerf : Root -> Pattern -> (Agr => Str) = \root,p ->
      let
        mxej : Str = case root.C1 of {
          #LiquidCons => "i" + root.C1 + root.C2 + p.V1 + root.C3 ;
          _ => root.C1 + root.C2 + p.V1 + root.C3
          } ;
      in
        table {
          --- i tal-leħen needs to be added here!
          AgP1 Sg    => mxej + "t" ;  -- Jiena IMXEJT
          AgP2 Sg    => mxej + "t" ;  -- Inti IMXEJT
          AgP3Sg Masc  => root.C1 + p.V1 + root.C2 + p.V2 ;  -- Huwa MEXA
          AgP3Sg Fem  => root.C1 + root.C2 + "iet" ;  -- Hija IMXIET
          AgP1 Pl    => mxej + "na" ;  -- Aħna IMXEJNA
          AgP2 Pl    => mxej + "tu" ;  -- Intom IMXEJTU
          AgP3Pl    => root.C1 + root.C2 + "ew"  -- Huma IMXEW
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IMXI), Imperative Plural (eg IMXU)
    conjWeakFinalImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjWeakFinalImp : Root -> Pattern -> (Number => Str) = \root,p ->
      table {
        Sg => "i" + root.C1 + root.C2 + "i" ;  -- Inti: IMXI
        Pl => "i" + root.C1 + root.C2 + "u"  -- Intom: IMXU
      } ;

    {- ~~~ Defective Verb ~~~ -}

    -- Defective verb, eg QALA' (Q-L-GĦ)
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
        f = FormI ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjDefectivePerf : Root -> Pattern -> ( Agr => Str ) = \root,p ->
      let
        qlaj = root.C1 + root.C2 + (case p.V2 of {"e" => "i" ; _ => p.V2 }) + "j" ;
        qalgh = root.C1 + p.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => qlaj + "t" ;  -- Jiena QLAJT
          AgP2 Sg    => qlaj + "t" ;  -- Inti QLAJT
          AgP3Sg Masc  => root.C1 + p.V1 + root.C2 + p.V2 + "'" ;  -- Huwa QALA'
          AgP3Sg Fem  => qalgh + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija QALGĦET
          AgP1 Pl    => qlaj + "na" ;  -- Aħna QLAJNA
          AgP2 Pl    => qlaj + "tu" ;  -- Intom QLAJTU
          AgP3Pl    => qalgh + "u"  -- Huma QALGĦU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
    conjDefectiveImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjDefectiveImp : Root -> Pattern -> ( Number => Str ) = \root,p ->
      let
        v1 = case p.V1 of { "e" => "i" ; _ => p.V1 } ;
        v_pl : Str = case root.C2 of { #LiquidCons => "i" ; _ => "" } ; -- some verbs require "i" insertion in middle (eg AQILGĦU)
      in
        table {
          Sg => v1 + root.C1 + root.C2 + p.V2 + "'" ;  -- Inti:  AQLA' / IBŻA'
          Pl => v1 + root.C1 + v_pl + root.C2 + root.C3 + "u"  -- Intom: AQILGĦU / IBŻGĦU
        } ;

    {- ~~~ Quadriliteral Verb (Strong) ~~~ -}

    -- Make a Quad verb, eg DENDEL (D-L-D-L)
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
        c = Strong Quad ;
        f = FormI ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjQuadPerf : Root -> Pattern -> (Agr => Str) = \root,p ->
      let
        dendil = root.C1 + p.V1 + root.C2 + root.C3 + (case p.V2 of {"e" => "i" ; _ => p.V2 }) + root.C4 ;
        dendl = root.C1 + p.V1 + root.C2 + root.C3 + root.C4 ;
      in
      table {
        AgP1 Sg    => dendil + "t" ;  -- Jiena DENDILT
        AgP2 Sg    => dendil + "t" ;  -- Inti DENDILT
        AgP3Sg Masc  => root.C1 + p.V1 + root.C2 + root.C3 + p.V2 + root.C4 ;  -- Huwa DENDIL
        AgP3Sg Fem  => dendl + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija DENDLET
        AgP1 Pl    => dendil + "na" ;  -- Aħna DENDILNA
        AgP2 Pl    => dendil + "tu" ;  -- Intom DENDILTU
        AgP3Pl    => dendl + "u"  -- Huma DENDLU
      } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg DENDEL), Imperative Plural (eg DENDLU)
    conjQuadImpf : Str -> Str -> (Agr => Str) = \imp_sg,imp_pl ->
      let
        prefix_dbl : Str = case imp_sg of {
          X@#ImpfDoublingCons + _ => "i" + X ;
          _ => "t"
          } ;
      in
      table {
        AgP1 Sg    => "in" + imp_sg ;      -- Jiena INDENDEL
        AgP2 Sg    => prefix_dbl + imp_sg ;  -- Inti IDDENDEL
        AgP3Sg Masc  => "i" + imp_sg ;      -- Huwa IDENDEL
        AgP3Sg Fem  => prefix_dbl + imp_sg ;  -- Hija IDDENDEL
        AgP1 Pl    => "in" + imp_pl ;      -- Aħna INDENDLU
        AgP2 Pl    => prefix_dbl + imp_pl ;  -- Intom IDDENDLU
        AgP3Pl    => "i" + imp_pl      -- Huma IDENDLU
      } ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjQuadImp : Root -> Pattern -> (Number => Str) = \root,p ->
      table {
        Sg => root.C1 + p.V1 + root.C2 + root.C3 + p.V2 + root.C4 ;  -- Inti:  DENDEL
        Pl => root.C1 + p.V1 + root.C2 + root.C3 + root.C4 + "u"  -- Intom: DENDLU
      } ;

    {- ~~~ Quadriliteral Verb (Weak Final) ~~~ -}

    -- Make a weak-final Quad verb, eg SERVA (S-R-V-J)
    -- Params: Root, Pattern
    quadWeakV : Root -> Pattern -> V = \r,p ->
      let
        imp = conjQuadWeakImp r p ;
      in lin V {
        s = table {
          VPerf agr => ( conjQuadWeakPerf r p ) ! agr ;
          VImpf agr => ( conjQuadWeakImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        c = Weak QuadWeakFinal ;
        f = FormI ;
      } ;

    -- Conjugate entire verb in PERFECT tense
    conjQuadWeakPerf : (Agr => Str) = overload {

      -- Params: Root, Pattern
      conjQuadWeakPerf : Root -> Pattern -> (Agr => Str) = \root,p ->
        let
          --- this is known to fail for KANTA, but that seems like a less common case
          serve = root.C1 + p.V1 + root.C2 + root.C3 + "e" ;
        in
        table {
          AgP1 Sg    => serve + "jt" ;  -- Jiena SERVEJT
          AgP2 Sg    => serve + "jt" ;  -- Inti SERVEJT
          AgP3Sg Masc  => root.C1 + p.V1 + root.C2 + root.C3 + p.V2 ;  -- Huwa SERVA
          AgP3Sg Fem  => root.C1 + p.V1 + root.C2 + root.C3 + "iet" ; -- Hija SERVIET
          AgP1 Pl    => serve + "jna" ;  -- Aħna SERVEJNA
          AgP2 Pl    => serve + "jtu" ;  -- Intom SERVEJTU
          AgP3Pl    => serve + "w"  -- Huma SERVEW
        } ;

      -- This case exists for KANTA, and presumably any other Italian -are verbs.
      -- Params: Stem
      conjQuadWeakPerf : Str -> (Agr => Str) = \kanta ->
        table {
          AgP1 Sg    => kanta + "jt" ;  -- Jiena KANTAJT
          AgP2 Sg    => kanta + "jt" ;  -- Inti KANTAJT
          AgP3Sg Masc  => kanta ;  -- Huwa KANTA
          AgP3Sg Fem  => kanta + "t" ; -- Hija KANTAT
          AgP1 Pl    => kanta + "jna" ;  -- Aħna KANTAJNA
          AgP2 Pl    => kanta + "jtu" ;  -- Intom KANTAJTU
          AgP3Pl    => kanta + "w"  -- Huma KANTAW
        } ;

      } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg SERVI), Imperative Plural (eg SERVU)
    conjQuadWeakImpf : Str -> Str -> (Agr => Str) = \imp_sg,imp_pl ->
      let
        prefix_dbl : Str = case imp_sg of {
          X@#ImpfDoublingCons + _ => "i" + X ;
          _ => "t"
          } ;
      in
      table {
        AgP1 Sg    => "in" + imp_sg ;      -- Jiena INSERVI
        AgP2 Sg    => prefix_dbl + imp_sg ;  -- Inti ISSERVI
        AgP3Sg Masc  => "i" + imp_sg ;      -- Huwa ISERVI
        AgP3Sg Fem  => prefix_dbl + imp_sg ;  -- Hija ISSERVI
        AgP1 Pl    => "in" + imp_pl ;      -- Aħna INSERVU
        AgP2 Pl    => prefix_dbl + imp_pl ;  -- Intom ISSERVU
        AgP3Pl    => "i" + imp_pl      -- Huma ISERVU
      } ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjQuadWeakImp : Root -> Pattern -> (Number => Str) = \root,p ->
      table {
        --- this is known to fail for KANTA, but that seems like a less common case
        Sg => root.C1 + p.V1 + root.C2 + root.C3 + "i" ;  -- Inti: SERVI
        Pl => root.C1 + p.V1 + root.C2 + root.C3 + "u"  -- Intom: SERVU
      } ;


    {- ~~~ Non-semitic verbs ~~~ -}

    -- Make a weak-final Quad verb, eg SERVA (S-R-V-J)
    -- Params: Root, Pattern
    loanV : Str -> V = \mamma ->
      let
        imp = conjLoanImp mamma ;
      in lin V {
        s = table {
          VPerf agr => ( conjLoanPerf mamma ) ! agr ;
          VImpf agr => ( conjLoanImpf (imp ! Sg) (imp ! Pl) ) ! agr ;
          VImp n =>    imp ! n
          } ;
        c = Loan ;
        f = FormI ;
      } ;

    -- Params: Mamma
    conjLoanPerf : Str -> (Agr => Str) = \mamma ->
      case mamma of {
        _ + "ixxa" =>
          let
            issugger = tk 4 mamma ;
          in
          table {
          AgP1 Sg    => issugger + "ejt" ;  -- Jiena ISSUĠĠEREJT
          AgP2 Sg    => issugger + "ejt" ;  -- Inti ISSUĠĠEREJT
          AgP3Sg Masc  => mamma ; -- Huwa ISSUĠĠERIXXA
          AgP3Sg Fem  => issugger + "iet" ;  -- Hija ISSUĠĠERIET
          AgP1 Pl    => issugger + "ejna" ;  -- Aħna ISSUĠĠEREJNA
          AgP2 Pl    => issugger + "ejtu" ;  -- Intom ISSUĠĠEREJTU
          AgP3Pl    => issugger + "ew"  -- Huma ISSUĠĠEREW
          } ;
        _ =>
          let
            ipparkja = mamma ;
          in
          table {
          AgP1 Sg    => ipparkja + "jt" ;  -- Jiena IPPARKJAJT
          AgP2 Sg    => ipparkja + "jt" ;  -- Inti IPPARKJAJT
          AgP3Sg Masc  => ipparkja ; -- Huwa IPPARKJA
          AgP3Sg Fem  => ipparkja + "t" ;  -- Hija IPPARKJAT
          AgP1 Pl    => ipparkja + "jna" ;  -- Aħna IPPARKJAJNA
          AgP2 Pl    => ipparkja + "jtu" ;  -- Intom IPPARKJAJTU
          AgP3Pl    => ipparkja + "w"  -- Huma IPPARKJAW
          }
      } ;

    -- Conjugate entire verb in IMPERFECT, given the IMPERATIVE
    -- Params: Imperative Singular (eg IPPARKJA), Imperative Plural (eg IPPARKJAW)
    conjLoanImpf : Str -> Str -> (Agr => Str) = \imp_sg,imp_pl ->
      let
        euphonicVowel : Str = case take 1 imp_sg of {
          #Consonant => "i" ; -- STABILIXXA > NISTABILIXXA
          _ => []
          } ;
      in
      table {
        AgP1 Sg    => "n" + euphonicVowel + imp_sg ;      -- Jiena NIPPARKJA
        AgP2 Sg    => "t" + euphonicVowel + imp_sg ;  -- Inti TIPPARKJA
        AgP3Sg Masc  => "j" + euphonicVowel + imp_sg ;      -- Huwa JIPPARKJA
        AgP3Sg Fem  => "t" + euphonicVowel + imp_sg ;  -- Hija TIPPARKJA
        AgP1 Pl    => "n" + euphonicVowel + imp_pl ;      -- Aħna NIPPARKJAW
        AgP2 Pl    => "t" + euphonicVowel + imp_pl ;  -- Intom TIPPARKJAW
        AgP3Pl    => "j" + euphonicVowel + imp_pl      -- Huma JIPPARKJAW
      } ;

    -- Conjugate entire verb in IMPERATIVE tense
    -- Params: Root, Pattern
    conjLoanImp : Str -> (Number => Str) = \mamma ->
      table {
        Sg => case mamma of {
          _ + "ixxa" => (tk 1 mamma) + "i" ; -- IDDIŻUBIDIXXA > IDDIŻUBIDIXXI
          _ => mamma -- IPPARKJA > IPPARKJA
          } ;
        Pl => case mamma of {
          _ + "ixxa" => (tk 1 mamma) + "u" ; -- IDDIŻUBIDIXXA > IDDIŻUBIDIXXU
          _ => mamma + "w" -- IPPARKJA > IPPARKJAW
          }
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
