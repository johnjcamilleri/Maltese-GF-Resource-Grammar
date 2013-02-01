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

    -- S  = {s : Str} ;
    -- QS = {s : QForm => Str} ;
    -- RS = {s : Agr => Str ; c : NPCase} ; -- c for it clefts
    -- SSlash = {s : Str ; c2 : Str} ;

-- Sentence

    Cl = {s : Tense => Anteriority => Polarity => Str} ;
    -- ClSlash = {
    --   s : ResMlt.Tense => Anteriority => Polarity => Order => Str ;
    --   c2 : Str
    --   } ;
    -- Imp = {s : Polarity => ImpForm => Str} ;

-- Question

    -- QCl = {s : ResMlt.Tense => Anteriority => Polarity => QForm => Str} ;
    -- IP = {s : NPCase => Str ; n : Number} ;
    -- IComp = {s : Str} ;    
    -- IDet = {s : Str ; n : Number} ;
    -- IQuant = {s : Number => Str} ;

-- Relative

    -- RCl = {
    --   s : ResMlt.Tense => Anteriority => Polarity => Agr => Str ; 
    --   c : NPCase
    --   } ;
    -- RP = {s : RCase => Str ; a : RAgr} ;

-- Verb

    VP = ResMlt.VP ;
    VPSlash = ResMlt.VP ;
    -- Comp = {s : Agr => Str} ;

-- Adjective

    AP = {s : GenNum => Str ; isPre : Bool} ;

-- Noun

    CN = Noun ;
    NP = NounPhrase ;
    Pron = Pronoun ;

    Det = {s : Str ; n : Num_Number ; hasNum : Bool ; isPron : Bool} ;
    -- [AZ]
    -- Det = {
    --   s : NPCase => Gender => Num_Case => Str ;
    --   s2 : NPCase => Gender => Str ; -- tieghi (possesive pronoun)
    --   -- size : Num_Size ; -- One (agreement feature for noun)
    --   isNum : Bool ; -- True (a numeral is present)
    --   isDemo : Bool ; -- True (is a demostrative)
    --   isDefn : Bool ;-- True (is definite)
    --   } ;

    -- Predet = {s : Str} ;

    Quant = {s : Bool => Num_Number => Str ; isPron : Bool} ;
    -- [AZ]
    -- Quant = {
    --   s : NPCase => Gender => Num_Number => Str ;
    --   s2 : NPCase => Gender => Num_Number => Str ;
    --   isDemo : Bool ;
    --   isDefn : Bool ;
    --   } ;

    -- [AZ]
    -- Card = {
    --   s : Num_Case => Str ;
    --   n : Num_Number ;
    --   size : Num_Size
    --   } ;

    -- [AZ]
    -- Ord = {
    --   s : NPCase => GenNum => Str ;
    --   hasBSuperl : Bool
    --   } ;

    -- [AZ]
    Num = {
      s : Num_Case => Str ;
      n : Num_Number ;
      hasCard : Bool ;
      -- isNum : Bool ;
      } ;

-- Numeral

    -- Cardinal or ordinal in WORDS (not digits)
    Numeral = {
      s : CardOrd => Num_Case => Str ;
      n : Num_Number
    } ;

    -- Cardinal or ordinal in DIGITS (not words)
    Digits = {
      s : Str ;      -- No need for CardOrd, i.e. no 1st, 2nd etc in Maltese
      n : Num_Number ;
      tail : DTail
    };


-- Structural

--     Conj = {s1,s2 : Str ; n : Number} ;
-- ---b    Conj = {s : Str ; n : Number} ;
-- ---b    DConj = {s1,s2 : Str ; n : Number} ;
--     Subj = {s : Str} ;
    Prep = {s : Str} ;

-- Open lexical classes, e.g. Lexicon

    V, VS, VQ, VA = Verb ;
    V2, V2A, V2Q, V2S = Verb ; -- ** {c2 : Str} ;
    V3 = Verb ; -- ** {c2, c3 : Str} ;
    -- VV = {s : VVForm => Str ; typ : VVType} ;
    -- V2V = Verb ** {c2,c3 : Str ; typ : VVType} ;

    A = Adjective ** {hasComp : Bool} ; -- Does the adjective have a comparative form (e.g. ISBAĦ)?
--    A2 = Adjective ** {c2 : Str} ;

    N, N2, N3 = Noun ;
    PN = ProperNoun ;

}
