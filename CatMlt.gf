-- Maltese Resource Grammar Library
-- (c) 2011 John J. Camilleri [john@johnjcamilleri.com]
-- Licensed under LGPL

concrete CatMlt of Cat = CommonX ** open ResMlt, Prelude, ParamX in {

	flags optimize=all_subs ;

	lincat
		V2 = Verb ;
		V = Verb ;
		N = Noun ;

}
