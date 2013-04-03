-- StructuralMlt.gf: lexicon of structural words
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Licensed under LGPL

concrete StructuralMlt of Structural = CatMlt **
  open MorphoMlt, ResMlt, ParadigmsMlt, (C = ConstructX), Prelude in {

  flags
    optimize=all ;  
    coding=utf8 ;

  lin
    
    {- Pronoun -------------------------------------------------------------- -}
    
    i_Pron      = mkPron "jien"  "i"   "ni" "li"  singular P1 masculine ; --- also JIENA
    youSg_Pron  = mkPron "int"   "ek"  "ek" "lek" singular P2 masculine ; --- also INTI
    he_Pron     = mkPron "hu"    "u"   "u"  "lu"  singular P3 masculine ; --- also HUWA
    she_Pron    = mkPron "hi"    "ha"             singular P3 feminine  ; --- also HIJA
    we_Pron     = mkPron "aħna"  "na"             plural   P1 masculine ;
    youPl_Pron  = mkPron "intom" "kom"            plural   P2 masculine ;
    they_Pron   = mkPron "huma"  "hom"            plural   P3 masculine ;
    youPol_Pron = youSg_Pron ;
    -- it_Pron     = mkPron "it" "it" "its" "its" singular P3 nonhuman ;

    whatPl_IP = mkIP ("x'" ++ BIND) plural ;
    whatSg_IP = mkIP ("x'" ++ BIND) singular ;
    whoPl_IP  = mkIP "min" plural ;
    whoSg_IP  = mkIP "min" singular ;

    {- Determiner ----------------------------------------------------------- -}

    all_Predet  = ss "kollha" ;
    -- every_Det = mkDeterminerSpec singular "every" "everyone" False ;
    few_Det     = mkDeterminer plural "ftit" ;
    many_Det    = mkDeterminer plural "ħafna" ;
    most_Predet = ss "il-maġġoranza ta'" ; --- TAL-, TAN-
    -- much_Det = mkDeterminer singular "much" ;
    only_Predet = ss "biss" ;
    someSg_Det  = mkDeterminer singular "xi" ;
    somePl_Det  = mkDeterminer plural "xi" ;
    not_predet  = ss "mhux" ;
    
    {- Quantifier ----------------------------------------------------------- -}

    that_Quant = mkQuant "dak" "dik" "dawk" True ;
    this_Quant = mkQuant "dan" "din" "dawn" True ;
    no_Quant = let l_ebda = artDef ++ "ebda" in
      mkQuant l_ebda l_ebda l_ebda False ;
    -- which_IQuant = {s = \\_ => "which"} ;

    {- Conjunction ---------------------------------------------------------- -}

    and_Conj        = mkConj "u" ;
    both7and_DConj  = mkConj "kemm" "u";
    but_PConj       = ss "imma" ;
    either7or_DConj = mkConj "jew" "inkella" ;
    or_Conj         = mkConj "jew" ;
    otherwise_PConj = ss "inkella" ;
    therefore_PConj = ss "allura" ;
    if_then_Conj    = mkConj "jekk" ;

    {- Preposition ---------------------------------------------------------- -}

    above_Prep    = mkPrep "fuq" ;
    after_Prep    = mkPrep "wara" ;
    before_Prep   = mkPrep "qabel" ;
    behind_Prep   = mkPrep "wara" ;
    between_Prep  = mkPrep "bejn" ;
    by8agent_Prep = mkPrep "minn" "mill-" "mit-" ;
    by8means_Prep = mkPrep "bi" "b'" "bil-" "bit-" "bl-" ;
    during_Prep   = mkPrep "waqt" ;
    for_Prep      = mkPrep "għal" "għall-" "għat-" ;
    from_Prep     = mkPrep "minn" "mill-" "mit-" ;
    in8front_Prep = mkPrep "quddiem" ;
    in_Prep       = mkPrep "fi" "f'" "fil-" "fit-" "fl-" ;
    on_Prep       = mkPrep "fuq" ;
    part_Prep     = mkPrep "ta'" "t'" "tal-" "tat-" "tal-" ;
    possess_Prep  = mkPrep "ta'" "t'" "tal-" "tat-" "tal-" ;
    through_Prep  = mkPrep "ġo" "ġol-" "ġot-" ;
    to_Prep       = mkPrep "lil" "lill-" "lit-" ;
    under_Prep    = mkPrep "taħt" ;
    without_Prep  = mkPrep "mingħajr" ;
    with_Prep     = mkPrep "ma'" "m'" "mal-" "mat-" "mal-" ;
    except_Prep   = mkPrep "apparti" ;

    {- Noun phrase ---------------------------------------------------------- -}

    everybody_NP  = regNP "kulħadd" ;
    everything_NP = regNP "kollox" ;
    somebody_NP   = regNP "xi ħadd" ;
    something_NP  = regNP "xi ħaġa" ;
    nobody_NP     = regNP "ħadd" ;
    nothing_NP    = regNP "xejn" ;

    {- Subjunction ---------------------------------------------------------- -}

    although_Subj = ss "avolja" ;
    because_Subj  = ss "għax" ;
    if_Subj       = ss "jekk" ;
    when_Subj     = ss "meta" ;
    that_Subj     = ss "li" ;

    {- Adverb --------------------------------------------------------------- -}

    almost_AdA     = mkAdA "kważi" ;
    almost_AdN     = mkAdN "kważi" ;
    always_AdV     = mkAdV "dejjem" ;
    at_least_AdN   = mkAdN "mill-inqas" ;
    at_most_AdN    = mkAdN "l-iktar" ;
    everywhere_Adv = mkAdv "kullimkien" ;
    here_Adv       = mkAdv "hawn" ;
    here7to_Adv    = mkAdv ["s'hawnhekk"] ;
    here7from_Adv  = mkAdv ["minn hawnhekk"] ;
    less_CAdv      = C.mkCAdv "inqas" "minn" ; --- INQAS MILL-IEĦOR
    more_CAdv      = C.mkCAdv "iktar" "minn" ; --- IKTAR MIT-TNEJN
    quite_Adv      = mkAdv "pjuttost" ;
    so_AdA         = mkAdA "allura" ;
    somewhere_Adv  = mkAdv "x'imkien" ;
    there_Adv      = mkAdv "hemmhekk" ;
    there7to_Adv   = mkAdv "s'hemmhekk" ;
    there7from_Adv = mkAdv ["minn hemmhekk"] ;
    too_AdA        = mkAdA "ukoll" ;
    very_AdA       = mkAdA "ħafna" ;
    as_CAdv        = C.mkCAdv "" "daqs" ; -- "as good as gold"

    how_IAdv      = ss "kif" ;
    how8much_IAdv = ss "kemm" ;
    when_IAdv     = ss "meta" ;
    where_IAdv    = ss "fejn" ;
    why_IAdv      = ss "għalfejn" ;
    
    {- Others --------------------------------------------------------------- -}

    -- can8know_VV, can_VV = {
    --   s = table { 
    --     VVF VInf => ["be able to"] ;
    --     VVF VPres => "can" ;
    --     VVF VPPart => ["been able to"] ;
    --     VVF VPresPart => ["being able to"] ;
    --     VVF VPast => "could" ;      --# notpresent
    --     VVPastNeg => "couldn't" ;   --# notpresent
    --     VVPresNeg => "can't"
    --     } ;
    --   typ = VVAux
    --   } ;
    -- how8many_IDet = mkDeterminer plural ["how many"] ;
    -- must_VV = {
    --   s = table {
    --     VVF VInf => ["have to"] ;
    --     VVF VPres => "must" ;
    --     VVF VPPart => ["had to"] ;
    --     VVF VPresPart => ["having to"] ;
    --     VVF VPast => ["had to"] ;      --# notpresent
    --     VVPastNeg => ["hadn't to"] ;      --# notpresent
    --     VVPresNeg => "mustn't"
    --     } ;
    --   typ = VVAux
    --   } ;
    -- want_VV = mkVV (regV "want") ;
    
    have_V2 = dirV2 (
      irregularV form1 (ResMlt.mkRoot) (ResMlt.mkPattern)
        "kelli" "kellek" "kellu" "kellha" "kellna" "kellkom" "kellhom"
        "għandi" "għandek" "għandu" "għandha" "għandna" "għandkom" "għandhom"
        "kollok" "kollkom"
      ) ;

    please_Voc = ss "jekk jgħoġbok" ; --- JEKK JGĦOĠOBKOM

    no_Utt = ss "le" ;
    yes_Utt = ss "iva" ;

    language_title_Utt = ss "Malti" ;

}
