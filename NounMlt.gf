-- NounMlt.gf: noun phrases and nouns
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Angelo Zammit 2012
-- Licensed under LGPL

concrete NounMlt of Noun = CatMlt ** open ResMlt, Prelude in {

  flags
    optimize=noexpand ;

  lin
    -- Det -> CN -> NP
    DetCN det cn = {
      s = \\c => case det.isPron of {
        True => cn.s ! numnum2nounnum det.n ++ det.s ;
        False => det.s ++ cn.s ! numnum2nounnum det.n
        } ;
      a = case (numnum2nounnum det.n) of {
	Singular _ => mkAgr cn.g Sg P3 ;
	_ => mkAgr cn.g Pl P3
      } ;
      isPron = False ;
    } ;

    -- Quant -> Num -> Det
    DetQuant quant num = {
      s  = quant.s ! num.hasCard ! num.n ++ num.s ! NumNominative;
      n  = num.n ;
      hasNum = num.hasCard ;
      isPron = quant.isPron ;
    } ;

    -- Quant
    DefArt = {
      s  = \\hasCard,n => artDef ;
      isPron = False ;
    } ;
    IndefArt = {
      s  = \\hasCard,n => artIndef ;
      isPron = False ;
    } ;

    -- PN -> NP
    UsePN pn = {
      s = \\c => pn.s ;
      a = pn.a ;
      isPron = False ;
      } ;

    -- Pron -> NP
    UsePron p = {
      -- s = \\npcase => (p.s ! Personal).c1 ;
      s = table {
        Nom => (p.s ! Personal).c1 ;
        CPrep => (p.s ! Suffixed Acc).c1
        } ;
      a = p.a ;
      isPron = True ;
      } ;

    -- Pron -> Quant
    PossPron p = {
      s = \\_,_ => (p.s ! Suffixed Gen).c1 ;
      isPron = True ;
      } ;

    -- Num
    NumSg = {s = \\c => []; n = Num_1 ; hasCard = False} ;
    NumPl = {s = \\c => []; n = Num_3to10 ; hasCard = False} ;

    -- Card -> Num
    -- NumCard n = n ** {hasCard = True} ;
 
    -- Digits -> Card
    -- NumDigits n = {s = n.s ! NCard ; n = n.n} ;

    -- Digits -> Ord
    -- OrdDigits n = {s = n.s ! NOrd} ;

    -- Numeral -> Card
    -- NumNumeral numeral = {s = numeral.s ! NCard; n = numeral.n} ;

    -- Numeral -> Ord
    -- OrdNumeral numeral = {s = numeral.s ! NOrd} ;

    -- N -> CN
    UseN n = n ;

    -- N2 -> CN
    UseN2 n = n ;

-- Card
-- CN
-- Det
-- NP
-- Num
-- Ord

}
