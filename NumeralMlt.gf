-- NumeralMlt.gf: cardinals and ordinals
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Licensed under LGPL

concrete NumeralMlt of Numeral = CatMlt [Numeral,Digits] ** open Prelude,ResMlt in {

  flags coding=utf8 ;

-- Numeral, Digit
-- Dig, Digits

{-
  -- Numerals from 1 to 999999 in decimal notation
  cat
    Numeral ;     -- 0..
    Digit ;       -- 2..9
    Sub10 ;       -- 1..9
    Sub100 ;      -- 1..99
    Sub1000 ;     -- 1..999
    Sub1000000 ;  -- 1..999999

  data
    num : Sub1000000 -> Numeral ;

    n2, n3, n4, n5, n6, n7, n8, n9 : Digit ;

    pot01 : Sub10 ;                               -- 1
    pot0 : Digit -> Sub10 ;                       -- d * 1
    pot110 : Sub100 ;                             -- 10
    pot111 : Sub100 ;                             -- 11
    pot1to19 : Digit -> Sub100 ;                  -- 10 + d
    pot0as1 : Sub10 -> Sub100 ;                   -- coercion of 1..9
    pot1 : Digit -> Sub100 ;                      -- d * 10
    pot1plus : Digit -> Sub10 -> Sub100 ;         -- d * 10 + n
    pot1as2 : Sub100 -> Sub1000 ;                 -- coercion of 1..99
    pot2 : Sub10 -> Sub1000 ;                     -- m * 100
    pot2plus : Sub10 -> Sub100 -> Sub1000 ;       -- m * 100 + n
    pot2as3 : Sub1000 -> Sub1000000 ;             -- coercion of 1..999
    pot3 : Sub1000 -> Sub1000000 ;                -- m * 1000
    pot3plus : Sub1000 -> Sub1000 -> Sub1000000 ; -- m * 1000 + n
-}

  oper
    Form1 = {
      s : DForm => CardOrd => NumCase => Str ;
      --thou : CardOrd => Str ;
      thou : { s : Str ; treatAs : DForm } ;
      n : NumForm ;
    } ;
    Form2 = {
      s : CardOrd => NumCase => Str ;
      --thou : CardOrd => Str ;
      thou : { s : Str ; treatAs : DForm } ;
      n : NumForm ;
      f : DForm ;
    } ;


  lincat
    Digit = Form1 ;
    Sub10 = Form1 ;
    Sub100 = Form2 ;
    Sub1000 = Form2 ;
    Sub1000000 = Form2 ;

  oper

    -- Make a "number" (in this case a Form1)
    -- Params:
      -- unit, eg TNEJN
      -- ordinal unit (without article), eg TIENI
      -- adjectival, eg ŻEWĠ
      -- teen, eg TNAX
      -- ten, eg GĦOXRIN
      -- number, eg Num2
    --mkNum : Str -> Str -> Str -> Str -> Str -> Str -> Str -> NumForm -> Form1 = \unit,ordunit,adjectival,teen,ten,hundred,thousand,num -> {
    mkNum : Str -> Str -> Str -> Str -> Str -> NumForm -> Form1 = \unit,ordunit,adjectival,teen,ten,num ->
      let
        hundred = case num of {
          Num1 => "mija" ;
          Num2 => "mitejn" ;
          _ => adjectival
        } ;
        thousand = case num of {
          Num1 => "wieħed" ;
          Num2 => "elfejn" ;
          _ => case adjectival of {
            _ + "'" => (init adjectival) + "t" ;  -- eg SEBA' -> SEBAT
            _ + "t" => adjectival ;          -- eg SITT -> SITT
            _ => adjectival + "t"          -- eg ĦAMES -> ĦAMEST
          }
        }
      in {
      s = table {
        Unit => table {
          NCard => table {
            NumNom => unit ;    -- eg TNEJN
            NumAdj => adjectival -- eg ŻEWĠ
          } ;
          NOrd => \\numcase => artDef ++ ordunit      -- eg IT-TIENI
        } ;
        Teen => table {
          NCard => table {
            NumNom => teen ;      -- eg TNAX
            NumAdj => teen + "-il"  -- eg TNAX-IL
          } ;
          NOrd => table {
            NumNom => artDef ++ teen ;      -- eg IT-TNAX
            NumAdj => artDef ++ (teen + "-il")  -- eg IT-TNAX-IL
          }
        } ;
        Ten => table {
          NCard => \\numcase => ten ;            -- eg TLETIN
          NOrd => \\numcase => artDef ++ ten    -- eg IT-TLETIN
        } ;
        -- Hund, Thou
        _ => table {
          NCard => case num of {
            Num1 => table {
              NumNom => "mija" ;  -- ie MIJA
              NumAdj => "mitt"    -- ie MITT suldat
            } ;
            Num2 => \\numcase => hundred ;    -- ie MITEJN
            _ => table {
              NumNom => hundred ++ "mija" ;  -- eg MIJA, SEBA' MIJA
              NumAdj => hundred ++ "mitt"    -- eg MITT, SEBA' MITT suldat
            }
          } ;
          NOrd => case num of {
            Num1 => table {
              NumNom => artDef ++ "mija" ;  -- ie IL-MIJA
              NumAdj => artDef ++ "mitt"    -- ie IL-MITT suldat
            } ;
            Num2 => \\numcase => artDef ++ hundred ;    -- ie IL-MITEJN, IL-MITEJN suldat
            _ => table {
              NumNom => artDef ++ hundred ++ "mija" ;  -- eg IS-SEBA' MIJA
              NumAdj => artDef ++ hundred ++ "mitt"  -- eg IS-SEBA' MITT suldat
            }
          }
        }
      } ;
--      thou = thousand ;
      thou = { s = thousand ; treatAs = Unit } ;
      n = num ;
    } ;

  lin
    --      Unit    Ord.Unit  Adjectival  Teen    Ten      Number
    n2 = mkNum "tnejn"   "tieni"  "żewġ"  "tnax"    "għoxrin" Num2 ;
    n3 = mkNum "tlieta"  "tielet" "tlett" "tlettax" "tletin"  Num3_10 ; --- TODO tlett / tliet ?
    n4 = mkNum "erbgħa"  "raba'"  "erba'" "erbatax" "erbgħin" Num3_10 ;
    n5 = mkNum "ħamsa"   "ħames"  "ħames" "ħmistax" "ħamsin"  Num3_10 ;
    n6 = mkNum "sitta"   "sitt"   "sitt"  "sittax"  "sittin"  Num3_10 ;
    n7 = mkNum "sebgħa"  "seba'"  "seba'" "sbatax"  "sebgħin" Num3_10 ;
    n8 = mkNum "tmienja" "tmin"   "tmin"  "tmintax" "tmenin"  Num3_10 ;
    n9 = mkNum "disgħa"  "disa'"  "disa'" "dsatax"  "disgħin" Num3_10 ;

  oper
    -- Helper functions for below
    mkForm2 : Form2 = overload {

      -- Infer adjectival, thousands
      mkForm2 : Str -> Str -> DForm -> NumForm -> Form2 = \card,ord,dform,numform -> {
        s = table {
          NCard => \\numcase => card ;
          NOrd => \\numcase => ord
        } ;
        thou = { s = card ; treatAs = dform } ;
        n = numform ;
        f = dform ;
      } ;

      -- Explicit everything
      mkForm2 : Str -> Str -> Str -> Str -> DForm -> NumForm -> Form2 = \card,ord,adj,thousand,dform,numform -> {
        s = table {
          NCard => table {
            NumNom => card ;
            NumAdj => adj
          } ;
          NOrd => table {
            NumNom => artDef ++ ord ;
            NumAdj => artDef ++ adj
          }
        } ;
        thou =  { s = thousand ; treatAs = dform } ;
        n = numform ;
        f = dform ;
      } ;

      -- Given an existing table
      mkForm2 : (CardOrd => NumCase => Str) -> DForm -> NumForm -> Form2 = \tab,dform,numform -> {
        s = tab ;
        thou = {
          s = case dform of {
            Teen => tab ! NCard ! NumAdj ;
            _ => tab ! NCard ! NumNom
          } ;
          treatAs = dform ;
        } ;
        n = numform ;
        f = dform ;
      } ;

    }; -- end of mkForm2 overload

  lin

    -- Sub1000000 -> Numeral
    num x = x ;

    -- Sub10 ; 1
    --        Unit    Ord.Unit  Adjectival  Teen    Ten      Number
    pot01 = mkNum  "wieħed"  "ewwel"    "wieħed"  []      []      Num1 ;

    -- Digit -> Sub10 ; d * 1
    pot0 d = d ** {n = case d.n of { Num2 => Num2 ; _ => Num3_10 }} ;

    -- Sub100 ; 10, 11
    --          Cardinal  Ordinal    Adjectival  Thousand  Form
    pot110 = mkForm2  "għaxra"  "għaxar"  "għaxar"  "għaxart"  Unit Num3_10 ;
    pot111 = mkForm2  "ħdax"    "ħdax"    "ħdax-il"  "ħdax-il"  Teen Num11_19 ;

    -- Digit -> Sub100 ; 10 + d
    pot1to19 d = mkForm2 (d.s ! Teen) Teen Num11_19 ;

    -- Sub10 -> Sub100 ; coercion of 1..9
    pot0as1 d = {
      s = d.s ! Unit ;
      thou = d.thou ;
      n = d.n ;
      f = Unit ;
    } ;

    -- Digit -> Sub100 ; d * 10
    pot1 d =
      let
        numform : NumForm = case d.n of {
          Num1 => Num3_10 ;
          _ => Num20_99
          }
      in mkForm2 (d.s ! Ten) Ten numform ;

    -- Digit -> Sub10 -> Sub100 ; d * 10 + n
    pot1plus d n =
      let
        unit = (n.s ! Unit ! NCard ! NumNom) ;
        numform : NumForm = case d.n of {
          Num1 => Num11_19 ;
          _ => Num20_99
          }
      in
      mkForm2
        (unit ++ "u" ++ (d.s ! Ten ! NCard ! NumNom))
        (artDef ++ unit ++ "u" ++ (d.s ! Ten ! NCard ! NumNom))
        Ten
        numform
      ;

    -- Sub100 -> Sub1000 ; coercion of 1..99
    pot1as2 m = m ;

    -- Sub10 -> Sub1000 ; m * 100
    pot2 m = {
      s = m.s ! Hund ;
      thou = {
        s = case m.n of {
          Num1 => "mitt" ; -- Special case for "mitt elf"
          Num2 => "mitejn" ; -- Special case for "mitejn elf"
          _ => m.thou.s
        } ;
        treatAs = Hund ;
      } ;
      n = Num0 ;
      f = Hund ;
    } ;

    -- Sub10 -> Sub100 -> Sub1000 ; m * 100 + n
    pot2plus m n =
      let
        hund : Str = m.s ! Hund ! NCard ! NumNom
      in {
        s = table {
          NCard => table {
            NumNom => hund ++ "u" ++ n.s ! NCard ! NumNom ;
            NumAdj => hund ++ "u" ++ n.s ! NCard ! NumAdj
          } ;
          NOrd => table {
            NumNom => artDef ++ hund ++ "u" ++ n.s ! NCard ! NumNom ;
            NumAdj => artDef ++ hund ++ "u" ++ n.s ! NCard ! NumAdj
          }
        } ;
        thou = {
          s = hund ++ "u" ++ n.thou.s ;
          treatAs = case n.n of {
            Num1 => Ten ; -- specific case for mija u wiehed elf
            _ => n.f  -- eg So that "106,000" is treated as "6,000"
          } ;
        } ;
        n = n.n ;
        f = Hund ;
      } ;

    -- Sub1000 -> Sub1000000 ; coercion of 1..999
    pot2as3 m = m ;

    -- Sub1000 -> Sub1000000 ; m * 1000
    pot3 m = {
      s =
      case <m.n, m.thou.treatAs> of  {
        <Num1,_> => numTable "elf" ;        -- 1 * 1000
        <Num2,_> => numTable "elfejn" ;      -- 2 * 1000
        <_,Unit> => numTable m.thou.s "elef" ;  -- 3-10 * 1000
        <_,_> => numTable m.thou.s "elf"    -- 11+ * 1000
      } ;
      thou = {
        s = m.thou.s ;
        treatAs = m.f ;
      } ;
      n = Num0 ;
      f = Thou ; -- NOT IMPORTANT
    } ;

    -- Sub1000 -> Sub1000 -> Sub1000000 ; m * 1000 + n
    pot3plus m n = {
      s =
      let
        ukemm = table {
          NumNom => "u" ++ (n.s ! NCard ! NumNom) ;
          NumAdj => "u" ++ (n.s ! NCard ! NumAdj)
        }
      in
        case <m.n, m.thou.treatAs> of  {
          <Num1,_>     => numTable "elf" ukemm ;
          <Num2,_>     => numTable "elfejn" ukemm ;
          <_,Unit>  => numTable (m.thou.s ++ "elef") ukemm ;
          <_,_>     => numTable (m.thou.s ++ "elf") ukemm
        } ;
      thou = {
        s = m.thou.s ;
        treatAs = m.f ;
      } ;
      n = n.n ;
      f = Hund ; -- NOT IMPORTANT
    } ;

  oper
      -- Build "x thousand" table
      numTable : (CardOrd => NumCase => Str) = overload {

        numTable : Str -> (CardOrd => NumCase => Str) = \thou -> table {
          NCard => \\numcase => thou ;
          NOrd => \\numcase => artDef ++ thou
        } ;

        numTable : Str -> Str -> (CardOrd => NumCase => Str) = \thou,attach -> table {
          NCard => \\numcase => thou ++ attach ;
          NOrd => \\numcase => artDef ++ thou ++ attach
        } ;

        numTable : Str -> (NumCase => Str) -> (CardOrd => NumCase => Str) = \thou,attach -> table {
          NCard => table {
            NumNom => thou ++ (attach ! NumNom) ;
            NumAdj => thou ++ (attach ! NumAdj)
          } ;
          NOrd => table {
            NumNom => artDef ++ thou ++ (attach ! NumNom) ;
            NumAdj => artDef ++ thou ++ (attach ! NumAdj)
          }
        } ;

      } ;

{-
  Numerals as sequences of digits have a separate, simpler grammar
  ================================================================

  cat
    Dig ;  -- single digit 0..9

  data
    IDig  : Dig -> Digits ;       -- 8
    IIDig : Dig -> Digits -> Digits ; -- 876

    D_0, D_1, D_2, D_3, D_4, D_5, D_6, D_7, D_8, D_9 : Dig ;
-}

  lincat

    Dig = {
      s : Str ;
      n : NumForm ;
      -- i : Int ; -- internal counter
    } ;

  oper
    -- Helper for making a Dig object.
    mkDig : Str -> NumForm -> Dig = \digit,num -> lin Dig {
      s = digit ;
      n = num
      } ;

    -- For correct comma placement in Digits
    commaIf : DTail -> Str = \t -> case t of {
      T3 => "," ;
      _ => []
    } ;
    inc : DTail -> DTail = \t -> case t of {
      T1 => T2 ;
      T2 => T3 ;
      T3 => T1
    } ;

  lin
    -- Dig
    D_0 = mkDig "0" Num0 ;
    D_1 = mkDig "1" Num1 ;
    D_2 = mkDig "2" Num2 ;
    D_3 = mkDig "3" Num3_10 ;
    D_4 = mkDig "4" Num3_10 ;
    D_5 = mkDig "5" Num3_10 ;
    D_6 = mkDig "6" Num3_10 ;
    D_7 = mkDig "7" Num3_10 ;
    D_8 = mkDig "8" Num3_10 ;
    D_9 = mkDig "9" Num3_10 ;

    -- Create Digits from a Dig
    IDig d = d ** {tail = T1} ;

    -- Create Digits from combining Dig with Digits
    -- Dig -> Digits -> Digits
    IIDig d i = {
      s = d.s ++ (commaIf i.tail) ++ i.s ;
      n = case <d.n,i.n> of {
        <Num0,num> => num ; -- 0 x
        <Num1,Num0> => Num3_10 ; -- 1 0
        <Num1,_> => Num11_19 ; -- 1 1
        <Num2,_> => Num20_99 ; -- 2 x
        <Num3_10,_> => Num20_99 ; -- [3-9] x
        <Num20_99,_> => Num20_99 ;
        <_,_> => Num20_99 --- how to handle overwrap? see i:Int in lincat Dig above
        } ;
      tail = inc i.tail
    } ;

}
