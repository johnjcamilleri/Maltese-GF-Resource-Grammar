-- Maltese Resource Grammar Library
-- (c) 2011 John J. Camilleri [john@johnjcamilleri.com]
-- Licensed under LGPL

--# -path=.:../abstract:../common:../prelude

concrete LangMlt of Lang =
  GrammarMlt,
  LexiconMlt
  ** {

  flags startcat = Phr ; unlexer = text ; lexer = text ; coding = utf8 ;

}
