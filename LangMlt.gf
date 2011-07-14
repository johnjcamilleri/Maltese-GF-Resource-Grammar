--# -path=.:../abstract:../common:../prelude

concrete LangMlt of Lang = 
  GrammarMlt,
  LexiconMlt
  ** {

  flags startcat = Phr ; unlexer = text ; lexer = text ; coding = utf8 ;

}
