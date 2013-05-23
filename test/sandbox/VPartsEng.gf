--# -path=.:../../:../prelude

concrete VPartsEng of VParts = Maybe, Prelude ** {

  flags
    coding = utf8;

  oper
    S1 : Type = {s1 : Str} ;
    S2 : Type = {s1, s2 : Str} ;
    S3 : Type = {s1, s2, s3 : Str} ;
    NullS3 = Nothing S3 {s1="";s2="";s3=""};

    VerbParts : Type = {
      stem : S3 ;
      dir  : Maybe S3 ;
      ind  : Maybe S3 ;
      pol  : Maybe S1
      } ;

    joinVParts : VerbParts -> Str = \v ->
      case <exists S3 v.dir, exists S3 v.ind, exists S1 v.pol> of {

        -- ftaħna / ftaħnie-x
        <False,False,False> => v.stem.s1 ;
        <False,False,True>  => v.stem.s2 ++ BIND ++ (fromJust S1 v.pol).s1 ;

        -- ftaħnie-ha / ftaħni-hie-x
        <True ,False,False> => v.stem.s2 ++ BIND ++ (fromJust S3 v.dir).s1 ;
        <True ,False,True>  => v.stem.s3 ++ BIND ++ (fromJust S3 v.dir).s2 ++ BIND ++ (fromJust S1 v.pol).s1 ;

        -- ftaħnie-lha / ftaħni-lhie-x
        <False,True ,False> => v.stem.s2 ++ BIND ++ (fromJust S3 v.ind).s1 ;
        <False,True ,True>  => v.stem.s3 ++ BIND ++ (fromJust S3 v.ind).s2 ++ BIND ++ (fromJust S1 v.pol).s1 ;

        -- ftaħni-hie-lha / ftaħni-hi-lhie-x
        <True, True,False> => v.stem.s3 ++ BIND ++ (fromJust S3 v.dir).s2 ++ BIND ++ (fromJust S3 v.ind).s1 ;
        <True, True, True> => v.stem.s3 ++ BIND ++ (fromJust S3 v.dir).s3 ++ BIND ++ (fromJust S3 v.ind).s2 ++ BIND ++ (fromJust S1 v.pol).s1

      } ;

  lincat
    V = VerbParts ;
    S = {s : Str} ;

  lin
    ftahna = {
      stem = {s1="ftaħna" ; s2="ftaħnie" ; s3="ftaħni"} ;
      dir  = Just S3 {s1="ha"  ; s2="hie"  ; s3="hi"} ;
      ind  = Just S3 {s1="lha" ; s2="lhie" ; s3="lhi"} ;
      pol  = Just S1 {s1="x" } ;
      } ;

    join v = {
      s = joinVParts v
      } ;
}
