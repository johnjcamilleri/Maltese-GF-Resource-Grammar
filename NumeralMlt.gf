-- NumeralMlt.gf: cardinals and ordinals
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2011
-- Licensed under LGPL

concrete NumeralMlt of Numeral = CatMlt [Numeral,Digits] ** open ResMlt in {

	flags coding=utf8 ;

-- Numeral, Digit
-- Dig, Digits

{-
	-- This code taken from examples/numerals/maltese.sty in GF darcs repository, July 2011.
	-- Original author unknown

	-- ABSTRACT definitions copied from lib/src/abstract/Numeral.gf

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
			s : DForm => CardOrd => Num_Case => Str ;
			thou : Str ;
			n : Num_Number
		} ;
		Form2 = {
			s : CardOrd => Num_Case => Str ;
			thou : Str ;
			n : Num_Number ;
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
		-- Should be moved to ResMlt ?
		-- Params:
			-- unit, eg TNEJN
			-- adjectival, eg ŻEWĠ
			-- teen, eg TNAX
			-- ten, eg GĦOXRIN
			-- hundred, eg MITEJN
			-- thousand, eg ELFEJN
			-- ordinal unit (without article), eg TIENI
			-- number, eg NumDual
		mkNum : Str -> Str -> Str -> Str -> Str -> Str -> Str -> Num_Number -> Form1 = \unit,ordunit,adjectival,teen,ten,hundred,thousand,num -> {
			s = table {
				Unit => table {
					NCard => table {
						NumNominative => unit ;		-- eg TNEJN
						NumAdjectival => adjectival -- eg ŻEWĠ
					} ;
					NOrd => \\numcase => (addDefiniteArticle ordunit)		-- eg IT-TIENI
				} ;
				Teen => table {
					NCard => table {
						NumNominative => teen ;			-- eg TNAX
						NumAdjectival => teen + "-il"	-- eg TNAX-IL
					} ;
					NOrd => \\numcase => (addDefiniteArticle teen) + "-il"	-- eg IT-TNAX-IL
				} ;
				Ten => table {
					NCard => \\numcase => ten ;						-- eg TLETIN
					NOrd => \\numcase => (addDefiniteArticle ten)	-- eg IT-TLETIN
				} ;
				Hund => table {
					NCard => case num of {
						NumDual => \\numcase => hundred ;		-- eg MITEJN
						_ => table {
							NumNominative => hundred ++ "mija" ;	-- eg SEBA' MIJA
							NumAdjectival => hundred ++ "mitt"		-- eg SEBA' MITT
						}
					} ;
					NOrd => case num of {
						NumDual => \\numcase => (addDefiniteArticle hundred) ;		-- eg IL-MITEJN
						_ => \\numcase => (addDefiniteArticle hundred) ++ "mitt"	-- eg IS-SEBA' MITT
					}
				}
			} ;
			thou = thousand ; -- TODO: This can be pushed to runtime...?
			n = num
		} ;

{-
		mkTeenIl : (CardOrd => Str) = overload {
			mkTeenIl : Str -> (CardOrd => Str) = \teen -> table {
				NCard => teen + "-il" ;						-- eg DSATAX-IL
				NOrd => (addDefiniteArticle teen) + "-il"	-- eg ID-DSATAX-IL
			} ;
			mkTeenIl : (CardOrd => Str) -> (CardOrd => Str) = \tab -> table {
				NCard => tab ! NCard + "-il" ;						-- eg DSATAX-IL
				NOrd => (addDefiniteArticle (tab ! NOrd)) + "-il"	-- eg ID-DSATAX-IL
			} ;
		} ;
-}

	lin
		--			Unit		Ord.Unit	Adjectival	Teen		Ten			Hundred		Thousand	Number
		n2 = mkNum "tnejn"		"tieni" 	"żewġ"		"tnax"		"għoxrin"	"mitejn"	"elfejn"	NumDual ;
		n3 = mkNum "tlieta"		"tielet"	"tliet"		"tlettax"	"tletin"	"tliet"		"tlitt"		NumPl ;
		n4 = mkNum "erbgħa"		"raba'"		"erba'"		"erbatax"	"erbgħin"	"erba'"		"erbat"		NumPl ;
		n5 = mkNum "ħamsa" 		"ħames"		"ħames"		"ħmistax"	"ħamsin"	"ħames"		"ħamest"	NumPl ;
		n6 = mkNum "sitta"		"sitt"		"sitt"		"sittax"	"sitt"		"sitt"		"sitt"		NumPl ;
		n7 = mkNum "sebgħa"		"seba'"		"seba'"		"sbatax"	"sebgħin"	"seba'"		"sebat"		NumPl ;
		n8 = mkNum "tmienja"	"tmin"		"tmin"		"tmintax"	"tmenin"	"tmien"		"tmint"		NumPl ;
		n9 = mkNum "disgħa"		"disa'"		"disa'"		"dsatax"	"disgħin"	"disa'"		"disat"		NumPl ;

	oper
		-- Helper functions for below
		mkForm2 : Form2 = overload {

			-- Infer ordinal & thousands
			mkForm2 : Str -> DForm -> Form2 = \card,form -> {
				s = table {
					NCard => \\numcase => card ;
					NOrd => \\numcase => addDefiniteArticle card
				} ;
				thou = card ;
				n = NumPl ;
				f = form ;
			} ;

			-- Infer adjectival, thousands
			mkForm2 : Str -> Str -> DForm -> Form2 = \card,ord,form -> {
				s = table {
					NCard => \\numcase => card ;
					NOrd => \\numcase => ord
				} ;
				thou = card ; -- TODO
				n = NumPl ;
				f = form ;
			} ;

			-- Infer thousands
			mkForm2 : Str -> Str -> Str -> DForm -> Form2 = \card,ord,adj,form -> {
				s = table {
					NCard => table {
						NumNominative => card ;
						NumAdjectival => adj
					} ;
					NOrd => \\numcase => ord
				} ;
				thou = adj ; -- TODO
				n = NumPl ;
				f = form ;
			} ;

			-- Given an existing table
			mkForm2 : (CardOrd => Num_Case => Str) -> DForm -> Form2 = \tab,form -> {
				s = tab ;
				thou = tab ! NCard ! NumNominative ; -- TODO
				n = NumPl ;
				f = form ;
			} ;


		}; -- end of mkForm2 overload

		joinTables : (Num_Case => Str) -> (Num_Case => Str) -> (Num_Case => Str) = \t1,t2 -> table {
			NumNominative => t1 ! NumNominative ++ "u" ++ t2 ! NumNominative ;
			NumAdjectival => t1 ! NumAdjectival ++ "u" ++ t2 ! NumAdjectival
		};

	lin

		-- Sub1000000 -> Numeral
		num x = x ;

{-
		pot01 =  {
			s = table {
				Unit => "wieħed" ;
				Teen => "ħdax" ;
				_ => "mija"
			} ;
			thou = "wieħed" ;
			n = NumSg
		} ;
-}
		-- Sub10 ; 1
		pot01 = mkNum "wieħed" "ħdax" [] [] [] [] "ewwel" NumSg ;

		-- Digit -> Sub10 ; d * 1
		-- TODO: special case for DUAL?
		pot0 d = d ** {n = NumPl} ;

		-- Sub100 ; 10, 11
		pot110 = mkForm2 "għaxra"	"l-għaxar"		"għaxar"	Teen ;
		pot111 = mkForm2 "ħdax"		"il-ħdax-il"	"ħdax-il"	Teen ;

		-- Digit -> Sub100 ; 10 + d
		--pot1to19 d = NumeralMlt.ss2 (d.s ! Teen ! NCard) (d.s ! TeenIl ! NCard);
		pot1to19 d = mkForm2 (d.s ! Teen) Teen ;

		-- Sub10 -> Sub100 ; coercion of 1..9
		pot0as1 d = {
			s = d.s ! Unit ;
			thou = d.thou ;
			n = d.n ;
			f = Unit ;
		} ;

		-- Digit -> Sub100 ; d * 10
		--pot1 d = NumeralMlt.ss (d.s ! Ten ! NCard) ;
		pot1 d = mkForm2 (d.s ! Ten) Ten ;

		-- Digit -> Sub10 -> Sub100 ; d * 10 + n
		-- pot1plus d e = NumeralMlt.ss ((e.s ! Unit ! NCard) ++ "u" ++ (d.s ! Ten ! NCard)) ;
		pot1plus d n =
			mkForm2
				((n.s ! Unit ! NCard ! NumNominative) ++ "u" ++ (d.s ! Ten ! NCard ! NumNominative))
				((n.s ! Unit ! NOrd ! NumNominative) ++ "u" ++ (d.s ! Ten ! NCard ! NumNominative))
				Ten ;

		-- Sub100 -> Sub1000 ; coercion of 1..99
		pot1as2 m = m ;

		-- Sub10 -> Sub1000 ; m * 100
		--pot2 d = NumeralMlt.ss (d.s ! Hund ! NCard) ;
		pot2 m = mkForm2 (m.s ! Hund) Hund ;

		-- Sub10 -> Sub100 -> Sub1000 ; m * 100 + n
		--pot2plus d e = NumeralMlt.ss2 ((d.s ! Hund ! NCard) ++ "u" ++ (e.s ! NCard)) ((d.s ! Hund ! NCard) ++ "u" ++ e.s2) ;
		pot2plus m n =
			mkForm2
				(table {
					NCard => joinTables (m.s ! Hund ! NCard) (n.s ! NCard) ;
					NOrd => joinTables (m.s ! Hund ! NOrd)  (n.s ! NCard)
				})
				Hund ;

		-- Sub1000 -> Sub1000000 ; coercion of 1..999
{-
		pot2as3 n = {
			s = \\cardord => n.s ! cardord ;
			thou = n.thou ;
			n = n.n ;
		} ;
-}
		pot2as3 m = m ;

		-- Sub1000 -> Sub1000000 ; m * 1000
		pot3 m = {
			s =
			let thou = case m.thou of { "mija" => "mitt" ; _ => m.thou } in
			case m.n of	{
				NumSg => elf "elf" ;
				NumDual => elf "elfejn" ;
				NumPl => case m.f of {
					Unit => elf2 thou "elef" ;
					_ => elf2 thou "elf"
				}
			} ;
			thou = m.thou ;
			n = NumPl ;
			f = Hund ; -- NOT IMPORTANT
		} ;

		-- Sub1000 -> Sub1000 -> Sub1000000 ; m * 1000 + n
		pot3plus m n = {
--			s = \\cardord => (elf m.thou) ! m.n ++ n.s ! cardord ;
			s =
			let ukemm = "u" ++ (n.s ! NCard ! NumNominative) in -- TODO
			case m.n of	{
				NumSg => elf2 "elf" ukemm ;
				NumDual => elf2 "elfejn" ukemm ;
				NumPl => case m.f of {
					Unit => elf2 m.thou ("elef" ++ ukemm) ;
					_ => elf2 m.thou ("elf" ++ ukemm)
				}
			} ;
			thou = m.thou ;
			n = NumPl ;
			f = Hund ; -- NOT IMPORTANT
		} ;

	oper
--		elf : (CardOrd => Str) = overload {
			elf : Str -> (CardOrd => Num_Case => Str) = \m -> table {
				NCard => \\numcase => m ;
				NOrd => \\numcase => (addDefiniteArticle m)
			} ;
			elf2 : Str -> Str -> (CardOrd => Num_Case => Str) = \m,n -> table {
				NCard => \\numcase => m ++ n ;
				NOrd => \\numcase => (addDefiniteArticle m) ++ n
			} ;
--		} ;

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
			n : Num_Number
		} ;

	oper
		-- Helper for making a Dig object. Specifying no number inplies plural.
		mkDig : Dig = overload {
			mkDig : Str -> Dig = \digit -> lin Dig {
				s = digit ;
				n = NumPl
			} ;
			mkDig : Str -> Num_Number -> Dig = \digit,num -> lin Dig {
				s = digit ;
				n = num
			} ;
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
		D_0 = mkDig "0" ;
		D_1 = mkDig "1" NumSg ;
		D_2 = mkDig "2" NumDual ;
		D_3 = mkDig "3" ;
		D_4 = mkDig "4" ;
		D_5 = mkDig "5" ;
		D_6 = mkDig "6" ;
		D_7 = mkDig "7" ;
		D_8 = mkDig "8" ;
		D_9 = mkDig "9" ;

		-- Create Digits from a Dig
		IDig d = d ** {tail = T1} ;

		-- Create Digits from combining Dig with Digits
		IIDig d i = {
			s = d.s ++ (commaIf i.tail) ++ i.s ;
			n = NumPl ;
			tail = inc i.tail
		} ;

}
