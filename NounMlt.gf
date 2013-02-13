-- NounMlt.gf: noun phrases and nouns
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Angelo Zammit 2012
-- Licensed under LGPL

concrete NounMlt of Noun = CatMlt ** open ResMlt, Prelude in {

  flags
    optimize=noexpand ;

  oper
    -- Used in DetCN below
    chooseNounNumForm : Det -> CN -> Str = \det,n ->
      let
        det' = det.s ! n.g ;
        sing = n.s ! Singular Singulative ;
        coll = if_then_Str n.hasColl
          (n.s ! Singular Collective) -- BAQAR
          (n.s ! Plural Determinate)  -- SNIEN
          ;
        dual = n.s ! Dual ;
        pdet = n.s ! Plural Determinate ;
        pind = n.s ! Plural Indeterminate ;
      in case det.n of {
        Num Sg   => det' ++ sing ; -- BAQRA
        Num Pl   => det' ++ coll ; -- BAQAR (coll) / ħafna SNIEN (pdet)
        Num0     => det' ++ sing ; -- L-EBDA BAQRA
        Num1     => det' ++ sing ; -- BAQRA
        Num2     => if_then_Str n.hasDual 
          dual -- BAQARTEJN
          (det' ++ pdet) -- ŻEWĠ IRĠIEL
          ;
        Num3_10  => det' ++ coll ; -- TLETT BAQAR
        Num11_19 => det' ++ sing ; -- ĦDAX-IL BAQRA
        Num20_99 => det' ++ sing -- GĦOXRIN BAQRA
      } ;

  lin
    -- Det -> CN -> NP
    DetCN det cn = {
      s = \\c => case <det.isPron,det.hasNum> of {
        <True,_>  => cn.s ! numform2nounnum det.n ++ det.s ! cn.g ;
--      <_,True>  => chooseNounNumForm det cn
        _         => chooseNounNumForm det cn
        } ;
      a = case (numform2nounnum det.n) of {
	Singular _ => mkAgr cn.g Sg P3 ;
	_          => mkAgr cn.g Pl P3
      } ;
      isPron = False ;
    } ;

    -- Quant -> Num -> Det
    DetQuant quant num = {
      s = \\gen =>
        let gennum = case num.n of { Num Sg => GSg gen ; _ => GPl }
        in case quant.isDemo of {
          True  => quant.s ! gennum ++ artDef ++ num.s ! NumAdj ;
          False => quant.s ! gennum ++ num.s ! NumAdj
        } ;
      n = num.n ;
      hasNum = num.hasCard ;
      isPron = quant.isPron ;
    } ;

    -- Quant -> Num -> Ord -> Det
    --- Almost an exact copy of DetQuant, consider factoring together
    DetQuantOrd quant num ord = {
      s = \\gen => 
        let gennum = case num.n of { Num Sg => GSg gen ; _ => GPl }
        in case quant.isDemo of {
          True  => quant.s ! gennum ++ artDef ++ num.s ! NumAdj ++ ord.s ! NumAdj ;
          False => quant.s ! gennum ++ num.s ! NumAdj ++ ord.s ! NumAdj
        } ;
      n = num.n ;
      hasNum = True ;
      isPron = quant.isPron ;
      } ;

    -- Quant
    DefArt = {
      s  = \\_ => artDef ;
      isPron = False ;
      isDemo = False ;
    } ;
    IndefArt = {
      s  = \\_ => artIndef ;
      isPron = False ;
      isDemo = False ;
    } ;

    -- PN -> NP
    UsePN pn = {
      s = \\c => pn.s ;
      a = pn.a ;
      isPron = False ;
      } ;

    -- Pron -> NP
    UsePron p = {
      s = table {
        Nom => p.s ! Personal ;
        CPrep => p.s ! Suffixed Acc
        } ;
      a = p.a ;
      isPron = True ;
      } ;

    -- Pron -> Quant
    PossPron p = {
      s = \\_ => p.s ! Suffixed Gen ;
      isPron = True ;
      isDemo = False ;
      } ;

    -- Num
    NumSg = {s = \\c => []; n = Num Sg ; hasCard = False} ;
    NumPl = {s = \\c => []; n = Num Pl ; hasCard = False} ;

    -- Card -> Num
    NumCard n = n ** {hasCard = True} ;
 
    -- Digits -> Card
    NumDigits d = {s = d.s ; n = d.n} ;

    -- Digits -> Ord
    OrdDigits d = {s = d.s} ;

    -- Numeral -> Card
    NumNumeral numeral = {s = numeral.s ! NCard; n = numeral.n} ;

    -- Numeral -> Ord
    OrdNumeral numeral = {s = numeral.s ! NOrd} ;

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
