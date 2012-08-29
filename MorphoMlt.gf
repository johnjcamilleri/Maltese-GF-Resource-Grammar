-- MorphoMlt.gf: scary morphology operations which need their own elbow space
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2012
-- Licensed under LGPL

resource MorphoMlt = ResMlt ** open Prelude in {
  flags optimize=all ; coding=utf8 ;

  oper

    -- Build polarity table for verbs
    verbPolarityTable : VerbInfo -> (VForm => VSuffixForm => Str) -> (VForm => VSuffixForm => Polarity => Str) = \info,tbl ->
      \\vf,sfxf => --- maybe the VForm needs to be used in the cases below
      let
        s = tbl ! vf ! sfxf ;
      in table {
        Pos => s ;
        Neg => case s of {
          "" => [] ;
          _ + "xx"  => s ; -- BEXX > BEXX
          aqta+"'" => aqta+"x" ; -- AQTA' > AQTAX

          z+"ie"+d+"et" => z+"i"+d+"itx" ; -- ŻIEDET > ŻIDITX

          ftahth+"ie"+lh+"a" => ftahth+"i"+lh+"iex" ; -- FTAĦTHIELHA > FTAĦTHILHIEX
          ftahtuh+"ie"+li => case isMonoSyl s of {
            True => s + "x" ; -- MIET > MIETX 
            _ => ftahtuh+"i"+li+"x" -- FTAĦTUHIELI > FTAĦTUHILIX
            } ;

          ktibtl+"ek"  => ktibtl+"ekx" ; -- KTIBTLEK > KTIBTLEKX
          xamm+"ew"  => xamm+"ewx" ; -- XAMMEW > XAMMEWX

          x + "a"   => case <info.imp, vf, sfxf> of {
            <_ + "a", VPerf (AgP3Sg Masc), VSuffixNone> => x + "ax" ; -- KANTA > KANTAX
            <_ + "a", VImpf _, VSuffixNone> => x + "ax" ; -- KANTA > KANTAX
            <_ + "a", VImp _, VSuffixNone> => x + "ax" ; -- KANTA > KANTAX
            _ => x + "iex" -- FTAĦNA > FTAĦNIEX
            } ;
          ki+t@#Consonant+"e"+b@#Consonant => ki+t+"i"+b+"x" ; -- KITEB > KITIBX
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

    -- Build table of pronominal suffixes: Perfective tense
    -- Params: verb info, imperative table, perfective table
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
                AgP3Sg Masc=> ftaht + "u" ;  -- Jiena FTAĦTU
                AgP3Sg Fem => ftaht + "ha" ;  -- Jiena FTAĦTHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftaht + "kom" ;  -- Jiena FTAĦTKOM
                AgP3Pl     => ftaht + "hom"  -- Jiena FTAĦTHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftaht + "lek" ;  -- Jiena FTAĦTLEK
                AgP3Sg Masc=> ftaht + "lu" ;  -- Jiena FTAĦTLU
                AgP3Sg Fem => ftaht + "ilha" ;  -- Jiena FTAĦTILHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftaht + "ilkom" ;  -- Jiena FTAĦTILKOM
                AgP3Pl     => ftaht + "ilhom"  -- Jiena FTAĦTILHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP1 Sg) do ftaht) ! agr
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
                AgP3Sg Masc=> ftaht + "u" ;  -- Inti FTAĦTU
                AgP3Sg Fem => ftaht + "ha" ;  -- Inti FTAĦTHA
                AgP1 Pl    => ftaht + "na" ; -- Inti FTAĦTNA
                AgP2 Pl    => [] ;
                AgP3Pl     => ftaht + "hom"  -- Inti FTAĦTHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => ftaht + "li" ; -- Inti FTAĦTLI
                AgP2 Sg    => [] ;
                AgP3Sg Masc=> ftaht + "lu" ;  -- Inti FTAĦTLU
                AgP3Sg Fem => ftaht + "ilha" ;  -- Inti FTAĦTILHA
                AgP1 Pl    => ftaht + "ilna" ; -- Inti FTAĦTILNA
                AgP2 Pl    => [] ;
                AgP3Pl     => ftaht + "ilhom"  -- Inti FTAĦTILHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP2 Sg) do ftaht) ! agr
          } ;
        AgP3Sg Masc => -- Huwa FETAĦ
          let
            mamma = tbl ! AgP3Sg Masc ;
            fetah : Str = case <info.imp, mamma> of {
              <_, x + "'"> => x + "għ" ; -- QATA' > QATAGĦ
              <_ + "a", _> =>  mamma ; -- KANTA > KANTA (i.e. Italian -are)
              <_, serv + "a"> => serv + "ie" ; -- SERVA > SERVIE (i.e. Italian -ere/-ire)
              <_, x + y@#Consonant + "e" + z@#Consonant> => x + y + "i" + z ; -- KITEB > KITIB
              _ => mamma -- FETAĦ
              } ;
            -- fetah : Str = case (tbl ! AgP3Sg Masc) of {
            --   x + "'" => x + "għ" ; -- QATA' > QATAGĦ
            --   x + "a" => x + "ie" ; -- SERVA > SERVIE
            --   x + "e" + y@#Consonant => x + "i" + y ; -- KITEB > KITIB
            --   x => x -- FETAĦ
            --   } ;
            feth = case info.class of {
              Weak Hollow => info.root.C1 + info.patt.V1 + info.root.C3 ; -- SAB
              Weak Lacking => info.root.C1 + info.patt.V1 + info.root.C2 ; -- MEX
              Quad QStrong => info.root.C1 + info.patt.V1 + info.root.C2 + info.root.C3 + info.root.C4 ;
              Loan => dropSfx 1 mamma ; -- ŻVILUPP
              _ => info.root.C1 + info.patt.V1 + info.root.C2 + info.root.C3
              } ;
            p2sg_dir_ek : Str = case <info.imp, mamma> of {
              <_ + "a", _> => "ak" ; -- Huwa KANTAK
              <_, _ + "a"> => "iek" ; -- Huwa SERVIEK
              _ => "ek" -- Huwa FETĦEK
              } ;
            p3sg_dir_u : Str = case <info.imp, mamma> of {
              <_ + "a", _> => "ah" ; -- Huwa KANTAH
              <_, _ + "a"> => "ieh" ; -- Huwa SERVIEH
              _ => "u" -- Huwa FETĦU
              } ;
          in
          table {
            VSuffixNone => tbl ! AgP3Sg Masc ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => sfx fetah "ni" ; -- Huwa FETAĦNI (n.b. KENN+NI)
                AgP2 Sg    => feth + p2sg_dir_ek ;
                AgP3Sg Masc=> feth + p3sg_dir_u ;
                AgP3Sg Fem => fetah + "ha" ;  -- Huwa FETAĦHA
                AgP1 Pl    => sfx fetah "na" ; -- Huwa FETAĦNA (n.b. KENN+NA)
                AgP2 Pl    => sfx fetah "kom" ; -- Huwa FETAĦKOM (n.b. ĦAKK+KOM)
                AgP3Pl     => fetah + "hom"  -- Huwa FETAĦHOM
              } ;
            VSuffixInd agr =>
              let
                fethi : Str = case info.imp of {
                  _ + "a" => feth + "a" ; -- KANTA-
                  _ + "i" => feth + "ie" ; -- SERVIE-
                  _ => (ie2i feth) + "i"
                  } ;
              in
              case agr of {
                AgP1 Sg    => sfx fetah "li" ; -- Huwa FETAĦLI (n.b. ĦALL+LI)
                AgP2 Sg    => sfx fetah "lek" ; -- Huwa FETAĦLEK (n.b. ĦALL+LEK)
                AgP3Sg Masc=> sfx fetah "lu" ;  -- Huwa FETAĦLU (n.b. ĦALL+LU)
                AgP3Sg Fem => fethi + "lha" ;  -- Huwa FETĦILHA
                AgP1 Pl    => fethi + "lna" ; -- Huwa FETĦILNA
                AgP2 Pl    => fethi + "lkom" ; -- Huwa FETĦILKOM
                AgP3Pl     => fethi + "lhom"  -- Huwa FETĦILHOM
              } ;
            VSuffixDirInd do agr => case info.imp of {
              _ + "i" => (verbDirIndSuffixTable (AgP3Sg Masc) do (feth+"i")) ! agr ; -- SERVI-
              _ => (verbDirIndSuffixTable (AgP3Sg Masc) do (ie2i fetah)) ! agr
              }
          } ;
        AgP3Sg Fem => -- Hija FETĦET
          let
            fethet = tbl ! AgP3Sg Fem ;
            fethit : Str = case fethet of {
              _ + "iet" => fethet ; -- SERVIET
              feth + "et" => (ie2i feth) + "it" ;
              _ => fethet -- QRAT, ŻVILUPPAT...
              } ;
          in
          table {
            VSuffixNone => fethet ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => fethit + "ni" ; -- Hija FETĦITNI
                AgP2 Sg    => fethit + "ek" ; -- Hija FETĦITEK
                AgP3Sg Masc=> fethit + "u" ;  -- Hija FETĦITU
                AgP3Sg Fem => fethit + "ha" ;  -- Hija FETĦITHA
                AgP1 Pl    => fethit + "na" ; -- Hija FETĦITNA
                AgP2 Pl    => fethit + "kom" ; -- Hija FETĦITKOM
                AgP3Pl     => fethit + "hom"  -- Hija FETĦITHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => fethit + "li" ; -- Hija FETĦITLI
                AgP2 Sg    => fethit + "lek" ; -- Hija FETĦITLEK
                AgP3Sg Masc=> fethit + "lu" ;  -- Hija FETĦITLU
                AgP3Sg Fem => (ie2i fethit) + "ilha" ;  -- Hija FETĦITILHA
                AgP1 Pl    => (ie2i fethit) + "ilna" ; -- Hija FETĦITILNA
                AgP2 Pl    => (ie2i fethit) + "ilkom" ; -- Hija FETĦITILKOM
                AgP3Pl     => (ie2i fethit) + "ilhom"  -- Hija FETĦITILHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP3Sg Fem) do (ie2i fethit)) ! agr
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
                AgP3Sg Masc=> ftahn + "ieh" ;  -- Aħna FTAĦNIEH
                AgP3Sg Fem => ftahn + "ieha" ;  -- Aħna FTAĦNIEHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftahn + "iekom" ;  -- Aħna FTAĦNIEKOM
                AgP3Pl     => ftahn + "iehom"  -- Aħna FTAĦNIEHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => ftahn + "ielek" ;  -- Aħna FTAĦNIELEK
                AgP3Sg Masc=> ftahn + "ielu" ;  -- Aħna FTAĦNIELU
                AgP3Sg Fem => ftahn + "ielha" ;  -- Aħna FTAĦNIELHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => ftahn + "ielkom" ;  -- Aħna FTAĦNIELKOM
                AgP3Pl     => ftahn + "ielhom"  -- Aħna FTAĦNIELHOM
              } ;
            VSuffixDirInd (GSg Masc) agr => (verbDirIndSuffixTable (AgP1 Pl) (GSg Masc) (ftahn+"i")) ! agr ;
            VSuffixDirInd (GSg Fem) agr => (verbDirIndSuffixTable (AgP1 Pl) (GSg Fem) (ftahn+"i")) ! agr ;
            VSuffixDirInd (GPl) agr => (verbDirIndSuffixTable (AgP1 Pl) (GPl) (ftahn+"i")) ! agr
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
                AgP3Sg Masc=> ftahtu + "h" ;  -- Intom FTAĦTUH
                AgP3Sg Fem => ftahtu + "ha" ;  -- Intom FTAĦTUHA
                AgP1 Pl    => ftahtu + "na" ; -- Intom FTAĦTUNA
                AgP2 Pl    => [] ;
                AgP3Pl     => ftahtu + "hom"  -- Intom FTAĦTUHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => ftahtu + "li" ; -- Intom FTAĦTULI
                AgP2 Sg    => [] ;
                AgP3Sg Masc=> ftahtu + "lu" ;  -- Intom FTAĦTULU
                AgP3Sg Fem => ftahtu + "lha" ;  -- Intom FTAĦTULHA
                AgP1 Pl    => ftahtu + "lna" ; -- Intom FTAĦTULNA
                AgP2 Pl    => [] ;
                AgP3Pl     => ftahtu + "lhom"  -- Intom FTAĦTULHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP2 Pl) do ftahtu) ! agr
          } ;
        AgP3Pl => -- Huma FETĦU
          let
            fethu = ie2i (tbl ! AgP3Pl) ;
          in
          table {
            VSuffixNone => tbl ! AgP3Pl ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => fethu + "ni" ; -- Huma FETĦUNI
                AgP2 Sg    => fethu + "k" ; -- Huma FETĦUK
                AgP3Sg Masc=> fethu + "h" ;  -- Huma FETĦUH
                AgP3Sg Fem => fethu + "ha" ;  -- Huma FETĦUHA
                AgP1 Pl    => fethu + "na" ; -- Huma FETĦUNA
                AgP2 Pl    => fethu + "kom" ; -- Huma FETĦUKOM
                AgP3Pl     => fethu + "hom"  -- Huma FETĦUHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => fethu + "li" ; -- Huma FETĦULI
                AgP2 Sg    => fethu + "lek" ; -- Huma FETĦULEK
                AgP3Sg Masc=> fethu + "lu" ;  -- Huma FETĦULU
                AgP3Sg Fem => fethu + "lha" ;  -- Huma FETĦULHA
                AgP1 Pl    => fethu + "lna" ; -- Huma FETĦULNA
                AgP2 Pl    => fethu + "lkom" ; -- Huma FETĦULKOM
                AgP3Pl     => fethu + "lhom"  -- Huma FETĦULHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP3Pl) do fethu) ! agr
          }
        } ; -- end of verbPerfPronSuffixTable

