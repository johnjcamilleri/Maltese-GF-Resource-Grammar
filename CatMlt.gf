-- CatMlt.gf: the common type system
--
-- Maltese Resource Grammar Library
-- (c) 2011 John J. Camilleri [john@johnjcamilleri.com]
-- Licensed under LGPL

concrete CatMlt of Cat = CommonX ** open ResMlt, Prelude, ParamX in {

	flags optimize=all_subs ;

{-
	lincat
		S  = {s : Str} ;
		Cl = {s : ResMlt.Tense => Bool => Str} ;
		NP = ResMlt.NP ; -- {s : Case => {clit,obj : Str ; isClit : Bool} ; a : Agr} ;
		VP = ResMlt.VP ; -- {v : Verb ; clit : Str ; clitAgr : ClitAgr ; obj : Agr => Str} ;
		--AP = {s : Gender => Number => Str ; isPre : Bool} ;
		CN = ResMlt.Noun ; -- {s : Number => Str ; g : Gender} ;
		Det = {s : Gender => Case => Str ; n : Number} ;
		N = ResMlt.Noun ; -- {s : Number => Str ; g : Gender} ;
		--A = ResMlt.Adj ; -- {s : Number => Str ; isPre : Bool} ;
		V = ResMlt.Verb ;
		V2 = ResMlt.Verb ** {c : Case} ;
		AdA = {s : Str} ;
		Pol = {s : Str ; b : Bool} ;
		Tense = {s : Str ; t : ResMlt.Tense} ;
		Conj = {s : Str ; n : Number} ;
-}

}
