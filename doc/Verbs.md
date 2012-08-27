# Maltese GF Resource Grammar: Verbs

Notes about the GF implementation of Maltese **verbs**.
This file is both a documentaion, as well as a to-do list, and will be in flux a lot.

## Checklist

1. ~~Conjugations for first-form semitic verbs in Perfect, Imperfect, and Imperative~~
1. ~~Non-semitic verbs (romance, English-loan)~~
1. ~~Polarity, e.g. _oħroġ_ vs _toħroġx_~~
1. ~~Inflection for direct & indirect object suffixes, e.g. _ħaditu_, _ġabuhielhom_~~
1. Derived forms
1. Participles - should verbs also contain a table for Active/Past Participle?
1. Irregular verbs
1. Two-place verbs (V2)

### Known issues:

1. IE-reduction when adding affixes needs to be more intelligent. See {GO pg92,100}
1. ~~Avoid triples when adding suffixes, e.g. _ħakk_ + _kom_ = _ħakkom_~~

### Test cases

When testing the verb morphology, each of these cases should be considered for the given reason(s). Ideally we will have gold standards for each.

|Verb|Class|Tests|
|:---|:----|:----|
|_kiteb_|Regular strong|Vowel changes (_kitibli_)|
|_lagħab_|Regular strong|Middle radical is 2 characters|
|_ħareġ_|Liquid-medial strong|Vowel changes (_oħroġ_)|
|_kenn_|Geminated strong|Triple n with suffix _na_|
|_ħakk_|Geminated strong|Triple k with suffix _kom_|
|_ħall_|Geminated strong|Triple l with suffix _lu_|
|_bexx_|Geminated strong|Triple x in negation|
|_waqaf_|Weak initial (assimilative)|Long vowel in Imp/Impf (_nieqaf_)|
|_wasal_|Weak initial (assimilative)|Liquid-medial|
|_sab_|Weak medial (hollow)|-|
|_żied_|Weak medial (hollow)|Middle vowel is 2 characters|
|_mexa_|Weak final (lacking)|-|
|_qata'_|Defective|Treatment of apostrophe|
|_ħarbat_|Quad strong|4 distinct radicals|
|_gemgem_|Quad strong|Repeated biradical base|
|_gerbeb_|Quad strong|Repeated C3|
|_żerżaq_|Quad strong|Repeated C1 after C2|
|_għargħax_|Quad strong|C1 repeated; C1 & C3 are 2 characters|
|_kanta_|Weak quad (integrated loan)|Italian origin _-are_: imperative is _kanta_|
|_serva_|Weak quad (integrated loan)|Italian origin _-ire_: imperative is _servi_|
|_vinċa_|Weak quad (integrated loan)|Italian origin _-ere_: imperative is _vinċi_|
|_żviluppa_|Loan|-|
|_antagonizza_|Loan|_-izza_ ending|
|_ssuġġerixxa_|Loan|_-ixxa_ ending; Double first letter|

## Classification

Verb classification according to {MDG}, {T2M} and {GM}.

- Semitic
    - Strong ("sħiħ")
        - Regular: all radicals strong & distinct, e.g. _QATEL (Q-T-L)_.
        - Liquid-Medial: C2 is liquid {MDG pg246,364; T2M pg18-19}, e.g. _ŻELAQ (Ż-L-Q)_
        - Geminated/Reduplicative/Doubled ("trux"): C2 & C3 are identical, e.g. _ĦABB (Ħ-B-B), XAMM (X-M-M), BEXX (B-X-X)_
    - Weak ("dgħajjef")
        - Assimilative ("assimilativ"): C1 is weak, e.g. _WAQAF (W-Q-F), WASAL (W-S-L)_
        - Hollow ("moħfi"): C2 is weak, long A or IE between C1 & C3, e.g. _DAM (D-W-M), SAR (S-J-R)_
        - Lacking ("nieqes"): C3 is weak, e.g. _BEKA (B-K-J), MEXA (M-X-J)_
        - Defective: C3 is silent GĦ, e.g. _BELA' (B-L-GĦ), QATA' (Q-T-GĦ)_  
          Use _kiser_ as model (or _seraq_ when C2 is liquid). {GO pg169}
          As {SA} notes, GĦ is not weak, thus these verbs are technically Strong. However, the behave inflectionally as weak verbs.
    - Quadriliteral: 4 radicals
        - Strong
            - Repeated bi-radical base, e.g. _GEMGEM (G-M-G-M)_
            - Repeated C3, e.g. _GERBEB (G-R-B-B)_
            - Repeated C1 after C2, e.g. _ŻERŻAQ (Ż-R-Ż-Q)_
            - Added C4 to triradical base, e.g. _ĦARBAT (Ħ-R-B-T)_
        - Weak-final: C4 weak, e.g. _PINĠA (P-N-Ġ-J)_  
        These are generally strongly-integrated Romance verbs, e.g. _KANTA_ from Italian _cantare_.
    - Irregular: _ĦA, TA, RA, MAR, ĠIE, QAL, KIEL, KELLU, IDDA, EMMEN, IŻŻA, JAF, KIEN_