-- ========================================================================

    -- Build table of pronominal suffixes
    -- Imperfective tense
    verbImpfPronSuffixTable : VerbInfo -> (Agr => Str) -> (Agr => VSuffixForm => Str) = \info,tbl ->
      let
        vowels : Pattern = extractPattern (tbl ! AgP1 Sg) ; --- we are using the P1 vowel changes for all persons
        p2sg_dir_ek : Str = case info.class of {
          Strong LiquidMedial => case vowels.V2 of {
            "o" => "ok" ; -- Jiena NOĦORĠ-OK
            _ => "ek" -- Jiena NIDILK-EK
            };                      
          Strong Geminated => "ok" ;  -- Jiena NXOMM-OK --- criteria probably wrong
          Weak Lacking => case vowels.V1 of {
            "a" => "ak" ;  -- Jiena NAQR-AK
            _ => "ik"  -- Jiena NIMX-IK
            } ;
          Quad QWeak => case info.imp of {
            _ + "a" => "ak" ; -- Huwa KANTAK
            _ => "ik" -- Huwa SERVIK
            } ;
          Loan => case info.imp of {
            _ + "ixxi" => "ik" ; -- Huwa SSUĠĠERIXXIK
            _ => "ak" -- Huwa ŻVILUPPAK
            } ;
          _ => "ek"  -- Jiena NIFTĦ-EK
          } ;
        p2sg_ind_lek : Str =  case info.class of {
          Strong LiquidMedial => case vowels.V2 of {
            "o" => "lok" ; -- Jiena NOĦROĠ-LOK
            _ => "lek" -- Jiena NIDLIK-LEK
            };                      
          Strong Geminated => "lok" ;  -- Jiena NXOMM-LOK
          _ => "lek"
          } ;
        p3sg_dir_u : Str = case info.imp of {
          _ + "a" => "ah" ; -- Huwa KANTAH
          _ + "i" => "ih" ; -- Huwa SERVIH
          _ => "u" -- Huwa FETĦU
          } ;

        -- This stem is prefixed with n/t/j/t/n/t/j
        iftah : Str = case (tbl ! AgP1 Sg) of {
          "nie"+qaf => "i"+qaf ; -- -IEQAF > -IQAF
          "n"+aqta+"'" => aqta+"għ" ; -- -AQTA' > -AQTAGĦ
 --         "n"+ik+t@#Consonant+"e"+b@#Consonant => ik+t+"i"+b ; -- -IKTEB > -IKTIB --- this is dangerous (and probably slow)
          "n"+iftah => iftah -- -IFTAĦ
          } ;
        ifth = case info.class of {
          Strong LiquidMedial => case info.root.C1 of {
            "għ" => vowels.V1 + info.root.C1 + info.root.C2 + info.root.C3 ; -- -AGĦML
            _ => vowels.V1 + info.root.C1 + vowels.V2 + info.root.C2 + info.root.C3 -- -OĦORĠ
            } ;
          Strong Geminated => iftah ; -- -ĦOBB
          Weak Assimilative => (ie2i vowels.V1) + info.root.C2 + info.root.C3 ; -- -ASL (WASAL)
          Weak Hollow => info.root.C1 + vowels.V1 + info.root.C3 ; -- -SIB
          Weak Lacking => vowels.V1 + info.root.C1 + info.root.C2 ; -- -IMX
          Quad QStrong => info.root.C1 + vowels.V1 + info.root.C2 + info.root.C3 + info.root.C4 ; -- -ĦARBT
          Quad QWeak => info.root.C1 + vowels.V1 + info.root.C2 + info.root.C3 ; -- -SERV, -KANT
          Loan => dropSfx 1 iftah ; -- -ŻVILUPP
          _ => vowels.V1 + info.root.C1 + info.root.C2 + info.root.C3
          } ;
      in
      table {
        AgP1 Sg => -- Jiena NIFTAĦ
          let
            niftah = pfx_N iftah ;
            nifth = pfx_N ifth ;
          in
          table {
            VSuffixNone => tbl ! AgP1 Sg ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => nifth + p2sg_dir_ek ; -- Jiena NIFTĦEK
                AgP3Sg Masc=> nifth + p3sg_dir_u ;  -- Jiena NIFTĦU
                AgP3Sg Fem => niftah + "ha" ;  -- Jiena NIFTAĦHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => sfx niftah "kom" ;  -- Jiena NIFTAĦKOM (n.b. NĦOKK+KOM)
                AgP3Pl     => niftah + "hom"  -- Jiena NIFTAĦHOM
              } ;
            VSuffixInd agr =>
              let
                nifthi = case <info.class, vowels.V1> of {
                  <Weak Defective, _> => nifth + "a" ; -- NAQTGĦA-
                  <Weak Lacking, "a"> => nifth + "a" ;  -- NAQRA-
                  <Quad QWeak, _> => tbl ! AgP1 Sg ; -- NKANTA-, NSERVI-
                  <Loan, _> => nifth + (takeSfx 1 niftah) ; -- NISSUĠĠERIXXI-, NIŻVILUPPA-
                  _ => nifth + "i" -- NIFTĦI-
                  } ;
              in
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => sfx niftah p2sg_ind_lek ;  -- Jiena NIFTAĦLEK (n.b. NĦOLL+LEK)
                AgP3Sg Masc=> sfx niftah "lu" ;  -- Jiena NIFTAĦLU (n.b. NĦOLL+LU)
                AgP3Sg Fem => nifthi + "lha" ;  -- Jiena NIFTĦILHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => nifthi + "lkom" ;  -- Jiena NIFTĦILKOM
                AgP3Pl     => nifthi + "lhom"  -- Jiena NIFTĦILHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP1 Sg) do niftah) ! agr
          } ;
        AgP2 Sg => -- Inti TIFTAĦ
          let
            tiftah = pfx_T iftah ;
            tifth = pfx_T ifth ;
          in
          table {
            VSuffixNone => tbl ! AgP2 Sg ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => sfx tiftah "ni" ; -- Inti TIFTAĦNI (n.b. TKENN+NI)
                AgP2 Sg    => [] ;
                AgP3Sg Masc=> tifth + p3sg_dir_u ;  -- Inti TIFTĦU
                AgP3Sg Fem => tiftah + "ha" ;  -- Inti TIFTAĦHA
                AgP1 Pl    => sfx tiftah "na" ; -- Inti TIFTAĦNA (n.b. TKENN+NA)
                AgP2 Pl    => [] ;
                AgP3Pl     => tiftah + "hom"  -- Inti TIFTAĦHOM
              } ;
            VSuffixInd agr =>
              let
                tifthi = case <info.class, vowels.V1> of {
                  <Weak Defective, _> => tifth + "a" ; -- TAQTGĦA-
                  <Weak Lacking, "a"> => tifth + "a" ;  -- TAQRA-
                  <Quad QWeak, _> => tbl ! AgP2 Sg ; -- TKANTA-, SSERVI-
                  <Loan, _> => tifth + (takeSfx 1 tiftah) ; -- TISSUĠĠERIXXI-, TIŻVILUPPA-
                  _ => tifth + "i" -- TIFTĦI-
                  } ;
              in
              case agr of {
                AgP1 Sg    => sfx tiftah "li" ; -- Inti TIFTAĦLI (n.b. TĦOLL+LI)
                AgP2 Sg    => [] ;
                AgP3Sg Masc=> sfx tiftah "lu" ;  -- Inti TIFTAĦLU (n.b. TĦOLL+LU)
                AgP3Sg Fem => tifthi + "lha" ;  -- Inti TIFTĦILHA
                AgP1 Pl    => tifthi + "lna" ; -- Inti TIFTĦILNA
                AgP2 Pl    => [] ;
                AgP3Pl     => tifthi + "lhom"  -- Inti TIFTĦILHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP2 Sg) do tiftah) ! agr
          } ;
        AgP3Sg Masc => -- Huwa JIFTAĦ
          let
            jiftah = pfx_J iftah ;
            jifth = pfx_J ifth ;
          in
          table {
            VSuffixNone => tbl ! AgP3Sg Masc ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => sfx jiftah "ni" ; -- Huwa JIFTAĦNI (n.b. JKENN+NI)
                AgP2 Sg    => jifth + p2sg_dir_ek ; -- Huwa JIFTĦEK
                AgP3Sg Masc=> jifth + p3sg_dir_u ;  -- Huwa JIFTĦU
                AgP3Sg Fem => jiftah + "ha" ;  -- Huwa JIFTAĦHA
                AgP1 Pl    => sfx jiftah "na" ; -- Huwa JIFTAĦNA (n.b. JKENN+NA)
                AgP2 Pl    => sfx jiftah "kom" ; -- Huwa JIFTAĦKOM (n.b. JĦOKK+KOM)
                AgP3Pl     => jiftah + "hom"  -- Huwa JIFTAĦHOM
              } ;
            VSuffixInd agr =>
              let
                jifthi = case <info.class, vowels.V1> of {
                  <Weak Defective, _> => jifth + "a" ; -- JAQTGĦA-
                  <Weak Lacking, "a"> => jifth + "a" ;  -- JAQRA-
                  <Quad QWeak, _> => tbl ! AgP3Sg Masc ; -- JKANTA-, JSERVI-
                  <Loan, _> => jifth + (takeSfx 1 jiftah) ; -- JISSUĠĠERIXXI-, JIŻVILUPPA-
                  _ => jifth + "i" -- JIFTĦI-
                  } ;
              in
              case agr of {
                AgP1 Sg    => sfx jiftah "li" ; -- Huwa JIFTAĦLI (n.b. JĦOLL+LI)
                AgP2 Sg    => sfx jiftah p2sg_ind_lek ; -- Huwa JIFTAĦLEK (n.b. JĦOLL+LEK)
                AgP3Sg Masc=> sfx jiftah "lu" ;  -- Huwa JIFTAĦLU (n.b. JĦOLL+LU)
                AgP3Sg Fem => jifthi + "lha" ;  -- Huwa JIFTĦILHA
                AgP1 Pl    => jifthi + "lna" ; -- Huwa JIFTĦILNA
                AgP2 Pl    => jifthi + "lkom" ; -- Huwa JIFTĦILKOM
                AgP3Pl     => jifthi + "lhom"  -- Huwa JIFTĦILHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP3Sg Masc) do jiftah) ! agr
          } ;
        AgP3Sg Fem => -- Hija TIFTAĦ
          let
            tiftah = pfx_T iftah ;
            tifth = pfx_T ifth ;
          in
          table {
            VSuffixNone => tbl ! AgP3Sg Fem ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => sfx tiftah "ni" ; -- Hija TIFTAĦNI (n.b. TKENN+NI)
                AgP2 Sg    => tifth + p2sg_dir_ek ; -- Hija TIFTĦEK
                AgP3Sg Masc=> tifth + p3sg_dir_u ;  -- Hija TIFTĦU
                AgP3Sg Fem => tiftah + "ha" ;  -- Hija TIFTAĦHA
                AgP1 Pl    => sfx tiftah "na" ; -- Hija TIFTAĦNA (n.b. TKENN+NA)
                AgP2 Pl    => sfx tiftah "kom" ; -- Hija TIFTAĦKOM (n.b. TĦOKK+KOM)
                AgP3Pl     => tiftah + "hom"  -- Hija TIFTAĦHOM
              } ;
            VSuffixInd agr =>
              let
                tifthi = case <info.class, vowels.V1> of {
                  <Weak Defective, _> => tifth + "a" ; -- TAQTGĦA-
                  <Weak Lacking, "a"> => tifth + "a" ;  -- TAQRA-
                  <Quad QWeak, _> => tbl ! AgP3Sg Fem ; -- TKANTA-, SSERVI-
                  <Loan, _> => tifth + (takeSfx 1 tiftah) ; -- TISSUĠĠERIXXI-, TIŻVILUPPA-
                  _ => tifth + "i" -- TIFTĦI-
                  } ;
              in
              case agr of {
                AgP1 Sg    => sfx tiftah "li" ; -- Hija TIFTAĦLI (n.b. TĦOLL+LI)
                AgP2 Sg    => sfx tiftah p2sg_ind_lek ; -- Hija TIFTAĦLEK (n.b. TĦOLL+LEK)
                AgP3Sg Masc=> sfx tiftah "lu" ;  -- Hija TIFTAĦLU (n.b. TĦOLL+LU)
                AgP3Sg Fem => tifthi + "lha" ;  -- Hija TIFTĦILHA
                AgP1 Pl    => tifthi + "lna" ; -- Hija TIFTĦILNA
                AgP2 Pl    => tifthi + "lkom" ; -- Hija TIFTĦILKOM
                AgP3Pl     => tifthi + "lhom"  -- Hija TIFTĦILHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP3Sg Fem) do tiftah) ! agr
          } ;
        AgP1 Pl => -- Aħna NIFTĦU
          let
            nifthu = ie2i (tbl ! AgP1 Pl) ;
          in
          table {
            VSuffixNone => tbl ! AgP1 Pl ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => nifthu + "k" ;  -- Aħna NIFTĦUK
                AgP3Sg Masc=> nifthu + "h" ;  -- Aħna NIFTĦUH
                AgP3Sg Fem => nifthu + "ha" ;  -- Aħna NIFTĦUHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => nifthu + "kom" ;  -- Aħna NIFTĦUKOM
                AgP3Pl     => nifthu + "hom"  -- Aħna NIFTĦUHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => [] ;
                AgP2 Sg    => nifthu + "lek" ;  -- Aħna NIFTĦULEK
                AgP3Sg Masc=> nifthu + "lu" ;  -- Aħna NIFTĦULU
                AgP3Sg Fem => nifthu + "lha" ;  -- Aħna NIFTĦULHA
                AgP1 Pl    => [] ;
                AgP2 Pl    => nifthu + "lkom" ;  -- Aħna NIFTĦULKOM
                AgP3Pl     => nifthu + "lhom"  -- Aħna NIFTĦULHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP1 Pl) do nifthu) ! agr
          } ;
        AgP2 Pl => -- Intom TIFTĦU
          let
            tifthu = ie2i (tbl ! AgP2 Pl) ;
          in
          table {
            VSuffixNone => tbl ! AgP2 Pl ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => tifthu + "ni" ; -- Intom TIFTĦUNI
                AgP2 Sg    => [] ;
                AgP3Sg Masc=> tifthu + "h" ;  -- Intom TIFTĦUH
                AgP3Sg Fem => tifthu + "ha" ;  -- Intom TIFTĦUHA
                AgP1 Pl    => tifthu + "na" ; -- Intom TIFTĦUNA
                AgP2 Pl    => [] ;
                AgP3Pl     => tifthu + "hom"  -- Intom TIFTĦUHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => tifthu + "li" ; -- Intom TIFTĦULI
                AgP2 Sg    => [] ;
                AgP3Sg Masc=> tifthu + "lu" ;  -- Intom TIFTĦULU
                AgP3Sg Fem => tifthu + "lha" ;  -- Intom TIFTĦULHA
                AgP1 Pl    => tifthu + "lna" ; -- Intom TIFTĦULNA
                AgP2 Pl    => [] ;
                AgP3Pl     => tifthu + "lhom"  -- Intom TIFTĦULHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP2 Pl) do tifthu) ! agr
          } ;
        AgP3Pl => -- Huma JIFTĦU
          let
            jifthu = ie2i (tbl ! AgP3Pl) ;
          in
          table {
            VSuffixNone => tbl ! AgP3Pl ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => jifthu + "ni" ; -- Huma JIFTĦUNI
                AgP2 Sg    => jifthu + "k" ; -- Huma JIFTĦUK
                AgP3Sg Masc=> jifthu + "h" ;  -- Huma JIFTĦUH
                AgP3Sg Fem => jifthu + "ha" ;  -- Huma JIFTĦUHA
                AgP1 Pl    => jifthu + "na" ; -- Huma JIFTĦUNA
                AgP2 Pl    => jifthu + "kom" ; -- Huma JIFTĦUKOM
                AgP3Pl     => jifthu + "hom"  -- Huma JIFTĦUHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => jifthu + "li" ; -- Huma JIFTĦULI
                AgP2 Sg    => jifthu + "lek" ; -- Huma JIFTĦULEK
                AgP3Sg Masc=> jifthu + "lu" ;  -- Huma JIFTĦULU
                AgP3Sg Fem => jifthu + "lha" ;  -- Huma JIFTĦULHA
                AgP1 Pl    => jifthu + "lna" ; -- Huma JIFTĦULNA
                AgP2 Pl    => jifthu + "lkom" ; -- Huma JIFTĦULKOM
                AgP3Pl     => jifthu + "lhom"  -- Huma JIFTĦULHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP3Pl) do jifthu) ! agr
          }
        } ; -- end of verbImpfPronSuffixTable

