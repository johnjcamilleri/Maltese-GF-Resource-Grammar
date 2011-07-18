-- ParadigmsMlt.gf: morphological paradigms
--
-- Maltese Resource Grammar Library
-- (c) 2011 John J. Camilleri [john@johnjcamilleri.com]
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

}
