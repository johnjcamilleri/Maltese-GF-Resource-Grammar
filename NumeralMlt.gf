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
{-
		-- These 2 types used in lincat below
		LinDigit = {
			s : DForm => Str ;
			s2 : Str ;
			n : Num_Number
		} ;
-}
		Form = {
			s : Str ;		--
			s2 : Str ;		--
			n : Num_Number		-- Number
		} ;


	-- HERE HERE HERE HERE HERE HERE HERE HERE HERE HERE HERE HERE
	lincat
		Digit = Numeral ;
		Sub10 = Numeral ;
		Sub100 = Form ;
		Sub1000 = Form ;
		Sub1000000 = Form ;

	lin num x = x ; -- TODO

	oper
		mkNum : Str -> Str -> Str -> Str -> Str -> Numeral = \unit,teen,ten,hundred,thousand -> lin Numeral {
			s = table {
				Unit => unit ;
				Teen => teen ;
				TeenIl => teen + "-il" ;
				Ten => ten ;
				Hund => hundred ++ "mija"
			} ;
			s2 = thousand ;
			n = NumPl
		} ;

	lin
		n2 = lin Numeral {
			s = table {
				Unit => "tnejn" ;
				Teen => "tnax" ;
				TeenIl => "tnax-il" ;
				Ten  => "għoxrin" ;
				Hund => "mitejn"
			} ;
			s2 = "tnejn" ;
			n = NumDual
		} ;
		n3 = mkNum "tlieta" "tlettax" "tletin" "tliet" "tlitt" ;
		n4 = mkNum "erbgħa" "erbatax" "erbgħin" "erba'" "erbat" ;
		n5 = mkNum "ħamsa" "ħmistax" "ħamsin" "ħames" "ħamest" ;
		n6 = mkNum "sitta" "sittax" "sitt" "sitt" "sitt" ;
		n7 = mkNum "sebgħa" "sbatax" "sbebgħin" "seba'" "sebat" ;
		n8 = mkNum "tmienja" "tmintax" "tmenin" "tmien" "tmint" ;
		n9 = mkNum "disgħa" "dsatax" "disgħin" "disa'" "disat" ;

	oper
		-- Helper functions for creating s/s2/n tables
		ss : Str -> Form = \a -> {
			s = a ;
			s2 = a ;
			n = NumPl
		} ;
		ss2 : Str -> Str -> Form = \a,b -> {
			s = a ;
			s2 = b ;
			n = NumPl
		} ;

	lin
		pot01 = lin Numeral {
			s = table {
				Unit => "wieħed" ;
				Teen => "ħdax" ;
				_ => "mija"
			} ;
			s2 = "wieħed" ;
			n = NumSg
		} ;
		pot0 d = d;
		pot110 = NumeralMlt.ss "għaxra" ;
		pot111 = NumeralMlt.ss2 "ħdax" "ħdax-il";
		pot1to19 d = NumeralMlt.ss2 (d.s ! Teen) (d.s ! TeenIl);
		pot0as1 n = {
			s = n.s ! Unit ;
			s2 = n.s2 ;
			n = n.n
		} ;
		pot1 d = NumeralMlt.ss (d.s ! Ten) ;
		pot1plus d e = NumeralMlt.ss ((e.s ! Unit) ++ "u" ++ (d.s ! Ten)) ;
		pot1as2 n = n ;
		pot2 d = NumeralMlt.ss (d.s ! Hund) ;
		pot2plus d e = NumeralMlt.ss2 ((d.s ! Hund) ++ "u" ++ e.s) ((d.s ! Hund) ++ "u" ++ e.s2) ;
		pot2as3 n = {
			s = n.s ;
			s2 = n.s2 ; -- these are prob wrong
			n = NumPl ; -- these are prob wrong
		} ;
		pot3 n = {
			s = (elf n.s2) ! n.n ;
			s2 = n.s2 ; -- these are prob wrong
			n = NumPl ; -- these are prob wrong
		} ;
		pot3plus n m = {
			s = (elf n.s2) ! n.n ++ m.s ;
			s2 = n.s2 ; -- these are prob wrong
			n = NumPl ; -- these are prob wrong
		} ;

	oper
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
			s = d.s ++ commaIf i.tail ++ i.s ;
			n = NumPl
		} ;

}
