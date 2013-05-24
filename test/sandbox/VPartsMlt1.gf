--# -path=.:../../:../prelude

concrete VPartsMlt1 of VParts = Maybe, Prelude, ParamX ** {

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

  lincat
    Cl = {s : Str} ;
    NP = {s : Str; a : Agr} ;
    VP = {s : Tense => Anteriority => Polarity => Agr => Str ; s2 : Str } ;
    V  = {s : Aspect => Agr => Str} ;

  lin
    she_NP = {
      s = "hi" ;
      a = AgP3Sg Fem ;
      } ;
    we_NP = {
      s = "aħna" ;
      a = AgP1 Pl ;
      } ;
    window_NP = {
      s = "it-tieqa" ;
      a = AgP3Sg Fem ;
      } ;

    UseV v = {
      s = \\tense,ant,pol,agr => case <tense,pol> of {
        <Pres,Pos> => v.s ! Imperfective ! agr ;
        <Pres,Neg> => glue (v.s ! Imperfective ! agr) "x" ;
        <Past,Pos> => v.s ! Perfective ! agr ;
        <Past,Neg> => glue (v.s ! Perfective ! agr) "x" ;
        _ => "TODO"
        } ;
      s2 = [] ;
      } ;

    Compl vp np = {
      s = vp.s ;
      s2 = np.s ;
      } ;

    PredVP np vp = {
      s = np.s ++ vp.s ! Past ! Simul ! Pos ! np.a ++ vp.s2 ;
      } ;

    PredVPNeg np vp = {
      s = np.s ++ "ma" ++ vp.s ! Past ! Simul ! Neg ! np.a ++ vp.s2 ;
      } ;

  lin
    open_V = {
      s = table {
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
        } ;
      } ;

}
