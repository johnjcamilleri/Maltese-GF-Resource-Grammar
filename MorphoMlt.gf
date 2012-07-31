-- MorphoMlt.gf: scary morphology operations which needs their own elbow space
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2012
-- Licensed under LGPL

resource MorphoMlt = ResMlt ** open Prelude in {
  flags optimize=all ; coding=utf8 ;

  oper

    -- Build polarity table for verbs
    verbPolarityTable : (VForm => VSuffixForm => Str) -> (VForm => VSuffixForm => Polarity => Str) = \tbl ->
      \\vf,sfxf => --- maybe the VForm needs to be used in the cases below
      let
        s = tbl ! vf ! sfxf ;
      in table {
        Pos => s ;
        Neg => case s of {
          "" => [] ;
          x + "'" => x + "x" ; -- AQTA' > AQTAX
          x + "iek" => x + "iekx" ; -- KTIBNIEK > KTIBNIEKX
          x + "ieh" => x + "iehx" ; -- KTIBNIEH > KTIBNIEHX
          x + "ek" => x + "ekx" ; -- KTIBTLEK > KTIBTLEKX
          x + "ie" + y + "a" => x + "i" + y + "iex" ; -- FTAĦTHIELHA > FTAĦTHILHIEX
          x + "a" => x + "iex" ; -- FTAĦNA > FTAĦNIEX
          x + "e" + y@#Consonant => x + "i" + y + "x" ; -- KITEB > KITIBX
          _ => s + "x" -- KTIBT > KTIBTX
          }
      } ;

    -- Build table of pronominal suffixes for verbs
    verbPronSuffixTable : VerbInfo -> (VForm => Str) -> (VForm => VSuffixForm => Str) = \info,tbl ->
      table {
          VPerf agr => verbPerfPronSuffixTable info ( \\a => tbl ! VPerf a ) ! agr ;
          VImpf agr => verbImpfPronSuffixTable info ( \\a => tbl ! VImpf a ) ! agr ;
          VImp  num => verbImpPronSuffixTable  info ( \\n => tbl ! VImp  n ) ! num
        } ;

    -- Build table of pronominal suffixes
    -- Perfective tense
    verbPerfPronSuffixTable : VerbInfo -> (Agr => Str) -> (Agr => VSuffixForm => Str) = \info,tbl ->
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
            fetah : Str = case (tbl ! AgP3Sg Masc) of {
              x + "'" => x + "għ" ; -- QATA' > QATAGĦ
              x + "e" + y => x + "i" + y ; -- KITEB > KITIB
              x => x -- FETAĦ
              } ;
--            feth = dropSfx 2 fetah + takeSfx 1 fetah ; --- this will likely fail in many cases
            feth = takePfx 3 fetah + info.root.C3 ;
          in
          table {
            VSuffixNone => tbl ! AgP3Sg Masc ;
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
            fethit = dropSfx 2 fethet + "it" ; --- this will likely fail in many cases
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
                AgP3Sg Fem  => fethit + "hulha" ;  -- Hija FETĦITHULHA
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
            ftahn = dropSfx 1 ftahna ;
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
        } ; -- end of verbPerfPronSuffixTable

    verbImpfPronSuffixTable = verbPerfPronSuffixTable ;

    verbImpPronSuffixTable : VerbInfo -> (Number => Str) -> (Number => VSuffixForm => Str) = \info,tbl ->
      table {
        Sg => -- Inti IFTAĦ
          let
            iftah : Str = case (tbl ! Sg) of {
              x + "'" => x + "għ" ; -- AQTA' > AQTAGĦ
              x => x -- IFTAĦ
              } ;
            ifth = takePfx 3 iftah + info.root.C3 ;
          in
          table {
            VSuffixNone => (tbl ! Sg) ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => iftah + "ni" ; -- Inti IFTAĦNI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ifth + "u" ;  -- Inti IFTĦU
                AgP3Sg Fem  => iftah + "ha" ;  -- Inti IFTAĦHA
                AgP1 Pl    => iftah + "na" ; -- Inti IFTAĦNA
                AgP2 Pl    => [] ;
                AgP3Pl    => iftah + "hom"  -- Inti IFTAĦHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => iftah + "li" ; -- Inti IFTAĦLI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => iftah + "lu" ;  -- Inti IFTAĦLU
--                AgP3Sg Fem  => ifth + "ilha" ;  -- Inti IFTĦILHA
                AgP3Sg Fem  => case info.class of {
                  Weak Defective => iftah + "lha" ; -- Inti AQTAGĦLHA
                  _ => ifth + "ilha"  -- Inti IFTĦILHA
                  } ;
--                AgP1 Pl    => ifth + "ilna" ; -- Inti IFTĦILNA
                AgP1 Pl    =>  case info.class of {
                  Weak Defective => iftah + "lna" ; -- Inti AQTAGĦLNA
                  _ => ifth + "ilna"  -- Inti IFTĦILNA
                  } ;
                AgP2 Pl    => [] ;
--                AgP3Pl    => ifth + "ilhom"  -- Inti IFTĦILHOM
                AgP3Pl    =>  case info.class of {
                  Weak Defective => iftah + "lhom" ; -- Inti AQTAGĦLHOM
                  _ => ifth + "ilhom"  -- Inti IFTĦILHOM
                  }
              } ;
            VSuffixDirInd (GSg Masc) agr =>
              case agr of {
                AgP1 Sg    => iftah + "huli" ; -- Inti IFTAĦHULI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => iftah + "hulu" ;  -- Inti IFTAĦHULU
                AgP3Sg Fem  => iftah + "hulha" ;  -- Inti IFTAĦHULHA
                AgP1 Pl    => iftah + "hulna" ; -- Inti IFTAĦHULNA
                AgP2 Pl    => [] ;
                AgP3Pl    => iftah + "hulhom"  -- Inti IFTAĦHULHOM
              } ;
            VSuffixDirInd (GSg Fem) agr =>
              case agr of {
                AgP1 Sg    => iftah + "hieli" ; -- Inti IFTAĦHIELI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => iftah + "hielu" ;  -- Inti IFTAĦHIELU
                AgP3Sg Fem  => iftah + "hielha" ;  -- Inti IFTAĦHIELHA
                AgP1 Pl    => iftah + "hielna" ; -- Inti IFTAĦHIELNA
                AgP2 Pl    => [] ;
                AgP3Pl    => iftah + "hielhom"  -- Inti IFTAĦHIELHOM
              } ;
            VSuffixDirInd (GPl) agr =>
              case agr of {
                AgP1 Sg    => iftah + "homli" ; -- Inti IFTAĦHOMLI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => iftah + "homlu" ;  -- Inti IFTAĦHOMLU
                AgP3Sg Fem  => iftah + "homlha" ;  -- Inti IFTAĦHOMLHA
                AgP1 Pl    => iftah + "homlna" ; -- Inti IFTAĦHOMLNA
                AgP2 Pl    => [] ;
                AgP3Pl    => iftah + "homlhom"  -- Inti IFTAĦHOMLHOM
              }
          } ;
        Pl => -- Intom IFTĦU
          let
            ifthu = tbl ! Pl ;
          in
          table {
            VSuffixNone => ifthu ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => ifthu + "ni" ; -- Inti IFTĦUNI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ifthu + "h" ;  -- Inti IFTĦUH
                AgP3Sg Fem  => ifthu + "ha" ;  -- Inti IFTĦUHA
                AgP1 Pl    => ifthu + "na" ; -- Inti IFTĦUNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ifthu + "hom"  -- Inti IFTĦUHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => ifthu + "li" ; -- Inti IFTĦULI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ifthu + "lu" ;  -- Inti IFTĦULU
                AgP3Sg Fem  => ifthu + "lha" ;  -- Inti IFTĦULHA
                AgP1 Pl    => ifthu + "lna" ; -- Inti IFTĦULNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ifthu + "lhom"  -- Inti IFTĦULHOM
              } ;
            VSuffixDirInd (GSg Masc) agr =>
              case agr of {
                AgP1 Sg    => ifthu + "huli" ; -- Inti IFTĦUHULI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ifthu + "hulu" ;  -- Inti IFTĦUHULU
                AgP3Sg Fem  => ifthu + "hulha" ;  -- Inti IFTĦUHULHA
                AgP1 Pl    => ifthu + "hulna" ; -- Inti IFTĦUHULNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ifthu + "hulhom"  -- Inti IFTĦUHULHOM
              } ;
            VSuffixDirInd (GSg Fem) agr =>
              case agr of {
                AgP1 Sg    => ifthu + "hieli" ; -- Inti IFTĦUHIELI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ifthu + "hielu" ;  -- Inti IFTĦUHIELU
                AgP3Sg Fem  => ifthu + "hielha" ;  -- Inti IFTĦUHIELHA
                AgP1 Pl    => ifthu + "hielna" ; -- Inti IFTĦUHIELNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ifthu + "hielhom"  -- Inti IFTĦUHIELHOM
              } ;
            VSuffixDirInd (GPl) agr =>
              case agr of {
                AgP1 Sg    => ifthu + "homli" ; -- Inti IFTĦUHOMLI
                AgP2 Sg    => [] ;
                AgP3Sg Masc  => ifthu + "homlu" ;  -- Inti IFTĦUHOMLU
                AgP3Sg Fem  => ifthu + "homlha" ;  -- Inti IFTĦUHOMLHA
                AgP1 Pl    => ifthu + "homlna" ; -- Inti IFTĦUHOMLNA
                AgP2 Pl    => [] ;
                AgP3Pl    => ifthu + "homlhom"  -- Inti IFTĦUHOMLHOM
              }
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

    -- -- Derive imperative plural from singular
    -- impPlFromSg : Root -> Pattern -> Str -> VClass -> Str = \root,patt,imp_sg,class ->
    --   case class of {
    --     Strong Regular      => (takePfx 3 imp_sg) + root.C3 + "u" ; -- IFTAĦ > IFTĦU
    --     Strong LiquidMedial => (takePfx 2 imp_sg) + (charAt 3 imp_sg) + root.C2 + root.C3 + "u" ; -- OĦROĠ > OĦORĠU
    --     Strong Reduplicative=> imp_sg + "u" ; -- ŻOMM > ŻOMMU
    --     Weak Assimilative   => (takePfx 2 imp_sg) + root.C3 + "u" ; -- ASAL > ASLU
    --     Weak Hollow         => imp_sg + "u" ; -- SIR > SIRU
    --     Weak WeakFinal      => (takePfx 3 imp_sg) + "u" ; -- IMXI > IMXU
    --     Weak Defective      => (takePfx 2 imp_sg) + "i" + root.C2 + "għu" ; -- ISMA' > ISIMGĦU
    --     Strong Quad         => (takePfx 4 imp_sg) + root.C4 + "u" ; -- ĦARBAT > ĦARBTU
    --     Weak QuadWeakFinal  => case (takeSfx 1 imp_sg) of {
    --       "a" => imp_sg + "w" ; -- KANTA > KANTAW
    --       "i" => (dropSfx 1 imp_sg) + "u" ; -- SERVI > SERVU
    --       _ => Predef.error("Unaccounted case FH4748J")
    --       } ;
    --     Loan                => case imp_sg of {
    --         _ + "ixxi" => (dropSfx 1 imp_sg) + "u" ; -- IDDIŻUBIDIXXI > IDDIŻUBIDIXXU
    --         _ => imp_sg + "w" -- IPPARKJA > IPPARKJAW
    --       }
    --   } ;


    {- ~~~ Strong Verb ~~~ -}

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

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjLiquidMedialPerf : Root -> Pattern -> (Agr => Str) = \root,patt ->
      let
        zlaq = root.C1 + root.C2 + (case patt.V2 of {"e" => "i" ; _ => patt.V2 }) + root.C3 ;
        zelq = root.C1 + patt.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => zlaq + "t" ;  -- Jiena ŻLAQT
          AgP2 Sg    => zlaq + "t" ;  -- Inti ŻLAQT
          AgP3Sg Masc  => root.C1 + patt.V1 + root.C2 + patt.V2 + root.C3 ;  -- Huwa ŻELAQ
          AgP3Sg Fem  => zelq + (case patt.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija ŻELQET
          AgP1 Pl    => zlaq + "na" ;  -- Aħna ŻLAQNA
          AgP2 Pl    => zlaq + "tu" ;  -- Intom ŻLAQTU
          AgP3Pl    => zelq + "u"  -- Huma ŻELQU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IŻLOQ), Imperative Plural (eg IŻOLQU)
    conjLiquidMedialImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjLiquidMedialImp : Root -> Pattern -> (Number => Str) = \root,patt ->
      let
        stem_sg = case (patt.V1 + patt.V2) of {
          "aa" => "i" + root.C1 + root.C2 + "o" + root.C3 ; -- TALAB > ITLOB
          "ae" => "o" + root.C1 + root.C2 + "o" + root.C3 ; -- ĦAREĠ > OĦROĠ
          "ee" => "e" + root.C1 + root.C2 + "e" + root.C3 ; -- ĦELES > EĦLES
          "ea" => "i" + root.C1 + root.C2 + "o" + root.C3 ; -- ŻELAQ > IŻLOQ
          "ie" => "i" + root.C1 + root.C2 + "e" + root.C3 ; -- DILEK > IDLEK
          "oo" => "i" + root.C1 + root.C2 + "o" + root.C3   -- XOROB > IXROB
        } ;
        stem_pl = case (patt.V1 + patt.V2) of {
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

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjReduplicativePerf : Root -> Pattern -> (Agr => Str) = \root,patt ->
      let
        habb = root.C1 + patt.V1 + root.C2 + root.C3 ;
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

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjAssimilativePerf : Root -> Pattern -> (Agr => Str) = \root,patt ->
      let
        wasal = root.C1 + patt.V1 + root.C2 + patt.V2 + root.C3 ;
        wasl  = root.C1 + patt.V1 + root.C2 + root.C3 ;
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
    conjAssimilativeImp : Root -> Pattern -> (Number => Str) = \root,patt ->
      table {
        Sg => patt.V1 + root.C2 + patt.V2 + root.C3 ;  -- Inti: ASAL
        Pl => patt.V1 + root.C2 + root.C3 + "u"  -- Intom: ASLU
      } ;

    {- ~~~ Hollow Verb ~~~ -}

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    -- Refer: http://blog.johnjcamilleri.com/2012/07/vowel-patterns-maltese-hollow-verb/
    conjHollowPerf : Root -> Pattern -> (Agr => Str) = \root,patt ->
      let
        sar = root.C1 + patt.V1 + root.C3 ;
        sir = case patt.V1 + root.C2 of {
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
        d = takePfx 1 imp_sg ;
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
    conjHollowImp : Root -> Pattern -> (Number => Str) = \root,patt ->
      let
        sir = case patt.V1 + root.C2 of {
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

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjWeakFinalPerf : Root -> Pattern -> (Agr => Str) = \root,patt ->
      let
        mxej : Str = case root.C1 of {
          #LiquidCons => "i" + root.C1 + root.C2 + patt.V1 + root.C3 ;
          _ => root.C1 + root.C2 + patt.V1 + root.C3
          } ;
      in
        table {
          --- i tal-leħen needs to be added here!
          AgP1 Sg    => mxej + "t" ;  -- Jiena IMXEJT
          AgP2 Sg    => mxej + "t" ;  -- Inti IMXEJT
          AgP3Sg Masc  => root.C1 + patt.V1 + root.C2 + patt.V2 ;  -- Huwa MEXA
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
    conjWeakFinalImp : Root -> Pattern -> (Number => Str) = \root,patt ->
      table {
        Sg => "i" + root.C1 + root.C2 + "i" ;  -- Inti: IMXI
        Pl => "i" + root.C1 + root.C2 + "u"  -- Intom: IMXU
      } ;

    {- ~~~ Defective Verb ~~~ -}

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjDefectivePerf : Root -> Pattern -> ( Agr => Str ) = \root,patt ->
      let
        qlaj = root.C1 + root.C2 + (case patt.V2 of {"e" => "i" ; _ => patt.V2 }) + "j" ;
        qalgh = root.C1 + patt.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => qlaj + "t" ;  -- Jiena QLAJT
          AgP2 Sg    => qlaj + "t" ;  -- Inti QLAJT
          AgP3Sg Masc  => root.C1 + patt.V1 + root.C2 + patt.V2 + "'" ;  -- Huwa QALA'
          AgP3Sg Fem  => qalgh + (case patt.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija QALGĦET
          AgP1 Pl    => qlaj + "na" ;  -- Aħna QLAJNA
          AgP2 Pl    => qlaj + "tu" ;  -- Intom QLAJTU
          AgP3Pl    => qalgh + "u"  -- Huma QALGĦU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
    conjDefectiveImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjDefectiveImp : Root -> Pattern -> ( Number => Str ) = \root,patt ->
      let
        v1 = case patt.V1 of { "e" => "i" ; _ => patt.V1 } ;
        v_pl : Str = case root.C2 of { #LiquidCons => "i" ; _ => "" } ; -- some verbs require "i" insertion in middle (eg AQILGĦU)
      in
        table {
          Sg => v1 + root.C1 + root.C2 + patt.V2 + "'" ;  -- Inti:  AQLA' / IBŻA'
          Pl => v1 + root.C1 + v_pl + root.C2 + root.C3 + "u"  -- Intom: AQILGĦU / IBŻGĦU
        } ;

    {- ~~~ Quadriliteral Verb (Strong) ~~~ -}

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjQuadPerf : Root -> Pattern -> (Agr => Str) = \root,patt ->
      let
        dendil = root.C1 + patt.V1 + root.C2 + root.C3 + (case patt.V2 of {"e" => "i" ; _ => patt.V2 }) + root.C4 ;
        dendl = root.C1 + patt.V1 + root.C2 + root.C3 + root.C4 ;
      in
      table {
        AgP1 Sg    => dendil + "t" ;  -- Jiena DENDILT
        AgP2 Sg    => dendil + "t" ;  -- Inti DENDILT
        AgP3Sg Masc  => root.C1 + patt.V1 + root.C2 + root.C3 + patt.V2 + root.C4 ;  -- Huwa DENDIL
        AgP3Sg Fem  => dendl + (case patt.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija DENDLET
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
    conjQuadImp : Root -> Pattern -> (Number => Str) = \root,patt ->
      table {
        Sg => root.C1 + patt.V1 + root.C2 + root.C3 + patt.V2 + root.C4 ;  -- Inti:  DENDEL
        Pl => root.C1 + patt.V1 + root.C2 + root.C3 + root.C4 + "u"  -- Intom: DENDLU
      } ;

    {- ~~~ Quadriliteral Verb (Weak Final) ~~~ -}

    -- Conjugate entire verb in PERFECT tense
    -- Params: Stem
    conjQuadWeakPerf : Root -> Pattern -> Str -> (Agr => Str) = \root,patt,imp_sg ->
      case takeSfx 1 imp_sg of {
        "a" => -- KANTA
          let
            kanta = imp_sg ;
          in
          table {
            AgP1 Sg    => kanta + "jt" ;  -- Jiena KANTAJT
            AgP2 Sg    => kanta + "jt" ;  -- Inti KANTAJT
            AgP3Sg Masc  => kanta ;  -- Huwa KANTA
            AgP3Sg Fem  => kanta + "t" ; -- Hija KANTAT
            AgP1 Pl    => kanta + "jna" ;  -- Aħna KANTAJNA
            AgP2 Pl    => kanta + "jtu" ;  -- Intom KANTAJTU
            AgP3Pl    => kanta + "w"  -- Huma KANTAW
          } ;
        _ => -- SERVI
          let
            serve = root.C1 + patt.V1 + root.C2 + root.C3 + "e" ;
          in
          table {
            AgP1 Sg    => serve + "jt" ;  -- Jiena SERVEJT
            AgP2 Sg    => serve + "jt" ;  -- Inti SERVEJT
            AgP3Sg Masc  => root.C1 + patt.V1 + root.C2 + root.C3 + patt.V2 ;  -- Huwa SERVA
            AgP3Sg Fem  => root.C1 + patt.V1 + root.C2 + root.C3 + "iet" ; -- Hija SERVIET
            AgP1 Pl    => serve + "jna" ;  -- Aħna SERVEJNA
            AgP2 Pl    => serve + "jtu" ;  -- Intom SERVEJTU
            AgP3Pl    => serve + "w"  -- Huma SERVEW
          }
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
    conjQuadWeakImp : Root -> Pattern -> (Number => Str) = \root,patt ->
      table {
        --- this is known to fail for KANTA, but that seems like a less common case
        Sg => root.C1 + patt.V1 + root.C2 + root.C3 + "i" ;  -- Inti: SERVI
        Pl => root.C1 + patt.V1 + root.C2 + root.C3 + "u"  -- Intom: SERVU
      } ;


    {- ~~~ Non-semitic verbs ~~~ -}

    -- Conjugate entire verb in PERFECTIVE tense
    -- Params: mamma
    conjLoanPerf : Str -> (Agr => Str) = \mamma ->
      case mamma of {
        _ + "ixxa" =>
          let
            issugger = dropSfx 4 mamma ;
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
        euphonicVowel : Str = case takePfx 1 imp_sg of {
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
          _ + "ixxa" => (dropSfx 1 mamma) + "i" ; -- IDDIŻUBIDIXXA > IDDIŻUBIDIXXI
          _ => mamma -- IPPARKJA > IPPARKJA
          } ;
        Pl => case mamma of {
          _ + "ixxa" => (dropSfx 1 mamma) + "u" ; -- IDDIŻUBIDIXXA > IDDIŻUBIDIXXU
          _ => mamma + "w" -- IPPARKJA > IPPARKJAW
          }
      } ;




}
