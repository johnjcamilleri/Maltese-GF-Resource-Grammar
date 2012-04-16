# Maltese GF Resource Grammar: Nouns
_John J. Camilleri, 2009-2012_  
_Last updated: 2012-04-16_

Notes about the implementation of Maltese **nouns**.
This file is both a documentaion, as well as a to-do list.

## Number

_Note: NNQ = Non-numerically quantifiable_

- Singular
  - Singulative (1, >10)
  - Collective (NNQ)
- Dual (2)
- Plural
  - Determinate (2-10)
  - Indeterminate (NNQ)

### Morphological processes for plurals

  - Sound (eternal/affix), e.g. FERGĦA -> FERGĦAT
  - Broken (internal), e.g. FERGĦA -> FRIEGĦI
  - Plural of Plural, e.g. TARF -> TRUF -> TRUFIJIET
  - Irregular, e.g. MARA -> NISA
  - Foreign, e.g. KARTI, PRATTIĊI, TELEVIXINS

### Typical combinations

Nouns typically have one of the following combinations of number forms  (* marks base form):

- Singulative, no plural!
- Singulative*, Plural
- Singulative* (1), Dual (2), Plural (>2)
- Singulative (1, >10), Collective* (NNQ), Determinate Plural (2-10)
- Singulative, Collective*, Determinate Plural, Indeterminate Plural -> very few nouns have these 4 forms

## Case

### As defined in Grammatika Maltija, p132

    Case =
        Nominative  -- referent as subject, eg IT-TARBIJA ...
      | Genitive    -- referent as possessor, eg ... TAT-TARBIJA
      | Accusative  -- referent as direct object
      | Dative    -- referent as indirect object, eg ... LIT-TARBIJA
      | Ablative    -- referent as instrument, cause, location, source or time, eg ... MINN TARBIJA
      | Vocative    -- referent being adressed, eg AA TARBIJA (lol)
    ;
    
### As defined by me

    -- Noun cases (note my examples include DEFINITE ARTICLE)
    -- Commented lines mean that noun iflection is unchanged, not that the case does not occur in Maltese!
    Case =
    --  Absessive    -- lack or absence of referent (MINGĦAJR)
    --| Ablative    -- referent as instrument, cause, location, source or time
    --| Absolutive  -- subject of intransitive or object of transitive verb (in ergative-absolutive languages)
    --| Accusative  -- referent as direct object (in nominative-accusative languages)
    --| Allative    -- motion towards referent (LEJN)
    --| Additive    -- synonym of Allative (above)
      | Benefactive    -- referent as recipient, eg GĦAT-TARBIJA. cf Dative.
    --| Causative    -- referent as the cause of a situation (MINĦABBA)
      | Comitative  -- with, eg MAT-TARBIJA
      | Dative    -- referent as indirect object, eg LIT-TARBIJA. cf Benefactive.
    --| Delative    -- motion downward from referent
      | Elative    -- motion away from referent, eg MIT-TARBIJA
      | Equative    -- likeness or identity, eg BĦAT-TARBIJA
    --| Ergative    -- subject of transitive verb (in ergative-absolutive languages)
    --| Essive    -- temporary state / while / in capacity of (BĦALA)
      | Genitive    -- referent as possessor, eg TAT-TARBIJA
    --| Illative    -- motion into / towards referent, eg SAT-TARBIJA. cf Allative.
      | Inessive    -- within referent, eg ĠOT-TARBIJA, FIT-TARBIJA
      | Instrumental  -- referent as instrument, eg BIT-TARBIJA. cf Ablative.
      | Lative    -- motion up to referent, eg SAT-TARBIJA
    --| Locative    -- location at referent
      | Nominative  -- referent as subject, eg IT-TARBIJA
    --| Partitive    -- partial nature of referent
    --| Prolative    -- motion along / beside referent
    --| Superessive  -- on / upon (FUQ)
    --| Translative  -- referent noun or adjective as result of process of change
    --| Vocative    -- referent being adressed, eg AA TARBIJA (lol)
    ;

## Other

### Gender

Different gender treatment for different number forms; gender is somewhat inherent but can be "overridden".

Gender inflection for animate nominals

- ĦABIB/ĦABIBA, ĦIJA/OĦTI but ĦUTI SUBIEN / ĦUTI TFAJLIET
- QATTUS/QATTUSA, BODBOD/MOGĦŻA but QANFUD RAĠEL / QANFUD MARA

### Common plurals

Loss of information in plural

- ĦU/OĦT but AĦWA
- TIFEL/TIFLA but TFAL

### Collectives

With collectives, I often put the female collective as the singulative of the same entry. Maybe that's wrong? eg ĠILD / ĠILDA

### Diminutive

e.g. ĠOBNA -> ĠBEJNA
Is it just a different word? It's probably not common enough to introduce a parameter.
