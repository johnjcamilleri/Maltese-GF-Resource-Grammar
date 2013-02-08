# Maltese GF Resource Grammar: Nouns

Notes about the implementation of Maltese **nouns**.
This file is both a documentation, as well as a to-do list, and will be in flux a lot.

## Checklist

1. ~~Different number types (sing, collective, dual, determinate and indeterminate plural)~~
1. ~~Gender~~
1. Inflections for possession, e.g. _idi_ or _widnejhom_
1. Animacy, e.g. _karozza_ is always feminine, but you could have both _qattus_ and _qattusa_, _spiżjar_ or _spiżjara_
1. Smart paradigm

## Number

_Note: NNQ = Non-numerically quantifiable_

- Singular
  - Singulative (1, >10)
  - Collective (NNQ)
- Dual ("għadd imtenni") (2)
- Plural
  - Determinate (2-10)
  - Indeterminate (NNQ)
  
### Typical combinations

Nouns typically have one of the following combinations of number forms  (* marks base form):

- Singulative, no plural!
- Singulative*, Plural
- Singulative* (1), Dual (2), Plural (>2)
- Singulative (1, >10), Collective* (NNQ), Determinate Plural (2-10)
- Singulative, Collective*, Determinate Plural, Indeterminate Plural -> very few nouns have these 4 forms

#### Examples
  
| English    | Singular  | Collective | Dual        | Det. Plural  | Ind. Plural |
|------------|-----------|------------|-------------|--------------|-------------|
| blood      |           | _demm_     |             | _dmija_      |             |
| butter     |           | _butir_    |             | _butirijiet_ |             |
| cow        | _baqra_   | _baqar_    | _baqartejn_ |              |             |
| eye        | _għajn_   |            | _għajnejn_  | _għajnejn_   | _għejun_    |
| fingernail | _difer_   |            | _difrejn_   | _dwiefer_    |             |
| fog        |           | _ċpar_     |             |              |             |
| foot       | _sieq_    |            | _saqajn_    | _saqajn_     |             |
| gold       |           | _deheb_    |             | _dehbijiet_  |             |
| grass      | _ħaxixa_  | _ħaxix_    |             |              | _ħxejjex_   |
| guts       | _musrana_ |            |             | _musraniet_  | _msaren_    |
| hair       | _xagħar_  |            |             | _xagħariet_  | _xgħur_     |
| hand       | _id_      |            | _idejn_     | _idejn_      |             |
| iron       | _ħadida_  | _ħadid_    |             | _ħadidiet_   | _ħdejjed_   |
| knee       | _rkoppa_  |            | _rkopptejn_ | _rkoppiet_   |             |
| leaf       | _werqa_   | _weraq_    | _werqtejn_  | _werqiet_    |             |
| leather    | _ġilda_   | _ġild_     |             | _ġildiet_    | _ġlud_      |
| leg        | _riġel_   |            | _riġlejn_   |              |             |
| liver      | _fwied_   |            |             |              | _ifdwa_     |
| meat       | _laħam_   |            |             | _laħmiet_    | _laħmijiet_ |
| milk       |           | _ħalib_    |             | _ħalibijiet_ | _ħlejjeb_   |
| person     |           | _persuna_  |             | _persuni_    |             |
| road       | _triq_    |            |             | _triqat_     | _toroq_     |
| rock       | _blata_   | _blat_     |             | _blatiet_    | _blajjiet_  |
| sand       | _ramla_   | _ramel_    |             | _ramliet_    | _rmiel_     |
| sea        | _baħar_   |            | _baħrejn_   | _ibħra_      |             |
| sheep      | _nagħġa_  | _nagħaġ_   |             | _nagħġiet_   |             |
| snow       |           | _borra_    |             |              |             |
| stone      | _ġebla_   | _ġebel_    |             | _ġebliet_    | _ġbiel_     |
| tooth      | _sinna_   |            |             | _sinniet_    | _snien_     |
| tree       | _siġra_   | _siġar_    |             | _siġriet_    |             |
| wind       | _riħ_     |            |             | _rjieħ_      | _rjiħat_    |
| wine       |           | _nbid_     |             |              | _nbejjed_   |
| worm       | _dudu_    | _dud_      |             | _dudiet_     | _dwied_     |
| year       | _sena_    |            | _sentejn_   | _snin_       |             |

### Morphological processes for plurals

  - Sound (eternal/affix), e.g. FERGĦA -> FERGĦAT
  - Broken (internal), e.g. FERGĦA -> FRIEGĦI
  - Plural of Plural, e.g. TARF -> TRUF -> TRUFIJIET
  - Irregular, e.g. MARA -> NISA
  - Foreign, e.g. KARTI, PRATTIĊI, TELEVIXINS

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
