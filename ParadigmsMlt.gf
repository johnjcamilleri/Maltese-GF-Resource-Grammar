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
