-- ParadigmsMlt.gf: morphological paradigms
--
-- Maltese Resource Grammar Library
-- John J. Camilleri, 2011
-- Licensed under LGPL

--# -path=.:../abstract:../../prelude:../common

resource ParadigmsMlt = open
	Predef,
	Prelude,
	MorphoMlt,
	OrthoMlt,(ResMlt=ResMlt),
	CatMlt
	in {

	flags optimize=noexpand;  coding=utf8 ;


	oper

		{- ===== Noun Paradigms ===== -}

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





		{- ===== Verb paradigms ===== -}

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
				o = Semitic
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



}