-- ========================================================================

    verbImpPronSuffixTable : VerbInfo -> (Number => Str) -> (Number => VSuffixForm => Str) = \info,tbl ->
      table {
        Sg => -- Inti IFTAĦ
          let
            vowels = extractPattern (tbl ! Sg) ;
            iftah : Str = case (tbl ! Sg) of {
              "ie"+qaf=> "i"+qaf ; -- IEQAF > IQAF
              aqta+"'" => aqta+"għ" ; -- AQTA' > AQTAGĦ
              ik+t@#Consonant+"e"+b@#Consonant => ik+t+"i"+b ; -- IKTEB > IKTIB
              x => x -- IFTAĦ
              } ;
            ifth = case info.class of {
              Strong LiquidMedial => case info.root.C1 of {
                "għ" => vowels.V1 + info.root.C1 + info.root.C2 + info.root.C3 ; -- AGĦML
                _ => vowels.V1 + info.root.C1 + vowels.V2 + info.root.C2 + info.root.C3 -- OĦORĠ
                } ;
              Strong Geminated => iftah ; -- ĦOBB
              Weak Assimilative => (ie2i vowels.V1) + info.root.C2 + info.root.C3 ; -- -ASL (WASAL)
              Weak Hollow => info.root.C1 + vowels.V1 + info.root.C3 ; -- -SIB
              Weak Lacking => vowels.V1 + info.root.C1 + info.root.C2 ; -- -IMX
              Quad QStrong => info.root.C1 + vowels.V1 + info.root.C2 + info.root.C3 + info.root.C4 ; -- -ĦARBT
              Quad QWeak => info.root.C1 + vowels.V1 + info.root.C2 + info.root.C3 ; -- -SERV, -KANT
              Loan => dropSfx 1 iftah ; -- ŻVILUPP
              _ => takePfx 1 iftah + info.root.C1 + info.root.C2 + info.root.C3 -- IFTĦ
              } ;
            p3sg_dir_u : Str = case info.imp of {
              _ + "a" => "ah" ; -- KANTAH
              _ + "i" => "ih" ; -- SERVIH
              _ => "u" -- IFTĦU
              } ;

          in
          table {
            VSuffixNone => (tbl ! Sg) ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => sfx iftah "ni" ; -- Inti IFTAĦNI (n.b. KENN+NI)
                AgP2 Sg    => [] ;
                AgP3Sg Masc=> ifth + p3sg_dir_u ;  -- Inti IFTĦU
                AgP3Sg Fem => iftah + "ha" ;  -- Inti IFTAĦHA
                AgP1 Pl    => sfx iftah "na" ; -- Inti IFTAĦNA (n.b. KENN+NA)
                AgP2 Pl    => [] ;
                AgP3Pl     => iftah + "hom"  -- Inti IFTAĦHOM
              } ;
            VSuffixInd agr =>
              let
                ifthi = case info.class of {
                  Strong LiquidMedial => case info.root.C1 of {
                    "għ" => ifth + "i" ; -- AGĦMLI-
                    _ => (tbl!Sg) + "i" -- OĦROĠI-
                    } ;
                  Weak Defective => ifth + "a" ; -- AQTGĦA-
                  Weak Lacking => case vowels.V1 of {
                    "a" => ifth + "a" ;  -- AQRA-
                    _ => ifth + "i" -- IMXI-
                    } ;
                  Quad QStrong => info.root.C1 + vowels.V1 + info.root.C2 + info.root.C3 + info.root.C4 + "i" ; -- -ĦARBTI
                  Quad QWeak => tbl ! Sg ; -- KANTA-, SERVI-
                  Loan => tbl ! Sg ; -- ŻVILUPPA-
                  _ => ifth + "i" -- IFTĦI-
                  } ;
              in
              case agr of {
                AgP1 Sg    => sfx iftah "li" ; -- Inti IFTAĦLI (n.b. ĦOLL+LI)
                AgP2 Sg    => [] ;
                AgP3Sg Masc=> sfx iftah "lu" ;  -- Inti IFTAĦLU (n.b. ĦOLL+LU)
                AgP3Sg Fem => ifthi + "lha" ;  -- Inti IFTĦILHA
                AgP1 Pl    => ifthi + "lna" ; -- Inti IFTĦILNA
                AgP2 Pl    => [] ;
                AgP3Pl     => ifthi + "lhom"  -- Inti IFTĦILHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP2 Sg) do iftah) ! agr
          } ;
        Pl => -- Intom IFTĦU
          let
            ifthu = ie2i (tbl ! Pl) ;
          in
          table {
            VSuffixNone => tbl ! Pl ;
            VSuffixDir agr =>
              case agr of {
                AgP1 Sg    => ifthu + "ni" ; -- Inti IFTĦUNI
                AgP2 Sg    => [] ;
                AgP3Sg Masc=> ifthu + "h" ;  -- Inti IFTĦUH
                AgP3Sg Fem => ifthu + "ha" ;  -- Inti IFTĦUHA
                AgP1 Pl    => ifthu + "na" ; -- Inti IFTĦUNA
                AgP2 Pl    => [] ;
                AgP3Pl     => ifthu + "hom"  -- Inti IFTĦUHOM
              } ;
            VSuffixInd agr =>
              case agr of {
                AgP1 Sg    => ifthu + "li" ; -- Inti IFTĦULI
                AgP2 Sg    => [] ;
                AgP3Sg Masc=> ifthu + "lu" ;  -- Inti IFTĦULU
                AgP3Sg Fem => ifthu + "lha" ;  -- Inti IFTĦULHA
                AgP1 Pl    => ifthu + "lna" ; -- Inti IFTĦULNA
                AgP2 Pl    => [] ;
                AgP3Pl     => ifthu + "lhom"  -- Inti IFTĦULHOM
              } ;
            VSuffixDirInd do agr => (verbDirIndSuffixTable (AgP2 Pl) do ifthu) ! agr
          }
      } ;


    {- ~~~ General use verb operations ~~~ -}

    verbDirIndSuffixTable : Agr -> GenNum -> Str -> (Agr => Str) = \subj,do,ftaht ->
      case do of {
        GSg Masc => table {
                AgP1 Sg    => case subj of {
                  AgP1 _     => [] ;
                  _          => ftaht + "huli"
                  } ;
                AgP2 Sg    => case subj of {
                  AgP2 _     => [] ;
                  _          => ftaht + "hulek"
                  } ;
                AgP3Sg Masc=> ftaht + "hulu" ;
                AgP3Sg Fem => ftaht + "hulha" ;
                AgP1 Pl    => case subj of {
                  AgP1 _     => [] ;
                  _          => ftaht + "hulna"
                  } ;
                AgP2 Pl    => case subj of {
                  AgP2 _     => [] ;
                  _          => ftaht + "hulkom"
                  } ;
                AgP3Pl     => ftaht + "hulhom"  -- Jiena FTAĦTHULHOM
              } ;
        GSg Fem => table {
                AgP1 Sg    => case subj of {
                  AgP1 _     => [] ;
                  _          => ftaht + "hieli"
                  } ;
                AgP2 Sg    => case subj of {
                  AgP2 _     => [] ;
                  _          => ftaht + "hielek"
                  } ;
                AgP3Sg Masc=> ftaht + "hielu" ;  -- Jiena FTAĦTHIELU
                AgP3Sg Fem => ftaht + "hielha" ;  -- Jiena FTAĦTHIELHA
                AgP1 Pl    => case subj of {
                  AgP1 _     => [] ;
                  _          => ftaht + "hielna"
                  } ;
                AgP2 Pl    => case subj of {
                  AgP2 _     => [] ;
                  _          => ftaht + "hielkom"
                  } ;
                AgP3Pl     => ftaht + "hielhom"  -- Jiena FTAĦTHIELHOM
              } ;
        GPl => table {
                AgP1 Sg    => case subj of {
                  AgP1 _     => [] ;
                  _          => ftaht + "homli"
                  } ;
                AgP2 Sg    => case subj of {
                  AgP2 _     => [] ;
                  _          => ftaht + "homlok"
                  } ;
                AgP3Sg Masc=> ftaht + "homlu" ;  -- Jiena FTAĦTHOMLU
                AgP3Sg Fem => ftaht + "homlha" ;  -- Jiena FTAĦTOMHLA
                AgP1 Pl    => case subj of {
                  AgP1 _     => [] ;
                  _          => ftaht + "homlna"
                  } ;
                AgP2 Pl    => case subj of {
                  AgP2 _     => [] ;
                  _          => ftaht + "homlkom"
                  } ;
                AgP3Pl     => ftaht + "homlhom"  -- Jiena FTAĦTHOMLHOM
              }
      } ;
      

    -- Conjugate imperfect tense from imperative by adding initial letters
    -- Ninu, Toninu, Jaħasra, Toninu; Ninu, Toninu, Jaħasra
    conjGenericImpf : Str -> Str -> (Agr => Str) = \imp_sg,imp_pl ->
      table {
        AgP1 Sg    => pfx_N imp_sg ;  -- Jiena NIŻLOQ
        AgP2 Sg    => pfx_T imp_sg ;  -- Inti TIŻLOQ
        AgP3Sg Masc=> pfx_J imp_sg ;  -- Huwa JIŻLOQ
        AgP3Sg Fem => pfx_T imp_sg ;  -- Hija TIŻLOQ
        AgP1 Pl    => pfx_N imp_pl ;  -- Aħna NIŻOLQU
        AgP2 Pl    => pfx_T imp_pl ;  -- Intom TIŻOLQU
        AgP3Pl     => pfx_J imp_pl    -- Huma JIŻOLQU
      } ;

    -- -- Derive imperative plural from singular
    -- impPlFromSg : Root -> Pattern -> Str -> VClass -> Str = \root,patt,imp_sg,class ->
    --   case class of {
    --     Strong Regular      => (takePfx 3 imp_sg) + root.C3 + "u" ; -- IFTAĦ > IFTĦU
    --     Strong LiquidMedial => (takePfx 2 imp_sg) + (charAt 3 imp_sg) + root.C2 + root.C3 + "u" ; -- OĦROĠ > OĦORĠU
    --     Strong Geminated=> imp_sg + "u" ; -- ŻOMM > ŻOMMU
    --     Weak Assimilative   => (takePfx 2 imp_sg) + root.C3 + "u" ; -- ASAL > ASLU
    --     Weak Hollow         => imp_sg + "u" ; -- SIR > SIRU
    --     Weak Lacking      => (takePfx 3 imp_sg) + "u" ; -- IMXI > IMXU
    --     Weak Defective      => (takePfx 2 imp_sg) + "i" + root.C2 + "għu" ; -- ISMA' > ISIMGĦU
    --     Quad QStrong         => (takePfx 4 imp_sg) + root.C4 + "u" ; -- ĦARBAT > ĦARBTU
    --     Quad QWeak _ARE  => imp_sg + "w" ; -- KANTA > KANTAW
    --     Quad QWeak _ => (dropSfx 1 imp_sg) + "u" ; -- SERVI > SERVU
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
          AgP3Sg Masc=> root.C1 + p.V1 + root.C2 + p.V2 + root.C3 ;  -- Huwa KITEB
          AgP3Sg Fem => kitb + (case p.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija KITBET
          AgP1 Pl    => ktib + "na" ;  -- Aħna KTIBNA
          AgP2 Pl    => ktib + "tu" ;  -- Intom KTIBTU
          AgP3Pl     => kitb + "u"  -- Huma KITBU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
    conjStrongImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjStrongImp : Root -> Pattern -> (Number => Str) = \root,patt ->
      let
        vwls = vowelChangesStrong patt ;
      in
        table {
          Sg => (vwls!Sg).V1 + root.C1 + root.C2 + (vwls!Sg).V2 + root.C3 ;  -- Inti:  IKTEB
          Pl => (vwls!Pl).V1 + root.C1 + root.C2 + root.C3 + "u"  -- Intom: IKTBU
        } ;

    -- Vowel changes for imperative
    vowelChangesStrong : Pattern -> (Number => Pattern) = \patt ->
      table {
        Sg => case (patt.V1 + patt.V2) of {
          "aa" => mkPattern "o" "o" ; -- RABAT > ORBOT (but: ITLOB, ILGĦAB, AĦBAT)
          "ae" => mkPattern "a" "e" ; -- GĦAMEL > AGĦMEL
          "ee" => mkPattern "i" "e" ; -- FEHEM > IFHEM
          "ea" => mkPattern "i" "a" ; -- FETAĦ > IFTAĦ
          "ie" => mkPattern "i" "e" ; -- KITEB > IKTEB
          "oo" => mkPattern "o" "o"   -- GĦOĠOB > OGĦĠOB
        };
        Pl => case (patt.V1 + patt.V2) of {
          "aa" => mkPattern "o" ; -- RABAT > ORBTU
          "ae" => mkPattern "a" ; -- GĦAMEL > AGĦMLU
          "ee" => mkPattern "i" ; -- FEHEM > IFHMU
          "ea" => mkPattern "i" ; -- FETAĦ > IFTĦU
          "ie" => mkPattern "i" ; -- KITEB > IKTBU
          "oo" => mkPattern "o"   -- GĦOĠOB > OGĦĠBU
        }
      } ;

    {- ~~~ Liquid-Medial Verb ~~~ -}

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjLiquidMedialPerf : Root -> Pattern -> (Agr => Str) = \root,patt ->
      let
        zlaq : Str = case root.C1 of {
          "għ" => root.C1 + patt.V1 + root.C2 + (case patt.V2 of {"e" => "i" ; _ => patt.V2 }) + root.C3 ; -- GĦAMIL-
          _ => root.C1 + root.C2 + (case patt.V2 of {"e" => "i" ; _ => patt.V2 }) + root.C3 -- ŻLAQ-
          } ;
        zelq = root.C1 + patt.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => zlaq + "t" ;  -- Jiena ŻLAQT
          AgP2 Sg    => zlaq + "t" ;  -- Inti ŻLAQT
          AgP3Sg Masc=> root.C1 + patt.V1 + root.C2 + patt.V2 + root.C3 ;  -- Huwa ŻELAQ
          AgP3Sg Fem => zelq + (case patt.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija ŻELQET
          AgP1 Pl    => zlaq + "na" ;  -- Aħna ŻLAQNA
          AgP2 Pl    => zlaq + "tu" ;  -- Intom ŻLAQTU
          AgP3Pl     => zelq + "u"  -- Huma ŻELQU
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IŻLOQ), Imperative Plural (eg IŻOLQU)
    conjLiquidMedialImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjLiquidMedialImp : Root -> Pattern -> (Number => Str) = \root,patt ->
      let
        vwls = vowelChangesLiquidMedial patt ;
      in
        table {
          Sg => (vwls!Sg).V1 + root.C1 + root.C2 + (vwls!Sg).V2 + root.C3 ;  -- Inti: IŻLOQ
          Pl => (vwls!Pl).V1 + root.C1 + (vwls!Pl).V2 + root.C2 + root.C3 + "u"  -- Intom: IŻOLQU
        } ;

    -- Vowel changes for imperative
    vowelChangesLiquidMedial : Pattern -> (Number => Pattern) = \patt ->
      table {
        Sg => case (patt.V1 + patt.V2) of {
          "aa" => mkPattern "i" "o" ; -- TALAB > ITLOB
          "ae" => mkPattern "o" "o" ; -- ĦAREĠ > OĦROĠ
          "ee" => mkPattern "e" "e" ; -- ĦELES > EĦLES
          "ea" => mkPattern "i" "o" ; -- ŻELAQ > IŻLOQ
          "ie" => mkPattern "i" "e" ; -- DILEK > IDLEK
          "oo" => mkPattern "i" "o"   -- XOROB > IXROB
        };
        Pl => case (patt.V1 + patt.V2) of {
          "aa" => mkPattern "i" "o" ; -- TALAB > ITOLBU
          "ae" => mkPattern "o" "o" ; -- ĦAREĠ > OĦORĠU
          "ee" => mkPattern "e" "i" ; -- ĦELES > EĦILSU
          "ea" => mkPattern "i" "o" ; -- ŻELAQ > IŻOLQU
          "ie" => mkPattern "i" "i" ; -- DILEK > IDILKU
          "oo" => mkPattern "i" "o"   -- XOROB > IXORBU
        }
      } ;

    {- ~~~ Geminated Verb ~~~ -}

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjGeminatedPerf : Root -> Pattern -> (Agr => Str) = \root,patt ->
      let
        habb = root.C1 + patt.V1 + root.C2 + root.C3 ;
      in
        table {
          AgP1 Sg    => habb + "ejt" ;  -- Jiena ĦABBEJT
          AgP2 Sg    => habb + "ejt" ;  -- Inti ĦABBEJT
          AgP3Sg Masc=> habb ;  -- Huwa ĦABB
          AgP3Sg Fem => habb + "et" ;  -- Hija ĦABBET
          AgP1 Pl    => habb + "ejna" ;  -- Aħna ĦABBEJNA
          AgP2 Pl    => habb + "ejtu" ;  -- Intom ĦABBEJTU
          AgP3Pl     => habb + "ew"  -- Huma ĦABBU/ĦABBEW
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
    conjGeminatedImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjGeminatedImp : Root -> Pattern -> (Number => Str) = \root,patt ->
      let
        vwls = vowelChangesGeminated patt ;
        stem_sg = root.C1 + (vwls!Sg).V1 + root.C2 + root.C3 ;
      in
        table {
          Sg => stem_sg ;  -- Inti: ĦOBB
          Pl => stem_sg + "u"  -- Intom: ĦOBBU
        } ;

    -- Vowel changes for imperative
    vowelChangesGeminated : Pattern -> (Number => Pattern) = \patt ->
      \\n => case patt.V1 of {
        "e" => mkPattern "e" ; -- BEXX > BEXX (?)
        _ => mkPattern "o" -- ĦABB > ĦOBB
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
          AgP3Sg Masc=> wasal ;  -- Huwa WASAL
          AgP3Sg Fem => wasl + "et" ;  -- Hija WASLET
          AgP1 Pl    => wasal + "na" ;  -- Aħna WASALNA
          AgP2 Pl    => wasal + "tu" ;  -- Intom WASALTU
          AgP3Pl     => wasl + "u"  -- Huma WASLU
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
        AgP3Sg Masc=> sar ;  -- Huwa SAR
        AgP3Sg Fem => sar + "et" ;  -- Hija SARET
        AgP1 Pl    => sir + "na" ;  -- Aħna SIRNA
        AgP2 Pl    => sir + "tu" ;  -- Intom SIRTU
        AgP3Pl     => sar + "u"  -- Huma SARU
      } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg DUM), Imperative Plural (eg DUMU)
    conjHollowImpf : Str -> Str -> (Agr => Str) = \imp_sg,imp_pl ->
      table {
          AgP1 Sg    => pfx_N imp_sg ;  -- Jiena NDUM / MMUR
          AgP2 Sg    => pfx_T imp_sg ;  -- Inti DDUM / TMUR
          AgP3Sg Masc=> pfx_J imp_sg ;  -- Huwa JDUM / JMUR
          AgP3Sg Fem => pfx_T imp_sg ;  -- Hija DDUM / TMUR
          AgP1 Pl    => pfx_N imp_pl ;  -- Aħna NDUMU / MMORRU
          AgP2 Pl    => pfx_T imp_pl ;  -- Intom DDUMU / TMORRU
          AgP3Pl     => pfx_J imp_pl    -- Huma JDUMU / JMORRU
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

    {- ~~~ Lacking Verb ~~~ -}

    -- Conjugate entire verb in PERFECT tense
    -- Params: Root, Pattern
    conjLackingPerf : Root -> Pattern -> (Agr => Str) = \root,patt ->
      let
        mxej = root.C1 + root.C2 + patt.V1 + root.C3
      in
        table {
          --- i tal-leħen needs to be added here!
          AgP1 Sg    => mxej + "t" ;  -- Jiena IMXEJT
          AgP2 Sg    => mxej + "t" ;  -- Inti IMXEJT
          AgP3Sg Masc=> root.C1 + patt.V1 + root.C2 + patt.V2 ;  -- Huwa MEXA
          AgP3Sg Fem => case patt.V1 of {
            "a" => root.C1 + root.C2 + "at" ;  -- Hija QRAT
            _ => root.C1 + root.C2 + "iet"  -- Hija MXIET
            } ;
          AgP1 Pl    => mxej + "na" ;  -- Aħna IMXEJNA
          AgP2 Pl    => mxej + "tu" ;  -- Intom IMXEJTU
          AgP3Pl     => case patt.V1 of {
            "a" => root.C1 + root.C2 + "aw" ;  -- Huma QRAW
            _ => root.C1 + root.C2 + "ew"  -- Huma IMXEW
            }
        } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg IMXI), Imperative Plural (eg IMXU)
    conjLackingImpf = conjGenericImpf ;

    -- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
    -- Params: Root, Pattern
    conjLackingImp : Root -> Pattern -> (Number => Str) = \root,patt ->
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
          AgP3Sg Masc=> root.C1 + patt.V1 + root.C2 + patt.V2 + "'" ;  -- Huwa QALA'
          AgP3Sg Fem => qalgh + (case patt.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija QALGĦET
          AgP1 Pl    => qlaj + "na" ;  -- Aħna QLAJNA
          AgP2 Pl    => qlaj + "tu" ;  -- Intom QLAJTU
          AgP3Pl     => qalgh + "u"  -- Huma QALGĦU
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
        AgP3Sg Masc=> root.C1 + patt.V1 + root.C2 + root.C3 + patt.V2 + root.C4 ;  -- Huwa DENDIL
        AgP3Sg Fem => dendl + (case patt.V2 of {"o" => "o" ; _ => "e"}) + "t" ;  -- Hija DENDLET
        AgP1 Pl    => dendil + "na" ;  -- Aħna DENDILNA
        AgP2 Pl    => dendil + "tu" ;  -- Intom DENDILTU
        AgP3Pl     => dendl + "u"  -- Huma DENDLU
      } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg DENDEL), Imperative Plural (eg DENDLU)
    conjQuadImpf : Str -> Str -> (Agr => Str) = \imp_sg,imp_pl ->
      table {
        AgP1 Sg    => pfx_N imp_sg ;  -- Jiena NDENDEL
        AgP2 Sg    => pfx_T imp_sg ;  -- Inti DDENDEL
        AgP3Sg Masc=> pfx_J imp_sg ;  -- Huwa JDENDEL
        AgP3Sg Fem => pfx_T imp_sg ;  -- Hija DDENDEL
        AgP1 Pl    => pfx_N imp_pl ;  -- Aħna NDENDLU
        AgP2 Pl    => pfx_T imp_pl ;  -- Intom DDENDLU
        AgP3Pl     => pfx_J imp_pl    -- Huma JDENDLU
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
            AgP3Sg Masc=> kanta ;  -- Huwa KANTA
            AgP3Sg Fem => kanta + "t" ; -- Hija KANTAT
            AgP1 Pl    => kanta + "jna" ;  -- Aħna KANTAJNA
            AgP2 Pl    => kanta + "jtu" ;  -- Intom KANTAJTU
            AgP3Pl     => kanta + "w"  -- Huma KANTAW
          } ;
        _ => -- SERVI
          let
            serve = root.C1 + patt.V1 + root.C2 + root.C3 + "e" ;
          in
          table {
            AgP1 Sg    => serve + "jt" ;  -- Jiena SERVEJT
            AgP2 Sg    => serve + "jt" ;  -- Inti SERVEJT
            AgP3Sg Masc=> root.C1 + patt.V1 + root.C2 + root.C3 + patt.V2 ;  -- Huwa SERVA
            AgP3Sg Fem => root.C1 + patt.V1 + root.C2 + root.C3 + "iet" ; -- Hija SERVIET
            AgP1 Pl    => serve + "jna" ;  -- Aħna SERVEJNA
            AgP2 Pl    => serve + "jtu" ;  -- Intom SERVEJTU
            AgP3Pl     => serve + "w"  -- Huma SERVEW
          }
      } ;

    -- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
    -- Params: Imperative Singular (eg SERVI), Imperative Plural (eg SERVU)
    conjQuadWeakImpf : Str -> Str -> (Agr => Str) = \imp_sg,imp_pl ->
      table {
        AgP1 Sg    => pfx_N imp_sg ;  -- Jiena NSERVI
        AgP2 Sg    => pfx_T imp_sg ;  -- Inti SSERVI
        AgP3Sg Masc=> pfx_J imp_sg ;  -- Huwa JSERVI
        AgP3Sg Fem => pfx_T imp_sg ;  -- Hija SSERVI
        AgP1 Pl    => pfx_N imp_pl ;  -- Aħna NSERVU
        AgP2 Pl    => pfx_T imp_pl ;  -- Intom SSERVU
        AgP3Pl     => pfx_J imp_pl    -- Huma JSERVU
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
          AgP3Sg Masc=> mamma ; -- Huwa ISSUĠĠERIXXA
          AgP3Sg Fem => issugger + "iet" ;  -- Hija ISSUĠĠERIET
          AgP1 Pl    => issugger + "ejna" ;  -- Aħna ISSUĠĠEREJNA
          AgP2 Pl    => issugger + "ejtu" ;  -- Intom ISSUĠĠEREJTU
          AgP3Pl     => issugger + "ew"  -- Huma ISSUĠĠEREW
          } ;
        _ =>
          let
            ipparkja = mamma ;
          in
          table {
          AgP1 Sg    => ipparkja + "jt" ;  -- Jiena IPPARKJAJT
          AgP2 Sg    => ipparkja + "jt" ;  -- Inti IPPARKJAJT
          AgP3Sg Masc=> ipparkja ; -- Huwa IPPARKJA
          AgP3Sg Fem => ipparkja + "t" ;  -- Hija IPPARKJAT
          AgP1 Pl    => ipparkja + "jna" ;  -- Aħna IPPARKJAJNA
          AgP2 Pl    => ipparkja + "jtu" ;  -- Intom IPPARKJAJTU
          AgP3Pl     => ipparkja + "w"  -- Huma IPPARKJAW
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
        AgP1 Sg    => "n" + euphonicVowel + imp_sg ;  -- Jiena NIPPARKJA
        AgP2 Sg    => "t" + euphonicVowel + imp_sg ;  -- Inti TIPPARKJA
        AgP3Sg Masc=> "j" + euphonicVowel + imp_sg ;  -- Huwa JIPPARKJA
        AgP3Sg Fem => "t" + euphonicVowel + imp_sg ;  -- Hija TIPPARKJA
        AgP1 Pl    => "n" + euphonicVowel + imp_pl ;  -- Aħna NIPPARKJAW
        AgP2 Pl    => "t" + euphonicVowel + imp_pl ;  -- Intom TIPPARKJAW
        AgP3Pl     => "j" + euphonicVowel + imp_pl    -- Huma JIPPARKJAW
      } ;

    -- Conjugate entire verb in IMPERATIVE tense
    -- Params: Root, Pattern
    conjLoanImp : Str -> (Number => Str) = \mamma ->
      table {
        Sg => case mamma of {
          _ + "ixxa" => (dropSfx 1 mamma) + "i" ; -- STABILIXXA > STABILIXXI
          _ => mamma -- IPPARKJA > IPPARKJA
          } ;
        Pl => case mamma of {
          _ + "ixxa" => (dropSfx 1 mamma) + "u" ; -- STABILIXXA > STABILIXXU
          _ => mamma + "w" -- IPPARKJA > IPPARKJAW
          }
      } ;

    {- ~~~ Form II verbs ~~~ -}

    conjFormII : VerbInfo -> (VForm => VSuffixForm => Polarity => Str) = \i ->
      let
        waqqaf : Str = i.root.C1 + i.patt.V1 + i.root.C2 + i.root.C2 + i.patt.V2 + i.root.C3 ;
        waqqf : Str = i.root.C1 + i.patt.V1 + i.root.C2 + i.root.C2 + i.root.C3 ;
        waqqfu : Str = i.root.C1 + i.patt.V1 + i.root.C2 + i.root.C2 + i.root.C3 + "u" ;
        perf : Agr => Str = table {
          AgP1 Sg => waqqaf + "t" ;
          AgP2 Sg => waqqaf + "t" ;
          AgP3Sg Masc => waqqaf ;
          AgP3Sg Fem => waqqf + "et" ;
          AgP1 Pl => waqqaf + "na" ;
          AgP2 Pl => waqqaf + "tu" ;
          AgP3Pl => waqqfu
          } ;
        impf : Agr => Str = table {
          AgP1 Sg => pfx_N waqqaf ;
          AgP2 Sg => pfx_T waqqaf ;
          AgP3Sg Masc => pfx_J waqqaf ;
          AgP3Sg Fem => pfx_T waqqaf ;
          AgP1 Pl => pfx_N waqqfu ;
          AgP2 Pl => pfx_T waqqfu ;
          AgP3Pl => pfx_J waqqfu
          } ;
        imp : Number => Str = table {
          Sg => waqqaf ;
          Pl => waqqfu
          } ;
        tbl : VForm => Str = table {
          VPerf agr => perf ! agr ;
          VImpf agr => impf ! agr ;
          VImp num  => imp ! num
          } ;
        info : VerbInfo = mkVerbInfo i.class FormII i.root i.patt waqqaf ;
        sfxTbl : (VForm => VSuffixForm => Str) = verbPronSuffixTable info tbl ;
--        polSfxTbl : (VForm => VSuffixForm => Polarity => Str) = verbPolarityTable info sfxTbl ;
      in
--      polSfxTbl ;
--      \\tense,suffix,polarity => sfxTbl ! tense ! suffix ;
      \\tense,suffix,polarity => sfxTbl ! tense ! VSuffixNone ;
--      \\tense,suffix,polarity => tbl ! tense ; --- just to make things compile :(

    {- ~~~ Form V verbs ~~~ -}

    conjFormV : VerbInfo -> (VForm => VSuffixForm => Polarity => Str) = \i ->
      let
        formII = conjFormII i ;
      in
      \\f,s,p => pfx_T (formII ! f ! s ! p) ;

}