- Romance
    - Strongly-integrated, e.g. _KANTA, SERREP, BANDAL, BAQQAN_  
    From Italian _-are_ (e.g. _KANTA_), _-ere_ (e.g. _VINĊA_), _-ire_ (e.g. _SERVA_).  
    These are covered by the semitic paradigms above, they merely have a different etymology {T2M}.
    - Loosely-integrated. e.g. _ŻVILUPPA, IPPERFEZZJONA, ANTAGONIZZA, IDDIŻUBBIDIXXA_
- English loan words. e.g. _IBBUKJA, IWWELDJA, ERTJA, IFFITTJA_

{SA} clasifies loan verbs as follows:

- Type 1:
    - Verbs like _KANTA_ - modelled on _qara_ (based on imperative: _kanta/kantaw_, _aqra/aqraw_)
    - Doubled initial consonant, e.g. _IKKONVINĊA, IMMONITERJA, ITTAJPJA_
- Type 2:
    - Verbs like _FALLA_ - modelled on _beka_ (based on imperative: _falli/fallu_, _ibki, ibku_)
    - Italian ending _-isco_, e.g. _ISSUĠĠERIXXA_
- Type 3:
    - Fully integrated into Semitic pattern. Conjugated as triliteral 2nd form verb/quadriliteral verb. e.g. _SERREP_

**Questions**

- Is _WERŻAQ_ weak or strong? {T2M app} says strong, {GM pg48} says weak.


## Pronominal suffixes

A verb can have the following pronominal suffix combinations:

- None, e.g. _FTAĦT_
- Direct Object, e.g. _FTAĦTU_
- Indirect Object, e.g. _FTAĦTLU_
- Direct Object + Indirect Object, .e.g _FTAĦTHULU_  
  In this case the D.O. is necessarily 3rd person (Masc/Fem/Plural).
  
### Variations

For liquid-medial verbs some variations seem to exist, when adding pronominal suffixes.
The following are standard:

- noħorġilkom
- noħorġilha
- noħorġilhom
- jisirqilhom

However this alternate spelling seems to be relatively accepted (likely for some verbs more than others):

- noħroġilkom
- noħroġilha
- noħroġilhom
- jisraqilhom

