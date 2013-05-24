--# -path=.:../../:../prelude

concrete VPartsMlt2 of VParts = Maybe, Prelude, ParamX ** {

  flags
    coding = utf8;

  param
    Gender = Masc | Fem ;

    Agr =
        AgP1 Number
      | AgP2 Number
      | AgP3Sg Gender
      | AgP3Pl
      ;

    Aspect =
        Perfective
      | Imperfective
      ;

  oper
    VerbStems : Type = { s1, s2, s3 : Str } ; -- Stem variants for a single verb form; ftaħna, ftaħnie, ftaħni
    mkVerbStems : VerbStems = overload {
      mkVerbStems : (s1 : Str) -> VerbStems = \a -> { s1 = a ; s2 = a ; s3 = a } ;
      mkVerbStems : (s1, s2, s3 : Str) -> VerbStems = \a,b,c -> { s1 = a ; s2 = b ; s3 = c } ;
      } ;
    NullVerbStems : Maybe VerbStems = Nothing VerbStems { s1 = [] ; s2 = [] ; s3 = [] } ;

  lincat
    Cl = {s : Str} ;
    NP = {
      s : Str ;
      a : Agr ;
      isPron : Bool ;
      } ;
    VP = {
      s : Tense => Anteriority => Polarity => Agr => VerbStems ;
      s2 : Str ;
      dir : Maybe VerbStems ; -- ha, hie, hi
      ind : Maybe VerbStems ; -- lha, lhie, lhix
      } ;
    V  = {s : Aspect => Agr => VerbStems} ;

  lin
    she_NP = {
      s = "hi" ;
      a = AgP3Sg Fem ;
      isPron = True ;
      } ;
    we_NP = {
      s = "aħna" ;
      a = AgP1 Pl ;
      isPron = True ;
      } ;
    window_NP = {
      s = "it-tieqa" ;
      a = AgP3Sg Fem ;
      isPron = False ;
      } ;

    UseV v = {
      s = \\tense,ant,pol,agr => case <tense,pol> of {
        <Pres,Pos> => v.s ! Imperfective ! agr ;
        <Pres,Neg> => (v.s ! Imperfective ! agr) ; --** { "x" ;
        <Past,Pos> => v.s ! Perfective ! agr ;
        <Past,Neg> => (v.s ! Perfective ! agr) ; --.s2 "x" ;
        _ => mkVerbStems "TODO"
        } ;
      s2 = [] ;
      dir = NullVerbStems ;
      ind = NullVerbStems ;
      } ;

    Compl vp np = {
      s = vp.s ;
      s2 = case np.isPron of {
        True => [] ;
        False => np.s
        } ;
      dir = case np.isPron of {
        True => Just VerbStems (case np.a of {
          AgP1 Sg     => mkVerbStems "ni" ;
          AgP2 Sg     => mkVerbStems "ek" ;
          AgP3Sg Masc => mkVerbStems "h" ;
          AgP3Sg Fem  => mkVerbStems "ha" "hie" "hi" ;
          AgP1 Pl     => mkVerbStems "na" "nie" "ni"  ;
          AgP2 Pl     => mkVerbStems "kom" ;
          AgP3Pl      => mkVerbStems "hom"
          }) ;
        False => vp.dir
        } ;
      ind = vp.ind ;
      } ;

    PredVP np vp =
      let
        v : Str = joinVP (vp.s ! Past ! Simul ! Pos ! np.a) (lin VP vp) Pos ;
      in {
        s = np.s ++ v ++ vp.s2 ;
      } ;

    PredVPNeg np vp =
      let
        v : Str = joinVP (vp.s ! Past ! Simul ! Pos ! np.a) (lin VP vp) Neg ;
      in {
        s = np.s ++ "ma" ++ v ++ vp.s2 ;
      } ;

  oper
    inflectVerbStems : Str -> VerbStems = \s ->
      let
        ftahna  : Str = s ;
        ftahnie : Str = case s of { ftahn + "a" => ftahn + "ie" ; _ => s } ;
        ftahni  : Str = case s of { ftahn + "a" => ftahn + "i"  ; _ => s } ;
      in {
        s1 = ftahna ; s2 = ftahnie ; s3 = ftahni
      } ;

    inflectVerbStemsTbl : (Aspect => Agr => Str) -> (Aspect => Agr => VerbStems) = \tbl ->
      \\asp,agr => inflectVerbStems (tbl ! asp ! agr) ;

  lin
    open_V = {
      s = inflectVerbStemsTbl (table {
        Perfective => table {
          AgP1 Sg     => "ftaħt" ;
          AgP2 Sg     => "ftaħt" ;
          AgP3Sg Masc => "fetaħ" ;
          AgP3Sg Fem  => "fetħet" ;
          AgP1 Pl     => "ftaħna" ;
          AgP2 Pl     => "ftaħtu" ;
          AgP3Pl      => "fetħu"
          } ;
        Imperfective => table {
          AgP1 Sg     => "niftaħ" ;
          AgP2 Sg     => "tiftaħ" ;
          AgP3Sg Masc => "jiftaħ" ;
          AgP3Sg Fem  => "tiftaħ" ;
          AgP1 Pl     => "niftħu" ;
          AgP2 Pl     => "tiftħu" ;
          AgP3Pl      => "jiftħu"
          }
        }) ;
      } ;

  oper

    joinVP : VerbStems -> VP -> Polarity -> Str = \stems,vp,pol ->
      let x = "x" in
      case <exists VerbStems vp.dir, exists VerbStems vp.ind, pol> of {

        -- ftaħna / ftaħnie-x
        <False,False,Pos> => stems.s1 ;
        <False,False,Neg> => stems.s2 ++ BIND ++ x ;

        -- ftaħnie-ha / ftaħni-hie-x
        <True ,False,Pos> => stems.s2 ++ BIND ++ (fromJust VerbStems vp.dir).s1 ;
        <True ,False,Neg> => stems.s3 ++ BIND ++ (fromJust VerbStems vp.dir).s2 ++ BIND ++ x ;

        -- ftaħnie-lha / ftaħni-lhie-x
        <False,True ,Pos> => stems.s2 ++ BIND ++ (fromJust VerbStems vp.ind).s1 ;
        <False,True ,Neg> => stems.s3 ++ BIND ++ (fromJust VerbStems vp.ind).s2 ++ BIND ++ x ;

        -- ftaħni-hie-lha / ftaħni-hi-lhie-x
        <True, True ,Pos> => stems.s3 ++ BIND ++ (fromJust VerbStems vp.dir).s2 ++ BIND ++ (fromJust VerbStems vp.ind).s1 ;
        <True, True ,Neg> => stems.s3 ++ BIND ++ (fromJust VerbStems vp.dir).s3 ++ BIND ++ (fromJust VerbStems vp.ind).s2 ++ BIND ++ x ;

        _ => "TODO"

      } ;

}
