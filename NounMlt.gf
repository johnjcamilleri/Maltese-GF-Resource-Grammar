-- NounMlt.gf: noun phrases and nouns
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2012
-- Licensed under LGPL

concrete NounMlt of Noun = CatMlt ** open ResMlt, Prelude in {

  flags
    optimize=noexpand ;

  lin
    -- Det -> CN -> NP
    DetCN det cn = {
      s = \\c => det.s ++ cn.s ! numnum2nounnum det.n ; 
      a = case (numnum2nounnum det.n) of {
	Singular _ => mkAgr cn.g Sg P3 ;
	_ => mkAgr cn.g Pl P3
      } ;
      isPron = False ;
      -- s = \\c => det.s ++ cn.s ! det.n ! npcase2case c ; 
      -- a = agrgP3 det.n cn.g
    } ;

    -- Quant -> Num -> Det
    DetQuant quant num = {
      s  = quant.s ! num.hasCard ! num.n ++ num.s ! NumNominative;
      -- sp = \\c => case num.hasCard of {
      --                False => quant.sp ! num.hasCard ! num.n ! c ++ num.s ! Nom ;
      --                True  => quant.sp ! num.hasCard ! num.n ! npNom ++ num.s ! npcase2case c
      --             } ;
      n  = num.n ;
      hasNum = num.hasCard
    } ;

    -- Quant
    DefArt = {
      s  = \\hasCard,n => artDef ;
      -- sp = \\hasCard,n => case <n,hasCard> of {
      --   <Sg,False> => table { NCase Gen => "its"; _ => "it" } ;
      --   <Pl,False> => table { NCase Nom => "they"; NPAcc => "them"; NCase Gen => "theirs" } ;
      --   _          => \\c => artDef
      --   }
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

    -- Num
    NumSg = {s = \\c => []; n = Num_Sg ; hasCard = False} ;
    NumPl = {s = \\c => []; n = Num_Pl ; hasCard = False} ;

    UseN n = n ;
    UseN2 n = n ;

-- Card
-- CN
-- Det
-- NP
-- Num
-- Ord

}
