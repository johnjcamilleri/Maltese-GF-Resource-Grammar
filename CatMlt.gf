-- CatMlt.gf: the common type system
--
-- Maltese GF Resource Grammar
-- John J. Camilleri 2011 -- 2013
-- Angelo Zammit 2012
-- Licensed under LGPL

concrete CatMlt of Cat = CommonX ** open ResMlt, Prelude in {

  flags
    optimize=all_subs ;

  lincat

-- Tensed/Untensed

    S  = {s : Str} ;
    QS = {s : QForm => Str} ;
    RS = {s : Agr => Str} ;
    SSlash = {s : Str ; c2 : Str} ; -- not sure if we need c2

-- Sentence

    Cl = Clause ;
    ClSlash = Clause ** {c2 : Str} ; -- not sure if we need c2
    Imp = {s : Polarity => Number => Str} ;

-- Question

    QCl = QClause ;
    IP = {s : Str ; n : Number} ;
    IComp = {s : Str} ;
    IDet = {s : Str} ;
    IQuant = {s : Str} ;

-- Relative

    RCl = RClause ;
    RP  = {s : Str} ;
    -- RCl = {
    --   s : ResMlt.Tense => Anteriority => Polarity => Agr => Str ;
    --   c : NPCase
    --   } ;
    -- RP = {s : RCase => Str ; a : RAgr} ;

-- Verb

    VP = VerbPhrase ;
    VPSlash = VerbPhrase ;
    Comp = {s : Agr => Str} ;

-- Adjective

    AP = {s : GenNum => Str ; isPre : Bool} ;

-- Noun

    CN = Noun ;
    NP = NounPhrase ;
    Pron = Pronoun ;

    Det = Determiner ;
    Predet = {s : Str} ;
    Quant = Quantifier ;

    -- [AZ]
    Num = {
      s : NumCase => Str ;
      n : NumForm ;
      hasCard : Bool ;
      -- isNum : Bool ;
      } ;

    -- [AZ]
    Ord = {
      s : NumCase => Str ;
    --   s : NPCase => GenNum => Str ;
    --   hasBSuperl : Bool
      } ;

    -- [AZ]
    Card = {
      s : NumCase => Str ;
      n : NumForm ;
      } ;

-- Numeral

    -- Cardinal or ordinal in WORDS (not digits)
    Numeral = {
      s : CardOrd => NumCase => Str ;
      n : NumForm -- number to be "treated as", e.g. 103 has n=Num3_10
    } ;

    -- Cardinal or ordinal in DIGITS (not words)
    Digits = {
      s : NumCase => Str ;      -- No need for CardOrd, i.e. no 1st, 2nd etc in Maltese
      n : NumForm ;
      tail : DTail
    };

-- Structural

    Conj = {s1,s2 : Str} ;
    Subj = {s : Str} ;
    Prep = Preposition ;

-- Open lexical classes, e.g. Lexicon

    V, VS, VQ, VA = Verb ;
    V2, V2A, V2Q, V2S = Verb ** {prep : Prep} ;
    VV = Verb ;
    V3, V2V = Verb ** {prep1,prep2 : Prep} ; -- ** {typ : VVType} ;

    A  = Adjective ;
    A2 = Adjective ** {prep : Prep} ;

    N  = Noun ;
    N2 = Noun ** {c2 : Prep} ;
    N3 = Noun ** {c2, c3 : Prep} ;
    PN = ProperNoun ;

}
