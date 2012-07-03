-- ResMlt.gf: Language-specific parameter types, morphology, VP formation
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2012
-- Licensed under LGPL

--# -path=.:../abstract:../common:../prelude

resource ResMlt = ParamX - [Tense] ** open Prelude in {

  flags coding=utf8 ;

  param

    NPCase = Nom | Gen ;

    -- Used in the NumeralMlt module
    CardOrd = NCard | NOrd ;

    Num_Number =
        NumSg
      | NumDual
      | NumPl
    ;
    DForm =
        Unit    -- 0..10
      | Teen    -- 11-19
      --| TeenIl  -- 11-19
      | Ten    -- 20-99
      | Hund    -- 100..999
      --| Thou    -- 1000+
    ;
    Num_Case =
        NumNominative
      | NumAdjectival ;

    Noun_Sg_Type =
        Singulative  -- eg ĦUTA
      | Collective  -- eg ĦUT
    ;
    Noun_Pl_Type =
        Determinate  -- eg ĦUTIET
      | Indeterminate  -- eg ĦWIET
    ;
    Noun_Number =
        Singular Noun_Sg_Type    -- eg ĦUTA / ĦUT
      | Dual            -- eg WIDNEJN
      | Plural Noun_Pl_Type    -- eg ĦUTIET / ĦWIET
    ;

    Gender  = Masc | Fem ;

    GenNum  = GSg Gender | GPl ; -- masc/fem/plural, e.g. adjective inflection

    Animacy =
        Animate
      | Inanimate
    ;

    Definiteness =
        Definite    -- eg IL-KARTA. In this context same as Determinate
      | Indefinite  -- eg KARTA
    ;

--    Person  = P1 | P2 | P3 ;
--    State   = Def | Indef | Const ;
--    Mood    = Ind | Cnj | Jus ;
--    Voice   = Act | Pas ;
    Origin =
        Semitic
      | Romance
      | English
    ;
--    Order   = Verbal | Nominal ;

    -- Agreement features
    Agr =
        AgP1 Number  -- Jiena, Aħna
      | AgP2 Number  -- Inti, Intom
      | AgP3Sg Gender  -- Huwa, Hija
      | AgP3Pl    -- Huma
    ;

    -- Possible tenses
    Tense =
        Perf  -- Perfect tense, eg SERAQ
      | Impf -- Imperfect tense, eg JISRAQ
      | Imp  -- Imperative, eg ISRAQ
      -- | PresPart  -- Present Particible. Intransitive and 'motion' verbs only, eg NIEŻEL
      -- | PastPart  -- Past Particible. Both verbal & adjectival function, eg MISRUQ
      -- | VerbalNoun  -- Verbal Noun, eg SERQ
    ;

    -- Possible verb forms (tense + person)
    VForm =
        VPerf Agr    -- Perfect tense in all pronoun cases
      | VImpf Agr    -- Imperfect tense in all pronoun cases
      | VImp Number  -- Imperative is always P2, Sg & Pl
      -- | VPresPart GenNum  -- Present Particible for Gender/Number
      -- | VPastPart GenNum  -- Past Particible for Gender/Number
      -- | VVerbalNoun      -- Verbal Noun
    ;

    -- Possible verb types
    VType =
        Strong  -- Strong verb: none of radicals are semi-vowels  eg ĦAREĠ (Ħ-R-Ġ)
      | Defective  -- Defective verb: third radical is semivowel GĦ  eg QATA' (Q-T-GĦ)
      | Weak    -- Weak verb: third radicl is semivowel J      eg MEXA (M-X-J)
      | Hollow  -- Hollow verb: long A or IE btw radicals 1 & 3    eg QAL (Q-W-L) or SAB (S-J-B)
      | Double  -- Double/Geminated verb: radicals 2 & 3 identical  eg ĦABB (Ħ-B-B)
      | Quad    -- Quadliteral verb                  eg KARKAR (K-R-K-R), MAQDAR (M-Q-D-R), LEMBEB (L-M-B-B)
    ;

    -- For Adjectives
    AForm =
--        AF Degree GenNum
        APosit GenNum
      | ACompar
      | ASuperl
    ;

  oper

    -- Roots & Patterns
    Pattern : Type = {v1, v2 : Str} ; -- vowel1, vowel2
    -- Root3 : Type = {K, T, B : Str} ;
    -- Root4 : Type = Root3 ** {L : Str} ;
    Root : Type = {K, T, B, L : Str} ;

    -- Some character classes
    Consonant : pattern Str = #( "b" | "ċ" | "d" | "f" | "ġ" | "g" | "għ" | "ħ" | "h" | "j" | "k" | "l" | "m" | "n" | "p" | "q" | "r" | "s" | "t" | "v" | "w" | "x" | "ż" | "z" );
    CoronalConsonant : pattern Str = #( "ċ" | "d" | "n" | "r" | "s" | "t" | "x" | "ż" | "z" ); -- "konsonanti xemxin"
    LiquidCons : pattern Str = #( "l" | "m" | "n" | "r" | "għ" );
    Vowel : pattern Str = #( "a" | "e" | "i" | "o" | "u" );
    Digraph : pattern Str = #( "ie" );
    SemiVowel : pattern Str = #( "għ" | "j" );

    {- ===== Type declarations ===== -}

    Noun : Type = {
      s : Noun_Number => Str ;
      g : Gender ;
    } ;

    ProperNoun : Type = {
      s : Str ;
      g : Gender ;
    } ;

    Adjective : Type = {
      s : AForm => Str ;
    } ;

    Verb : Type = {
      s : VForm => Str ;  -- Give me the form (tense, person etc) and I'll give you the string
      t : VType ;      -- Inherent - Strong/Hollow etc
      o : Origin ;    -- Inherent - a verb of Semitic or Romance origins?
    } ;

    {- ===== Conversions ===== -}

    numnum2nounnum : Num_Number -> Noun_Number = \n ->
      case n of {
	NumSg => Singular Singulative ;
	_ => Plural Determinate
      } ;


    {- ===== Useful helper functions ===== -}

    addDefinitePreposition : Str -> Str -> Str = \prep,n -> (getDefinitePreposition prep n) ++ n ;
    addDefiniteArticle = addDefinitePreposition "il" ;
    getDefiniteArticle = getDefinitePreposition "il" ;

    -- Correctly inflect definite preposition
    -- A more generic version of getDefiniteArticle
      -- Params:
        -- preposition (eg TAL, MAL, BĦALL)
        -- noun
    -- NOTE trying to call this with a runtime string will cause a world of pain. Design around it.
    getDefinitePreposition : Str -> Str -> Str = \prep,noun ->
      let
        -- Remove either 1 or 2 l's
        prepStem : Str = case prep of {
          _ + "ll" => Predef.tk 2 prep ;
          _ + "l"  => Predef.tk 1 prep ;
          _ => prep -- this should never happen, I don't think
        }
      in
      case noun of {
        ("s"|#LiquidCons) + #Consonant + _   => prep + "-i" ;    -- L-ISKOLA
        ("għ" | #Vowel) + _         => case prep of {    -- L-GĦATBA...
                            ("fil"|"bil")  => (Predef.take 1 prep) + "l-" ;
                            "il"       => "l" + "-" ;
                            _         => prep + "-"
                          };
        K@#CoronalConsonant + _       => prepStem + K + "-" ;  -- IĊ-ĊISK
        #Consonant + _             => prep + "-" ;      -- IL-QADDIS
        _                   => []          -- ?
      } ;

    artIndef = [] ;

    artDef : Str =
      pre {
        "il-" ;
        "l-" / strs { "a" ; "e" ; "i" ; "o" ; "u" ; "h" ; "għ" } ;
        "iċ-" / strs { "ċ" } ;
        "id-" / strs { "d" } ;
        "in-" / strs { "n" } ;
        "ir-" / strs { "r" } ;
        "is-" / strs { "s" } ;
        "it-" / strs { "t" } ;
        "ix-" / strs { "x" } ;
        "iż-" / strs { "ż" } ;
        "iz-" / strs { "z" }
      } ;

    {- ===== Worst-case functions ===== -}

    -- Noun: Takes all forms and a gender
    -- Params:
      -- Singulative, eg KOXXA
      -- Collective, eg KOXXOX
      -- Double, eg KOXXTEJN
      -- Determinate Plural, eg KOXXIET
      -- Indeterminate Plural
      -- Gender
    mkNoun : (_,_,_,_,_ : Str) -> Gender -> Noun = \sing,coll,dual,det,ind,gen -> {
      s = table {
        Singular Singulative  => sing ;
        Singular Collective    => coll ;
        Dual          => dual ;
        Plural Determinate    => det ;
        Plural Indeterminate  => ind
      } ;
      g = gen ;
    } ;

    -- Adjective: Takes all forms except superlative
    -- Params:
      -- Masculine, eg SABIĦ
      -- Feminine, eg SABIĦA
      -- Plural, eg SBIEĦ
      -- Comparative, eg ISBAĦ
    mkAdjective : (_,_,_,_ : Str) -> Adjective = \masc,fem,plural,compar -> {
      s = table {
        APosit gn => case gn of {
          GSg Masc => masc ;
          GSg Fem => fem ;
          GPl => plural
        } ;
        ACompar => compar ;
        ASuperl => addDefiniteArticle compar
      } ;
    } ;

}
