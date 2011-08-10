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
			s : DForm => CardOrd => Str ;
			s2 : Str ;
			n : Num_Number
		} ;
		Form2 = {
			s : CardOrd => Str ;
			s2 : Str ;
			n : Num_Number
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
			-- teen, eg TNAX
			-- ten, eg GĦOXRIN
			-- hundred, eg MITEJN
			-- thousand, eg ELFEJN
			-- ordinal unit (without article), eg TIENI
			-- number, eg NumDual
		mkNum : Str -> Str -> Str -> Str -> Str -> Str -> Num_Number -> Form1 = \unit,teen,ten,hundred,thousand,ordunit,num -> {
			s = table {
				Unit => table {
					NCard => unit ;		-- eg WIEĦED
					NOrd => (addDefiniteArticle ordunit)		-- eg L-EWWEL
				} ;
				Teen => table {
					NCard => teen ;		-- eg DSATAX
					NOrd => (addDefiniteArticle teen) + "-il"		-- eg ID-DSATAX-IL
				} ;
				TeenIl => table {
					NCard => teen + "-il" ;		-- eg DSATAX-IL
					NOrd => (addDefiniteArticle teen) + "-il"		-- eg ID-DSATAX-IL
				} ;
				Ten => table {
					NCard => ten ;		-- eg TLETIN
					NOrd => (addDefiniteArticle ten)		-- eg IT-TLETIN
				} ;
				Hund => table {
					NCard => case num of {
						NumDual => hundred ;		-- eg MITEJN
						_ => hundred ++ "mija"		-- eg SEBA' MIJA
					} ;
					NOrd => case num of {
						NumDual => (addDefiniteArticle hundred) ;	-- eg IL-MITEJN
						_ => (addDefiniteArticle hundred) ++ "mija"	-- eg IS-SEBA' MIJA
					}
				}
			} ;
			s2 = thousand ; -- TODO
			n = num
		} ;

	lin
		--			unit		teen		ten			hundred		thusand		ord unit	number
		n2 = mkNum "tnejn" 		"tnax"		"għoxrin"	"mitejn"	"elfejn"	"tieni"		NumDual ;
		n3 = mkNum "tlieta"		"tlettax"	"tletin"	"tliet"		"tlitt"		"tielet"	NumPl ;
		n4 = mkNum "erbgħa"		"erbatax"	"erbgħin"	"erba'"		"erbat"		"raba'"		NumPl ;
		n5 = mkNum "ħamsa" 		"ħmistax"	"ħamsin"	"ħames"		"ħamest"	"ħames"		NumPl ;
		n6 = mkNum "sitta"		"sittax"	"sitt"		"sitt"		"sitt"		"sitt"		NumPl ;
		n7 = mkNum "sebgħa"		"sbatax"	"sebgħin"	"seba'"		"sebat"		"seba'"		NumPl ;
		n8 = mkNum "tmienja"	"tmintax"	"tmenin"	"tmien"		"tmint"		"tmin"		NumPl ;
		n9 = mkNum "disgħa"		"dsatax"	"disgħin"	"disa'"		"disat"		"disa'"		NumPl ;

	oper
		-- Helper functions for below
		mkForm2 : Form2 = overload {

			-- Infer ordinal
			mkForm2 : Str -> Form2 = \card -> {
				s = table {
					NCard => card ;
					NOrd => addDefiniteArticle card
				} ;
				s2 = card ; -- TODO
				n = NumPl
			} ;

			-- Explicit ordinal
			mkForm2 : Str -> Str -> Form2 = \card,ord -> {
				s = table {
					NCard => card ;
					NOrd => ord
				} ;
				s2 = card ; -- TODO
				n = NumPl
			} ;

			-- Given an existing table
			mkForm2 : (CardOrd => Str) -> Form2 = \tab -> {
				s = tab ;
				s2 = tab ! NCard ; -- TODO
				n = NumPl
			} ;

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
			s2 = "wieħed" ;
			n = NumSg
		} ;
-}
		-- Sub10 ; 1
		pot01 = mkNum "wieħed" "ħdax" [] [] [] "ewwel" NumSg ;

		-- Digit -> Sub10 ; d * 1
		-- TODO: special case for DUAL?
		pot0 d = d ** {n = NumPl} ;

		-- Sub100 ; 10, 11
		pot110 = mkForm2 "għaxra" "l-għaxar" ;
		pot111 = mkForm2 "ħdax" "il-ħdax-il" ;

		-- Digit -> Sub100 ; 10 + d
		--pot1to19 d = NumeralMlt.ss2 (d.s ! Teen ! NCard) (d.s ! TeenIl ! NCard);
		pot1to19 d = mkForm2 (d.s ! Teen);

		-- Sub10 -> Sub100 ; coercion of 1..9
		pot0as1 n = {
			s = n.s ! Unit ;
			s2 = n.s2 ;
			n = n.n
		} ;

		-- Digit -> Sub100 ; d * 10
		--pot1 d = NumeralMlt.ss (d.s ! Ten ! NCard) ;
		pot1 d = mkForm2 (d.s ! Ten) ;

		-- Digit -> Sub10 -> Sub100 ; d * 10 + n
		-- pot1plus d e = NumeralMlt.ss ((e.s ! Unit ! NCard) ++ "u" ++ (d.s ! Ten ! NCard)) ;
		pot1plus d e =
			mkForm2
				((e.s ! Unit ! NCard) ++ "u" ++ (d.s ! Ten ! NCard))
				((e.s ! Unit ! NOrd) ++ "u" ++ (d.s ! Ten ! NCard)) ;

		-- Sub100 -> Sub1000 ; coercion of 1..99
		pot1as2 n = n ;

		-- Sub10 -> Sub1000 ; m * 100
		--pot2 d = NumeralMlt.ss (d.s ! Hund ! NCard) ;
		pot2 d = mkForm2 (d.s ! Hund) ;

		-- Sub10 -> Sub100 -> Sub1000 ; m * 100 + n
		--pot2plus d e = NumeralMlt.ss2 ((d.s ! Hund ! NCard) ++ "u" ++ (e.s ! NCard)) ((d.s ! Hund ! NCard) ++ "u" ++ e.s2) ;
		pot2plus d e =
			mkForm2
				((d.s ! Hund ! NCard) ++ "u" ++ (e.s ! NCard))
				((d.s ! Hund ! NOrd) ++ "u" ++ (e.s ! NCard)) ;

		-- Sub1000 -> Sub1000000 ; coercion of 1..999
{-
		pot2as3 n = {
			s = \\cardord => n.s ! cardord ;
			s2 = n.s2 ;
			n = n.n ;
		} ;
-}
		pot2as3 n = n ;

		-- Sub1000 -> Sub1000000 ; m * 1000
		pot3 n = {
			s = \\cardord => (elf n.s2) ! n.n ;
			s2 = n.s2 ;
			n = NumPl ;
		} ;

		-- Sub1000 -> Sub1000 -> Sub1000000 ; m * 1000 + n
		pot3plus n m = {
			s = \\cardord => (elf n.s2) ! n.n ++ m.s ! cardord ;
			s2 = n.s2 ;
			n = NumPl ;
		} ;

	oper
		-- TODO
		elf : Str -> Num_Number => Str = \attr -> table {
			NumSg => "elf" ;
			NumDual => "elfejn" ;
			NumPl => attr ++ "elef"
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
