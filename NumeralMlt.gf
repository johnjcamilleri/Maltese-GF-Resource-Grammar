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

	lin
		-- Produce a Number from Sub1000000
		num x = x ;

	oper
		-- Correctly abbreviate and join with numeral
		-- Params:
			-- numeral
		attachOrdinalArticle : Str -> Str = \num ->
			case num of {
				("s"|#LiquidCons) + #Consonant + _ => "l-i" + num ;
				("għ" | #Vowel) + _ => "l-" + num ;
				K@#CoronalConsonant + _ => "i" + K + "-" + num ;
				_ => "il-" + num
			} ;


		-- Make a number
		-- Should be moved to ResMlt ?
		mkNum : Str -> Str -> Str -> Str -> Str -> Str -> Num_Number -> Form1 = \unit,teen,ten,hundred,thousand,ordunit,num -> {
			s = table {
				Unit => table {
					NCard => unit ;		-- eg WIEĦED
					NOrd => ordunit		-- eg L-EWWEL
				} ;
				Teen => table {
					NCard => teen ;		-- eg DSATAX
					NOrd => (attachOrdinalArticle teen) + "-il"		-- eg ID-DSATAX-IL
				} ;
				TeenIl => table {
					NCard => teen + "-il" ;		-- eg DSATAX-IL
					NOrd => (attachOrdinalArticle teen) + "-il"		-- eg ID-DSATAX-IL
				} ;
				Ten => table {
					NCard => ten ;		-- eg TLETIN
					NOrd => attachOrdinalArticle ten		-- eg IT-TLETIN
				} ;
				Hund => table {
					NCard => case num of {
						NumDual => hundred ;		-- eg MITEJN
						_ => hundred ++ "mija"		-- eg SEBA' MIJA
					} ;
					NOrd => case num of {
						NumDual => attachOrdinalArticle hundred ;	-- eg IL-MITEJN
						_ => attachOrdinalArticle hundred ++ "mija"	-- eg IS-SEBA' MIJA
					}
				}
			} ;

{-
				NCard => table {
					Unit => unit ;
					Teen => teen ;
					TeenIl => teen + "-il" ;
					Ten => ten ;
					Hund => case num of {
						NumDual => hundred ;
						_ => hundred ++ "mija"
					}
				} ;
				NOrd => table {
					Unit => ordunit ; -- eg L-EWWEL
					Teen => (attachOrdinalArticle teen) + "-il" ; -- eg ID-DSATAX-IL
					TeenIl => teen + "-il" ; -- TODO
					Ten => attachOrdinalArticle ten ; -- eg IT-TLETIN
					--Hund => attachOrdinalArticle hundred ++ "mija"
					Hund => case num of {
						NumDual => attachOrdinalArticle hundred ;	-- eg IL-MITEJN
						_ => attachOrdinalArticle hundred ++ "mija"	-- eg IS-SEBA' MIJA
					}
				}
-}

			s2 = thousand ;
			n = num
		} ;

	lin
{-
		n2 = {
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
-}
		n2 = mkNum "tnejn" "tnax" "għoxrin" "mitejn" "tnejn" "tieni" NumDual ;
		n3 = mkNum "tlieta" "tlettax" "tletin" "tliet" "tlitt" "tielet" NumPl ;
		n4 = mkNum "erbgħa" "erbatax" "erbgħin" "erba'" "erbat" "raba" NumPl ;
		n5 = mkNum "ħamsa" "ħmistax" "ħamsin" "ħames" "ħamest" "ħames" NumPl ;
		n6 = mkNum "sitta" "sittax" "sitt" "sitt" "sitt" "sitt" NumPl ;
		n7 = mkNum "sebgħa" "sbatax" "sebgħin" "seba'" "sebat" "seba'" NumPl ;
		n8 = mkNum "tmienja" "tmintax" "tmenin" "tmien" "tmint" "tmin" NumPl ;
		n9 = mkNum "disgħa" "dsatax" "disgħin" "disa'" "disat" "disa'" NumPl ;

	oper
		-- Helper functions for below...
		-- Still don't really know what the point of them is!
		ss : Str -> Form2 = \a -> {
			s = table {
				NCard => a ;
				NOrd => a
			} ;
			s2 = a ;
			n = NumPl
		} ;
		ss2 : Str -> Str -> Form2 = \a,b -> {
			s = table {
				NCard => a ;
				NOrd => a
			} ;
			s2 = b ;
			n = NumPl
		} ;
{-
		ss3 : CardOrd => Str -> Form2 = \cas -> {
			s = cas ;
			s2 = cas ! NCard ;
			n = NumPl
		} ;
-}

	lin
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
		pot01 = mkNum "wieħed" "ħdax" [] [] [] "l-ewwel" NumSg ;
		pot0 d = d ** {n = NumPl} ;
		pot110 = NumeralMlt.ss "għaxra" ;
		pot111 = NumeralMlt.ss2 "ħdax" "ħdax-il";
		pot1to19 d = NumeralMlt.ss2 (d.s ! Teen ! NCard) (d.s ! TeenIl ! NCard);
		pot0as1 n = {
			s = n.s ! Unit ;
			s2 = n.s2 ;
			n = n.n
		} ;
		pot1 d = NumeralMlt.ss (d.s ! Ten ! NCard) ;
		pot1plus d e = NumeralMlt.ss ((e.s ! Unit ! NCard) ++ "u" ++ (d.s ! Ten ! NCard)) ;
		pot1as2 n = n ;
		pot2 d = NumeralMlt.ss (d.s ! Hund ! NCard) ;
		pot2plus d e = NumeralMlt.ss2 ((d.s ! Hund ! NCard) ++ "u" ++ e.s ! NCard) ((d.s ! Hund ! NCard) ++ "u" ++ e.s2) ;
		pot2as3 n = {
			s = \\cardord => n.s ! cardord ;
			s2 = n.s2 ;
			n = NumPl ;
		} ;
		pot3 n = {
			s = \\cardord => (elf n.s2) ! n.n ;
			s2 = n.s2 ;
			n = NumPl ;
		} ;
		pot3plus n m = {
			s = \\cardord => (elf n.s2) ! n.n ++ m.s ! cardord ;
			s2 = n.s2 ;
			n = NumPl ;
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
			s = d.s ++ (commaIf i.tail) ++ i.s ;
			n = NumPl ;
			tail = inc i.tail
		} ;

}
