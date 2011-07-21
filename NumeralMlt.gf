-- NumeralMlt.gf: cardinals and ordinals
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2011
-- Licensed under LGPL

concrete NumeralMlt of Numeral = CatMlt ** open Predef, Prelude, ResMlt, MorphoMlt in {

-- Digit
-- Numeral

{-
	-- This code taken from examples/numerals/maltese.sty in GF darcs repository.
	-- Original author unknown

	-- ===== ABSTRACT =====
	-- numerals from 1 to 999999 in decimal notation

	flags startcat=Numeral ;

	cat
		Numeral ;     -- 0..
		Digit ;       -- 2..9
		Sub10 ;       -- 1..9
		Sub100 ;      -- 1..99
		Sub1000 ;     -- 1..999
		Sub1000000 ;  -- 1..999999

	fun
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

	-- ===== CONCRETE =====
	param DForm = unit | teen | teenil | ten | hund ;
	param Size = sg | pl | dual ;

	oper LinDigit = {s: DForm => Str ; s2 : Str ; size : Size } ;
	oper Form = {s : Str ; s2 : Str ; size : Size } ;

	lincat Numeral = {s : Str} ;
	lincat Digit = LinDigit ;
	lincat Sub10 = LinDigit ;
	lincat Sub100 = Form ;
	lincat Sub1000 = Form ;
	lincat Sub1000000 = {s : Str} ;

	lin num x = x ; -- TODO

	oper mkN : Str -> Str -> Str -> Str -> Str -> LinDigit = \u -> \tn -> \t -> \h -> \e ->
	  {s = table {unit => u ; teen => tn + "ax" ; teenil => tn + "ax" + "il" ;
				  ten => t ; hund => h ++ "mija"} ; s2 = e ; size = pl };

	lin n2 =
	  {s = table {unit => "tnejn" ;
				  teen => "tnax" ; teenil => "tnax-il" ;
				  ten  => "gh-oxrin" ;
				  hund => "mitejn"} ; s2 = "tnejn" ; size = dual} ;
	lin n3 = mkN "tlieta" "tlett" "tletin" "tliet" "tlitt";
	lin n4 = mkN "erbgh-a" "erbat" "erbgh-in" "erba'" "erbat";
	lin n5 = mkN "h-amsa" "h-mist" "h-amsin" "h-ames" "h-amest" ;
	lin n6 = mkN "sitta" "sitt" "sitt" "sitt" "sitt";
	lin n7 = mkN "sebgh-a" "sbat" "sbebgh-in" "seba'" "sebat" ;
	lin n8 = mkN "tmienja" "tmint" "tmenin" "tmien" "tmint" ;
	lin n9 = mkN "disgh-a" "dsat" "disgh-in" "disa'" "disat";

	oper ss : Str -> Form = \s1 -> {s = s1 ; s2 = s1 ; size = pl };
	oper ss2 : Str -> Str -> Form = \a -> \b -> {s = a ; s2 = b ; size = pl };

	lin pot01  =
	  {s = table {unit => "wieh-ed" ; teen => "h-dax" ; _ => "mija" } ;
	   s2 = "wieh-ed" ;
	   size = sg};
	lin pot0 d = d;
	lin pot110 = ss "gh-axra" ;
	lin pot111 = ss2 "h-dax" "h-dax-il";
	lin pot1to19 d = ss2 (d.s ! teen) (d.s ! teenil);
	lin pot0as1 n = {s = n.s ! unit ; s2 = n.s2 ; size = n.size} ;
	lin pot1 d = ss (d.s ! ten) ;
	lin pot1plus d e = ss ((e.s ! unit) ++ "u" ++ (d.s ! ten)) ;
	lin pot1as2 n = n ;
	lin pot2 d = ss (d.s ! hund) ;
	lin pot2plus d e = ss2 ((d.s ! hund) ++ "u" ++ e.s)
						   ((d.s ! hund) ++ "u" ++ e.s2) ;
	lin pot2as3 n = {s = n.s } ;
	lin pot3 n = { s = (elf n.s2) ! n.size } ;
	lin pot3plus n m = { s = (elf n.s2) ! n.size ++ m.s} ;

	oper elf : Str -> Size => Str = \attr ->
	  table {pl => attr ++ "elef" ; dual => "elfejn" ; sg => "elf"} ;

-}

}
