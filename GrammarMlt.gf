-- GrammarMlt.gf: common syntax
--
-- Maltese Resource Grammar Library
-- (c) 2011 John J. Camilleri [john@johnjcamilleri.com]
-- Licensed under LGPL

--# -path=.:../abstract:../common:../prelude

concrete GrammarMlt of Grammar =
  NounMlt,
  VerbMlt,
  AdjectiveMlt,
  AdverbMlt,
  NumeralMlt,
  SentenceMlt,
  QuestionMlt,
  RelativeMlt,
  ConjunctionMlt,
  PhraseMlt,
  TextX - [Utt],
  StructuralMlt,
  IdiomMlt
  ** {

	flags coding=utf8 ;

}
