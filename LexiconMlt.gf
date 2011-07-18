-- Maltese Resource Grammar Library
-- (c) 2011 John J. Camilleri [john@johnjcamilleri.com]
-- Licensed under LGPL

--# -path=.:../abstract:../common:../prelude

concrete LexiconMlt of Lexicon = CatMlt **
	open ParadigmsMlt, ResMlt, Prelude in {

	flags optimize=values ; coding=utf8 ;

	lin
		{- ===== VERBS ===== -}

		cut_V2 = mkVerb "qata'" "aqta'" "aqtgħu" ;
		write_V2 = mkVerb "kiteb" ;
		break_V2 = mkVerb "kiser" ;
		find_V2 = mkVerb "sab" ;
		throw_V2 = mkVerb "tefa'" ;
		hear_V2 = mkVerb "sama'" "isma'" "isimgħu" ;
		fear_V2 = mkVerb "beża'" ;
		pray_V = mkVerb "talab" "itlob" "itolbu"
		understand_V2 = mkVerb "fehem" ;
		pull_V2 = mkVerb "ġibed" ;
		walk_V = mkVerb "mexa'" ;

		die_V = mkVerb "miet" ;
		die_V = mkVerb "qarmeċ" ;


		{- ===== NOUNS ===== -}

		airplane_N = mkNoun "ajruplan" Masc ;
		apple_N = mkNoun "tuffieħa" Fem ;

} ;
