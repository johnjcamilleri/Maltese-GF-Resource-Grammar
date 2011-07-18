-- ResMlt.gf: Language-specific parameter types, morphology, VP formation
--
-- Maltese Resource Grammar Library
-- (c) 2011 John J. Camilleri [john@johnjcamilleri.com]
-- Licensed under LGPL

--# -path=.:../abstract:../common:../prelude

{-
	Verb types summary:
	===================
	- Strong verb: none of radicals are semi-vowels		eg ĦAREĠ (Ħ-R-Ġ)
	- Defective verb: third radical is semivowel GĦ		eg QATA' (Q-T-GĦ)
	- Weak verb: third radical is semivowel J			eg MEXA (M-X-J)
	- Hollow verb: long A or IE btw radicals 1 & 3		eg QAL (Q-W-L) or SAB (S-J-B)
	- Double/Geminated verb: radicals 2 & 3 identical	eg ĦABB (Ħ-B-B)
	- Quadriliteral verb: 4 radicals					eg QARMEĊ (Q-R-M-Ċ)
-}


resource ResMlt = PatternsMlt ** open Prelude in {

	flags coding=utf8 ;

	param

		Number  = Sg | Pl ;
		N_Number =
			  N_Sg		-- Singular, eg BAJDA
			| N_Dl		-- Dual, eg WIDNEJN
			| N_Det		-- Determinate plural, eg [zewġ] BAJDIET
			| N_Coll	-- Collective plural, eg BAJD
		;

		N_PluralType = Sound | Broken ; -- Sound = External (affix) / Broken = Internal


		Gender  = Masc | Fem ;
--		Case    = Nom | Acc | Gen ;
--		Person  = P1 | P2 | P3 ;
--		State   = Def | Indef | Const ;
--		Mood    = Ind | Cnj | Jus ;
--		Voice   = Act | Pas ;
		VOrigin =
			  Semitic
			| Romance
			| English
		;
--		Order   = Verbal | Nominal ;

		-- Just for my own use
		-- Mamma = Per3 Sg Masc ;

		-- Shortcut type
		GenNum = gn Gender Number ;

		-- Agreement features
		Agr =
			  Per1 Number	-- Jiena, Aħna
			| Per2 Number	-- Inti, Intom
			| Per3Sg Gender	-- Huwa, Hija
			| Per3Pl		-- Huma
		;

		-- Possible tenses
		Tense =
			  Perf	-- Perfect tense, eg SERAQ
			| Impf -- Imperfect tense, eg JISRAQ
			| Imp	-- Imperative, eg ISRAQ
			-- | PresPart	-- Present Particible. Intransitive and 'motion' verbs only, eg NIEŻEL
			-- | PastPart	-- Past Particible. Both verbal & adjectival function, eg MISRUQ
			-- | VerbalNoun	-- Verbal Noun, eg SERQ
		;

		-- Possible verb forms (tense + person)
		VForm =
			  VPerf Agr		-- Perfect tense in all pronoun cases
			| VImpf Agr		-- Imperfect tense in all pronoun cases
			| VImp Number 			-- Imperative is always Per2, Sg & Pl
			-- | VPresPart GenNum	-- Present Particible for Gender/Number
			-- | VPastPart GenNum	-- Past Particible for Gender/Number
			-- | VVerbalNoun			-- Verbal Noun
		;

		-- Possible verb types
		VType =
			  Strong	-- Strong verb: none of radicals are semi-vowels	eg ĦAREĠ (Ħ-R-Ġ)
			| Defective	-- Defective verb: third radical is semivowel GĦ	eg QATA' (Q-T-GĦ)
			| Weak		-- Weak verb: third radicl is semivowel J			eg MEXA (M-X-J)
			| Hollow	-- Hollow verb: long A or IE btw radicals 1 & 3		eg QAL (Q-W-L) or SAB (S-J-B)
			| Double	-- Double/Geminated verb: radicals 2 & 3 identical	eg ĦABB (Ħ-B-B)
			| Quad		-- Quadliteral verb									eg KARKAR (K-R-K-R), MAQDAR (M-Q-D-R), LEMBEB (L-M-B-B)
		;

	oper

		-- Roots & Patterns
		Pattern : Type = {v1, v2 : Str} ; -- vowel1, vowel2
		-- Root3 : Type = {K, T, B : Str} ;
		-- Root4 : Type = Root3 ** {L : Str} ;
		Root : Type = {K, T, B, L : Str} ;

		-- Some classes. I need to include "c" because currently "ċ" gets downgraded to "c" in input :/
		Consonant : pattern Str = #( "b" | "c" | "ċ" | "d" | "f" | "ġ" | "g" | "għ" | "ħ" | "h" | "j" | "k" | "l" | "m" | "n" | "p" | "q" | "r" | "s" | "t" | "v" | "w" | "x" | "ż" | "z" );
		CoronalConsonant : pattern Str = #( "c" | "ċ" | "d" | "n" | "r" | "s" | "t" | "x" | "ż" | "z" ); -- "konsonanti xemxin"
		LiquidCons : pattern Str = #( "l" | "m" | "n" | "r" | "għ" );
		Vowel : pattern Str = #( "a" | "e" | "i" | "o" | "u" );
		Digraph : pattern Str = #( "ie" );
		SemiVowel : pattern Str = #( "għ" | "j" );

		{- ===== Type declarations ===== -}

		-- VP = {
			-- v : Verb ;
			-- clit : Str ;
			-- clitAgr : ClitAgr ;
			-- obj : Agr => Str
		-- } ;

		-- NP = {
			-- s : Case => {clit,obj : Str ; isClit : Bool} ;
			-- a : Agr
		-- } ;

		Noun : Type = {
			s : N_Number => Str ;
			g : Gender ;
		} ;

		-- Adj : Type = {
			-- s : Gender => Number => Str ;
			-- isPre : Bool ;
		-- } ;

		Verb : Type = {
			s : VForm => Str ;	-- Give me the form (tense, person etc) and I'll give you the string
			t : VType ;			-- Inherent - Strong/Hollow etc
			o : VOrigin ;		-- Inherent - a verb of Semitic or Romance origins?
		} ;


		{- ===== NOUNS ===== -}

		-- Overloaded function for building a noun
		-- Return: Noun
		mkNoun : Noun = overload {

			-- Take the singular and infer gender & plural
			-- Params:
				-- Singular, eg AJRUPLAN
			mkNoun : Str -> Noun = \sing -> {
					s = table {
						N_Sg => sing ;
						N_Dl => [] ;
						N_Pl => sing + "i"
					} ;
					g = case last(sing) of {
						"a" => Fem ;
						_ => Masc
					} ;
				} ;

			-- Take the singular and infer the plural (assumes no double)
			-- Params:
				-- Singular, eg AJRUPLAN
				-- Gender
			mkNoun : Str -> Gender -> Noun = \sing,gen -> {
					s = table {
						N_Sg => sing ;
						N_Dl => [] ;
						N_Pl => sing + "i"
					} ;
					g = gen ;
				} ;

			-- Take the singular and plural (assumes no double)
			-- Params:
				-- Singular, eg KTIEB
				-- Plural, eg KOTBA
				-- Gender
			mkNoun : Str -> Str -> Gender -> Noun = \sing,plural,gen -> {
					s = table {
						N_Sg => sing ;
						N_Dl => [] ;
						N_Pl => plural
					} ;
					g = gen ;
				} ;

			-- Takes the singular and plural (assumes no double)
			-- Params:
				-- Singular, eg KOXXA
				-- Double, eg KOXXTEJN
				-- Plural, eg KOXXOX
				-- Gender
			mkNoun : Str -> Str -> Str -> Gender -> Noun = \sing,dual,plural,gen -> {
					s = table {
						N_Sg => sing ;
						N_Dl => dual ;
						N_Pl => plural
					} ;
					g = gen ;
				} ;

		} ; --end of mkNoun overload

		{- ===== GENERAL VERB FUNCTIONS ===== -}

		-- Takes a verb as a string and returns the VType and root/pattern.
		-- Used in smart paradigm below and elsewhere.
		-- Params: "Mamma" (Perf Per3 Sg Masc) as string (eg KITEB or ĦAREĠ)
		-- Return: Record with v:VType, r:Root, p:Pattern
		classifyVerb : Str -> { t:VType ; r:Root ; p:Pattern } = \mamma -> case mamma of {
			-- Quad
			K@#Consonant + v1@#Vowel + T@#Consonant + B@#Consonant + v2@#Vowel + L@#Consonant => { t=Quad ; r={ K=K ; T=T ; B=B ; L=L } ; p={ v1=v1 ; v2=v2 } } ;

			-- Hollow
			K@#Consonant + v1@"a"  + B@#Consonant => { t=Hollow ; r={ K=K ; T="w" ; B=B ; L=[] } ; p={ v1=v1 ; v2="" } } ;
			K@#Consonant + v1@"ie" + B@#Consonant => { t=Hollow ; r={ K=K ; T="j" ; B=B ; L=[] } ; p={ v1=v1 ; v2="" } } ;

			-- Double
			K@#Consonant + v1@#Vowel + T@#Consonant + B@#Consonant => { t=Double ; r={ K=K ; T=T ; B="j" ; L=[] } ; p={ v1=v1 ; v2="" } } ;

			-- Weak
			K@#Consonant + v1@#Vowel + T@#Consonant + v2@#Vowel => { t=Weak ; r={ K=K ; T=T ; B="j" ; L=[] } ; p={ v1=v1 ; v2=v2 } } ;

			-- Defective
			K@#Consonant + v1@#Vowel + T@#Consonant + v2@#Vowel + B@( "għ" | "'" ) => { t=Defective ; r={ K=K ; T=T ; B="għ" ; L=[] } ; p={ v1=v1 ; v2=v2 } } ;

			-- Strong
			K@#Consonant + v1@#Vowel + T@#Consonant + v2@#Vowel + B@(#Consonant | "ġ") => { t=Strong ; r={ K=K ; T=T ; B=B ; L=[] } ; p={ v1=v1 ; v2=v2 } } ;

			-- Error :(
			_ => Predef.error ( "Unable to parse verb" )
		} ;

		-- Smart paradigm for building a Verb, by calling correct corresponding mkXXX functions
		-- Return: Verb
		mkVerb : Verb = overload {

			-- Tries to do everything just from the mamma of the verb
			-- Params:
				-- "Mamma" (Perf Per3 Sg Masc) as string (eg KITEB or ĦAREĠ)
			mkVerb : Str -> Verb = \mamma ->
				let
					class = classifyVerb mamma
				in
					case class.t of {
						Strong => mkStrong class.r class.p ;
						Defective => mkDefective class.r class.p ;
						Weak => Predef.error ( "WEAK" ) ;
						Hollow => Predef.error ( "HOLLOW" ) ;
						Double => Predef.error ( "DOUBLE" ) ;
						Quad => mkQuad class.r class.p
					} ;

			-- Same as above but also takes an Imperative of the word for when it behaves less predictably
			-- Params:
				-- "Mamma" (Perf Per3 Sg Masc) as string (eg KITEB or ĦAREĠ )
				-- Imperative Singular as a string (eg IKTEB or OĦROĠ )
				-- Imperative Plural as a string (eg IKTBU or OĦORĠU )
			mkVerb : Str -> Str -> Str -> Verb = \mamma,imp_sg,imp_pl ->
				let
					class = classifyVerb mamma
				in
					case class.t of {
						Strong => {
							s = table {
								VPerf pgn => ( conjStrongPerf class.r class.p ) ! pgn ;
								VImpf pgn => ( conjStrongImpf imp_sg imp_pl ) ! pgn ;
								VImp n =>    table { Sg => imp_sg ; Pl => imp_pl } ! n
							} ;
							o = Semitic ;
							t = Strong ;
						} ;
						Defective => {
							s = table {
								VPerf pgn => ( conjDefectivePerf class.r class.p ) ! pgn ;
								VImpf pgn => ( conjDefectiveImpf imp_sg imp_pl ) ! pgn ;
								VImp n =>    table { Sg => imp_sg ; Pl => imp_pl } ! n
							} ;
							o = Semitic ;
							t = Defective ;
						} ;
						Weak => Predef.error ( "WEAK" ) ;
						Hollow => Predef.error ( "HOLLOW" ) ;
						Double => Predef.error ( "DOUBLE" ) ;
						Quad => {
							s = table {
								VPerf pgn => ( conjQuadPerf class.r class.p ) ! pgn ;
								VImpf pgn => ( conjQuadImpf imp_sg imp_pl ) ! pgn ;
								VImp n =>    table { Sg => imp_sg ; Pl => imp_pl } ! n
							} ;
							o = Semitic ;
							t = Quad ;
						}
					} ;

		} ; --end of mkVerb overload

		{- ===== STRONG VERB ===== -}

		-- Strong verb, eg ĦAREĠ (Ħ-R-Ġ)
		-- Make a verb by calling generate functions for each tense
		-- Params: Root, Pattern
		-- Return: Verb
		mkStrong : Root -> Pattern -> Verb = \r,p ->
			let
				imp = conjStrongImp r p ;
			in {
				s = table {
					VPerf pgn => ( conjStrongPerf r p ) ! pgn ;
					VImpf pgn => ( conjStrongImpf (imp ! Sg) (imp ! Pl) ) ! pgn ;
					VImp n =>    imp ! n
				} ;
				t = Strong ;
				o = Semitic
			} ;

		-- Conjugate entire verb in PERFECT tense
		-- Params: Root, Pattern
		-- Return: Lookup table of Agr against Str
		conjStrongPerf : Root -> Pattern -> ( Agr => Str ) = \root,p ->
			let
				stem_12 = root.K + root.T + (case p.v2 of {"e" => "i" ; _ => p.v2 }) + root.B ;
				stem_3 = root.K + p.v1 + root.T + root.B ;
			in
				table {
					Per1 Sg		=> stem_12 + "t" ;	-- Jiena KTIBT
					Per2 Sg		=> stem_12 + "t" ;	-- Inti KTIBT
					Per3Sg Masc	=> root.K + p.v1 + root.T + p.v2 + root.B ;	-- Huwa KITEB
					Per3Sg Fem	=> stem_3 + (case p.v2 of {"o" => "o" ; _ => "e"}) + "t" ;	-- Hija KITBET
					Per1 Pl		=> stem_12 + "na" ;	-- Aħna KTIBNA
					Per2 Pl		=> stem_12 + "tu" ;	-- Intom KTIBTU
					Per3Pl		=> stem_3 + "u"	-- Huma KITBU
				} ;

		-- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
		-- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
		-- Return: Lookup table of Agr against Str
		conjStrongImpf : Str -> Str -> ( Agr => Str ) = \stem_sg,stem_pl ->
			table {
				Per1 Sg		=> "n" + stem_sg ;	-- Jiena NIKTEB
				Per2 Sg		=> "t" + stem_sg ;	-- Inti TIKTEB
				Per3Sg Masc	=> "j" + stem_sg ;	-- Huwa JIKTEB
				Per3Sg Fem	=> "t" + stem_sg ;	-- Hija TIKTEB
				Per1 Pl		=> "n" + stem_pl ;	-- Aħna NIKTBU
				Per2 Pl		=> "t" + stem_pl ;	-- Intom TIKTBU
				Per3Pl		=> "j" + stem_pl	-- Huma JIKTBU
			} ;

		-- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
		-- Params: Root, Pattern
		-- Return: Lookup table of Number against Str
		conjStrongImp : Root -> Pattern -> ( Number => Str ) = \root,p ->
			let
				stem_sg = case (p.v1 + p.v2) of {
					"aa" => "i" + root.K + root.T + "o" + root.B ;
					"ae" => "o" + root.K + root.T + "o" + root.B ;
					"ee" => "i" + root.K + root.T + "e" + root.B ;
					"ea" => "i" + root.K + root.T + "a" + root.B ;
					"ie" => "i" + root.K + root.T + "e" + root.B ;
					"oo" => "o" + root.K + root.T + "o" + root.B
				} ;
				stem_pl = case (p.v1 + p.v2) of {
					"aa" => "i" + root.K + "o" + root.T + root.B ;
					"ae" => "o" + root.K + "o" + root.T + root.B ;
					"ee" => "i" + root.K + "e" + root.T + root.B ;
					"ea" => "i" + root.K + "i" + root.T + root.B ;
					"ie" => "i" + root.K + "e" + root.T + root.B ;
					"oo" => "o" + root.K + "o" + root.T + root.B
				} ;
			in
				table {
					Sg => stem_sg ;	-- Inti:  IKTEB
					Pl => stem_pl + "u"	-- Intom: IKTBU
				} ;


		{- ===== DEFECTIVE VERB ===== -}

		-- Defective verb, eg SAMA' (S-M-GĦ)
		-- Make a verb by calling generate functions for each tense
		-- Params: Root, Pattern
		-- Return: Verb
		mkDefective : Root -> Pattern -> Verb = \r,p ->
			let
				imp = conjDefectiveImp r p ;
			in {
				s = table {
					VPerf pgn => ( conjDefectivePerf r p ) ! pgn ;
					VImpf pgn => ( conjDefectiveImpf (imp ! Sg) (imp ! Pl) ) ! pgn ;
					VImp n =>    imp ! n
				} ;
				t = Defective ;
				o = Semitic ;
			} ;

		-- Conjugate entire verb in PERFECT tense
		-- Params: Root, Pattern
		-- Return: Lookup table of Agr against Str
		conjDefectivePerf : Root -> Pattern -> ( Agr => Str ) = \root,p ->
			let
				stem_12 = root.K + root.T + (case p.v2 of {"e" => "i" ; _ => p.v2 }) + "j" ; -- "AGĦ" -> "AJ"
				stem_3 = root.K + p.v1 + root.T + root.B ;
			in
				table {
					Per1 Sg		=> stem_12 + "t" ;	-- Jiena QLAJT
					Per2 Sg		=> stem_12 + "t" ;	-- Inti QLAJT
					Per3Sg Masc	=> root.K + p.v1 + root.T + p.v2 + "'" ;	-- Huwa QALA'
					Per3Sg Fem	=> stem_3 + (case p.v2 of {"o" => "o" ; _ => "e"}) + "t" ;	-- Hija QALGĦET
					Per1 Pl		=> stem_12 + "na" ;	-- Aħna QLAJNA
					Per2 Pl		=> stem_12 + "tu" ;	-- Intom QLAJTU
					Per3Pl		=> stem_3 + "u"	-- Huma QALGĦU
				} ;

		-- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
		-- Params: Imperative Singular (eg IKTEB), Imperative Plural (eg IKTBU)
		-- Return: Lookup table of Agr against Str
		conjDefectiveImpf : Str -> Str -> ( Agr => Str ) = \stem_sg,stem_pl ->
			table {
				Per1 Sg		=> "n" + stem_sg ;	-- Jiena NIKTEB
				Per2 Sg		=> "t" + stem_sg ;	-- Inti TIKTEB
				Per3Sg Masc	=> "j" + stem_sg ;	-- Huwa JIKTEB
				Per3Sg Fem	=> "t" + stem_sg ;	-- Hija TIKTEB
				Per1 Pl		=> "n" + stem_pl ;	-- Aħna NIKTBU
				Per2 Pl		=> "t" + stem_pl ;	-- Intom TIKTBU
				Per3Pl		=> "j" + stem_pl	-- Huma JIKTBU
			} ;

		-- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
		-- Params: Root, Pattern
		-- Return: Lookup table of Number against Str
		conjDefectiveImp : Root -> Pattern -> ( Number => Str ) = \root,p ->
			let
				v1 = case p.v1 of { "e" => "i" ; _ => p.v1 } ;
				v_pl = case p.v1 of { "a" => "i" ; _ => "" } ; -- some verbs require "i" insertion in middle (eg AQILGĦU)
			in
				table {
					Sg => v1 + root.K + root.T + p.v2 + "'" ;	-- Inti:  AQLA' / IBŻA'
					Pl => v1 + root.K + v_pl + root.T + root.B + "u"	-- Intom: AQILGĦU / IBŻGĦU
				} ;

		{- ===== QUADRILITERAL VERB ===== -}

		-- Make a Quad verb, eg QARMEĊ (Q-R-M-Ċ)
		-- Make a verb by calling generate functions for each tense
		-- Params: Root, Pattern
		-- Return: Verb
		mkQuad : Root -> Pattern -> Verb = \r,p ->
			let
				imp = conjQuadImp r p ;
			in {
				s = table {
					VPerf pgn => ( conjQuadPerf r p ) ! pgn ;
					VImpf pgn => ( conjQuadImpf (imp ! Sg) (imp ! Pl) ) ! pgn ;
					VImp n =>    imp ! n
				} ;
				t = Quad ;
				o = Semitic ;
			} ;

		-- Conjugate entire verb in PERFECT tense
		-- Params: Root, Pattern
		-- Return: Lookup table of Agr against Str
		conjQuadPerf : Root -> Pattern -> ( Agr => Str ) = \root,p ->
			let
				stem_12 = root.K + p.v1 + root.T + root.B + (case p.v2 of {"e" => "i" ; _ => p.v2 }) + root.L ;
				stem_3 = root.K + p.v1 + root.T + root.B + root.L ;
			in
				table {
					Per1 Sg		=> stem_12 + "t" ;	-- Jiena DARDART
					Per2 Sg		=> stem_12 + "t" ;	-- Inti DARDART
					Per3Sg Masc	=> root.K + p.v1 + root.T + root.B + p.v2 + root.L ;	-- Huwa DARDAR
					Per3Sg Fem	=> stem_3 + (case p.v2 of {"o" => "o" ; _ => "e"}) + "t" ;	-- Hija DARDRET
					Per1 Pl		=> stem_12 + "na" ;	-- Aħna DARDARNA
					Per2 Pl		=> stem_12 + "tu" ;	-- Intom DARDARTU
					Per3Pl		=> stem_3 + "u"	-- Huma DARDRU
				} ;

		-- Conjugate entire verb in IMPERFECT tense, given the IMPERATIVE
		-- Params: Imperative Singular (eg ____), Imperative Plural (eg ___)
		-- Return: Lookup table of Agr against Str
		conjQuadImpf : Str -> Str -> ( Agr => Str ) = \stem_sg,stem_pl ->
			let
				prefix_dbl:Str = case stem_sg of {
					X@( "d" | "t" ) + _ => "i" + X ;
					_ => "t"
				} ;
			in
				table {
					Per1 Sg		=> "in" + stem_sg ;			-- Jiena INDARDAR
					Per2 Sg		=> prefix_dbl + stem_sg ;	-- Inti IDDARDAR
					Per3Sg Masc	=> "i" + stem_sg ;			-- Huwa IDARDAR
					Per3Sg Fem	=> prefix_dbl + stem_sg ;	-- Hija IDDARDAR
					Per1 Pl		=> "in" + stem_pl ;			-- Aħna INDARDRU
					Per2 Pl		=> prefix_dbl + stem_pl ;	-- Intom IDDARDRU
					Per3Pl		=> "i" + stem_pl			-- Huma IDARDRU
				} ;

		-- Conjugate entire verb in IMPERATIVE tense, infers vowel patterns
		-- Params: Root, Pattern
		-- Return: Lookup table of Number against Str
		conjQuadImp : Root -> Pattern -> ( Number => Str ) = \root,p ->
			table {
				Sg => root.K + p.v1 + root.T + root.B + p.v2 + root.L ;	-- Inti:  DARDAR
				Pl => root.K + p.v1 + root.T + root.B + root.L + "u"	-- Intom: DARDRU
			} ;


-- **********************************
-- 			RENEGATION ZONE
-- **********************************

		-- mkStrong : Pattern -> Root3 -> Str = \p,root ->
		  -- p.h + root.K + p.v1 + root.T + p.v2 + root.B + p.t;

{-
		-- Smart paradigm for building a Verb, by calling correct corresponding mkXXX function
		-- Params: "Mamma" (Perf Per3 Sg Masc) as string (eg "kiteb" or "ħareġ")
		-- Return: Verb
		mkVerb : Str -> Verb = \mamma -> case mamma of {
			-- _ + ( "għ" | "'" ) => mkDefective {K=K;T=T;B=B} {v1=v1;v2=v2}; -- defective
			-- _ + #Vowel => mkWeak {K=K;T=T;B=B} {v1=v1;v2=v2}; -- weak
			-- #Consonant + ( "a" | "ie" ) + #Consonant => mkHollow {K=K;T=T;B=B} {v1=v1;v2=v2}; -- hollow
			-- #Consonant + #Vowel + #Consonant + #Consonant  => mkDouble {K=K;T=T;B=B} {v1=v1;v2=v2}; -- double
			-- K@#Consonant + v1@#Vowel + T@#Consonant + v2@#Vowel + B@#Consonant => mkStrong {K=K;T=T;B=B} {v1=v1;v2=v2}; -- strong

			_ => Predef.error ( "Unable to parse verb" )
		} ;
-}

}