However in the RG we are currently considering only the first case. See [this discussion](https://www.facebook.com/groups/246657308743181/permalink/351277908281120/).
The code for having this as a variant is there, but commented out.

## Polarity

Verb inflects for polarity:

- Positive, e.g. _FETAĦ_
- Negative, e.g. _[MA] FETAĦX_  
  The negative form typically follows the clitic _ma_, although there exist constructions where this is not the case, e.g. _mur ara jekk fetaħx_

## Tense

### Basic definitions

Mood:

- Indicative
- Imperative, e.g. _ISRAQ_  
  "The imperative is formed from the imperfect form of the verb" {MDG pg238}

Derived moods:

- Conditional, e.g. _JEKK TIĠI_
- Subjunctive, e.g. _BIEX INKELLEM_

Tense-aspect:

- Perfective, e.g. _SERAQ_
- Imperfective, e.g. _JISRAQ_

### Maltese tenses

Tenses according to {SA} and {GM}.

|Aux1|Aux2|Main verb|Meaning (name)|
|:---|:---|:--------|:-------------|
|-   |-   |sraqt    |simple past (Perfective)|
|kont|-   |sraqt    |past perfect (Pluperfett)|
|nkun|-   |sraqt    |future perfect|
|-   |-   |nisraq   |habitual present (Imperfective)|
|kont|-   |nisraq   |habitual past (Past Imperfective)|
|-   |qed |nisraq   |present progressive (Present Continuous)|
|kont|qed |nisraq   |past progressive (Past Continuous)|
|nkun|-/qed|nisraq  |future progressive (Future Imperfective)|
|-   |sa  |nisraq   |prospective        |
|kont|sa  |nisraq   |past prospective   |
|nkun|sa  |nisraq   |future prospective |

**Notes**

- _Future_ can also be expressed by means of: Imperfective + temporal adverb, e.g. _GĦADA MMUR NIXTRI_
- Conditional clauses
    - Counterfactual conditional with past reference: Perfective + Past Imperfective, e.g.:  
    _Kieku rbaħt l-lotterija kont nixtri dar._
    - Counterfactual with non-past time reference: Jekk/Kieku + Imperfective, e.g.:  
    _Jekk nirbaħ l-lotterija nixtri dar._
    - Imperfective with future meaning:  
    _Kieku nirbaħ l-lotterija nixtri dar._
- Future habituality is expressed using bare imperfective/prospective with adequate future adverbial {TAS pg335}
- A few verbs in Maltese have no perfective form, and thus use _kien_ + Imperfective for simple/habitual past:
    - _kont naf_
    - _kont nixbaħ_
    - _kien jisimni_
- Progressive can be:
    - Synthetic, e.g. _nieżel_ (Only possible when verb has an active participial form.) {TAS pg328}
    - Analytic, e.g. _qed jinżel_
- Some more complex (and lesser used) tense-aspect constructions:
    - _Pawlu kien dejjem ikun jilgħab il-futboll_
    - _Pawlu kien dejjem ikun qed jilgħab il-futboll_
    - _Pawlu kien dejjem ikun sa jilgħab il-futboll_
    - _Pawlu kien dejjem ikun lagħab il-futboll_
- Still/yet:
    - Pseudo-verb _għad_ + Imperfective:
        - _Pawlu għadu jiekol_
        - _Pawlu għadu qed jiekol_
        - _Pawlu għadu sa jiekol_
    - _għad_ + _kemm_ + Perfective: _Pawlu għadu kemm qam_
- Insistence/repetition:
    - _Pawlu joqgħod idejjaqni_
    - _Pawlu jibqa' jaħdem tard_
    - _Pawlu jkompli jispara fuq kull għasfur_
- {GM} also notes two additional constuctions:
    - Perfective present continuous, e.g. _ILNI NAĦDEM SIEGĦA_
    - Pluperfett kontinwu, e.g. _JIEN KONT QGĦADT NAĦDEM_

### The RGL common tense-polarity system

RGL tenses and how they are expressed in Maltese (refer to table above):

| Anteriority | Temporal Order | Polarity | Description | Example |
|:------------|:---------------|:---------|:------------|:--------|
|Simultaneous | Present        | Positive |Imperfective|_jien norqod_|
|Simultaneous | Present        | Negative |            |_jien ma norqodx_|
|Simultaneous | Past           | Positive |Perfective|_jien irqadt_|
|Simultaneous | Past           | Negative |          |_jien ma rqadtx_|
|Simultaneous | Future         | Positive |Prospective|_jien se norqod_|
|Simultaneous | Future         | Negative |           |_jien minix se norqod_|
|Simultaneous | Conditional    | Positive |Past Imperfective|_jien kont norqod [kieku]_|
|Simultaneous | Conditional    | Negative |                 |_jien ma kontx norqod [kieku]_|
|Anterior     | Present        | Positive |_Same as Sim Past Pos_|     |
|Anterior     | Present        | Negative |_Same as Sim Past Neg_|     |
|Anterior     | Past           | Positive |Past Perfect|_jien kont irqadt_|
|Anterior     | Past           | Negative |            |_jien ma kontx irqadt_|
|Anterior     | Future         | Positive |Future Perfect|_jien inkun irqadt_|
|Anterior     | Future         | Negative |              |_jien ma nkunx irqadt_(?)|
|Anterior     | Conditional    | Positive |Past prospective|_jien kont se norqod [kieku]_|
|Anterior     | Conditional    | Negative |                |_jien ma kontx se norqod [kieku]_|

## Derived forms

All information from {MDG pg247}.

### Triliteral roots

| Form | Process | Example | Description |
|:-----|:--------|:--------|:------------|
|I| - | _kiteb_ | Base form |
|II| Reduplication/gemination of second radical | _daħħal_ | In general, intransitive Form I verbs are made transitive/causative. |
|III| Long first vowel | _bierek_ | Similar to Form II, when reduplication of C2 is not possible. |
|IV| - | _wera_ | Empty class. |
|V| Prefix _t-_ to Form II | _farrak_ | Intransitive. Passive or reflexive. |
|VI| Prefix of _t-_ to Form III  | _tbierek_ | Same as Form V. |
|VII| Prefix of _n-_ to Form I | _nkiteb_ | In general, transitive Form I verbs are made intransitive.  |
|VIII| Infix _-t-_ after C1 of Form 1 | _ftiehem_ | Intransitive (like V, VI, VII). |
|〃| Prefix _nt-_ to Form 1 | _ntlaħaq_ | 〃 |
|〃| Infix _n-t-_ to Form 1 | _nxteħet_ | 〃 |
|IX| Structure `1 2v: 3` | _ċkien_ | Change of state. |
|X| Prefix _st-_ | _stagħġeb_ | - |

### Quadriliteral roots

| Form | Process | Example | Description |
|:-----|:--------|:--------|:------------|
|I| - | _ħarbat_ | Base form |
|II| Prefix _t-_ | _tħarbat_ | Intransitive. Passive or reflexive. |
|-| Prefix _m-_ | _mfarfar_ | Past participle. |
|-| - | _tfarfir_ | Verbal noun. |

