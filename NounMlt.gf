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
        sing = n.s ! Singulative ;
        coll = if_then_Str n.hasColl
          (n.s ! Collective) -- BAQAR
          (n.s ! Plural)  -- SNIEN
          ;
        dual = n.s ! Dual ;
        plur = n.s ! Plural ;
        -- pind = n.s ! Plural Indeterminate ;
      in case det.n of {
        NumX Sg   => det' ++ sing ; -- BAQRA
        NumX Pl   => det' ++ coll ; -- BAQAR (coll) / ħafna SNIEN (pdet)
        Num0     => det' ++ sing ; -- L-EBDA BAQRA
        Num1     => det' ++ sing ; -- BAQRA
        Num2     => if_then_Str n.hasDual
          dual -- BAQARTEJN
          (det' ++ plur) -- ŻEWĠ IRĠIEL
          ;
        Num3_10  => det' ++ coll ; -- TLETT BAQAR
        Num11_19 => det' ++ sing ; -- ĦDAX-IL BAQRA
        Num20_99 => det' ++ sing -- GĦOXRIN BAQRA
      } ;

  lin
    -- Det -> CN -> NP
    DetCN det cn = {
      s = table {
        NPNom => case <det.isPron, cn.takesPron> of {
          <True,True>  => glue (cn.s ! numform2nounnum det.n) det.clitic ;
          <True,_>     => artDef ++ cn.s ! numform2nounnum det.n ++ det.s ! cn.g ;
          _            => chooseNounNumForm det cn
          } ;
        NPCPrep => cn.s ! numform2nounnum det.n
        } ;
      a = case (numform2nounnum det.n) of {
	Singulative => mkAgr Sg P3 cn.g ; --- collective?
	_           => mkAgr Pl P3 cn.g
      } ;
      isPron = False ;
      isDefn = det.isDefn ;
    } ;

    -- Quant -> Num -> Det
    DetQuant quant num = {
      s = \\gen =>
        let gennum = case num.n of { NumX Sg => GSg gen ; _ => GPl }
        in case quant.isDemo of {
          True  => quant.s ! gennum ++ artDef ++ num.s ! NumAdj ;
          False => quant.s ! gennum ++ num.s ! NumAdj
        } ;
      n = num.n ;
      clitic = quant.clitic ;
      hasNum = num.hasCard ;
      isPron = quant.isPron ;
      isDefn = quant.isDefn ;
    } ;

    -- Quant -> Num -> Ord -> Det
    --- Almost an exact copy of DetQuant, consider factoring together
    DetQuantOrd quant num ord = {
      s = \\gen =>
        let gennum = case num.n of { NumX Sg => GSg gen ; _ => GPl }
        in case quant.isDemo of {
          True  => quant.s ! gennum ++ artDef ++ num.s ! NumAdj ++ ord.s ! NumAdj ;
          False => quant.s ! gennum ++ num.s ! NumAdj ++ ord.s ! NumAdj
        } ;
      n = num.n ;
      clitic = quant.clitic ;
      hasNum = True ;
      isPron = quant.isPron ;
      isDefn = quant.isDefn ;
      } ;

    -- Det -> NP
    DetNP det = {
      -- s = case det.hasNum of {
      --   True => \\_ => det.s ! Masc ;
      --   _    => \\c => det.s ! Masc
      --   } ;
      s = \\c => det.s ! Masc ;
      a = agrP3 (numform2num det.n) Masc ;
      isPron = False ;
      isDefn = True ;
      } ;

    -- Quant
    DefArt = {
      s  = \\_ => artDef ;
      clitic = [] ;
      isPron = False ;
      isDemo = False ;
      isDefn = True ;
    } ;
    IndefArt = {
      s  = \\_ => artIndef ;
      clitic = [] ;
      isPron = False ;
      isDemo = False ;
      isDefn = False ;
    } ;

    -- PN -> NP
    UsePN pn = {
      s = \\c => pn.s ;
      a = pn.a ;
      isPron = False ;
      isDefn = False ;
      } ;

    -- Pron -> NP
    UsePron p = {
      s = table {
        NPNom   => p.s ! Personal ;
        NPCPrep => p.s ! Suffixed Acc
        } ;
      a = p.a ;
      isPron = True ;
      isDefn = False ;
      } ;

    -- Pron -> Quant
    PossPron p = {
      s = \\_ => p.s ! Possessive ;
      clitic = p.s ! Suffixed Gen ;
      isPron = True ;
      isDemo = False ;
      isDefn = True ;
      } ;

    -- Predet -> NP -> NP
    PredetNP pred np = np ** {
      s = \\c => pred.s ++ np.s ! c ;
      } ;

    -- NP -> V2 -> NP
    PPartNP np v2 = np ** {
      s = \\c => np.s ! c ++ v2.s ! VImpf (toVAgr np.a) ; --- TODO: VPresPart
      } ;

    -- NP -> RS -> NP
    RelNP np rs = np ** {
      s = \\c => np.s ! c ++ "," ++ rs.s ! np.a ;
      } ;

    -- NP -> Adv -> NP
    AdvNP np adv = np ** {
      s = \\c => np.s ! c ++ adv.s ;
      } ;

    -- Num
    NumSg = {s = \\c => []; n = NumX Sg ; hasCard = False} ;
    NumPl = {s = \\c => []; n = NumX Pl ; hasCard = False} ;

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

    -- AdN -> Card -> Card
    AdNum adn card = card ** {
      s = \\c => adn.s ++ card.s ! c ;
      } ;

    -- A -> Ord
    OrdSuperl a = {
      s = \\c => a.s ! ASuperl
      } ;

    -- CN -> NP
    MassNP cn = {
      s = \\c => cn.s ! Collective ;
      a = agrP3 Sg cn.g ;
      isPron = False ;
      isDefn = True ;
      } ;

    -- N -> CN
    UseN n = n ;

    -- N2 -> CN
    UseN2 n2 = n2 ; -- just ignore the c2

    -- N3 -> N2
    Use2N3 n3 = n3 ** { c2 = n3.c2 } ;

    -- N3 -> N2
    Use3N3 n3 = n3 ** { c2 = n3.c3 } ;

    -- N2 -> NP -> CN
    ComplN2 n2 np = {
        s = \\num => n2.s ! num ++ prepNP n2.c2 np ;
        g = n2.g ;
        hasColl = False ;
        hasDual = False ;
        takesPron = False ;
      } ;

    -- N3 -> NP -> N2
    ComplN3 n3 np = {
        s = \\num => n3.s ! num ++ prepNP n3.c3 np ;
        g = n3.g ;
        hasColl = False ;
        hasDual = False ;
        takesPron = False ;
        c2 = n3.c3
      } ;

    -- AP -> CN -> CN
    AdjCN ap cn = cn ** {
      s = \\num => preOrPost ap.isPre (ap.s ! mkGenNum num cn.g) (cn.s ! num) ;
      } ;

    -- CN -> RS -> CN
    RelCN cn rs = cn ** {
      s = \\num => cn.s ! num ++ rs.s ! mkGenNum num cn.g ;
      } ;

    -- CN -> Adv -> CN
    AdvCN cn adv = cn ** {
      s = \\num => cn.s ! num ++ adv.s
      } ;

    -- CN -> SC -> CN
    SentCN cn sc = cn ** {
      s = \\num => cn.s ! num ++ sc.s
      } ;

    -- CN -> NP -> CN
    ApposCN cn np = cn ** {
      s = \\num => cn.s ! num ++ np.s ! NPNom
      } ;
    PossNP cn np = cn ** {
      s = \\num => cn.s ! num ++ prepNP (mkPrep "ta'") np
      } ;
    PartNP cn np = cn ** {
      s = \\num => cn.s ! num ++ prepNP (mkPrep "ta'") np
      } ;

    -- Det -> NP -> NP
    CountNP det np = {
      s = \\c => det.s ! np.a.g ++ np.s ! c ;
      a = agrP3 (numform2num det.n) np.a.g ;
      isPron = False ;
      isDefn = np.isDefn ;
      } ;

  oper
    -- Copied from ParadigmsMlt (didn't want to change import structure)
    mkPrep : Str -> Prep = \fuq -> lin Prep {
      s = \\defn => fuq ;
      takesDet = False
      } ;

{-
   Warning: no linearization of AdNum
   Warning: no linearization of DetNP
   Warning: no linearization of OrdSuperl
-}
}
