# Maltese GF Resource Grammar: Verbs

Notes about the GF implementation of Maltese **verbs**.
This file is both a documentaion, as well as a to-do list, and will be in flux a lot.

## Checklist

1. ~~Conjugations for first-form semitic verbs in Perfect, Imperfect, and Imperative~~
1. Derived-form verbs
1. Non-semitic verbs (romance, English-loan)
1. ~~Polarity, e.g. _oħroġ_ vs _toħroġx_~~
1. ~~Inflection for direct & indirect object suffixes, e.g. _ħaditu_, _ġabuhielhom_~~
1. Two-place verbs (V2)

## Classification

Verb classification according to {MDG}, {T2M} and {GM}.

- Semitic
    - Strong ("sħiħ")
        - Regular: all radicals strong & distinct, e.g. _QATEL (Q-T-L)_.
        - Liquid-Medial: C2 is liquid {MDG pg246,364; T2M pg18-19}, e.g. _ŻELAQ (Ż-L-Q)_
        - Reduplicative/Doubled/Geminated ("trux"): C2 & C3 are identical, e.g. _ĦABB (Ħ-B-B), XAMM (X-M-M), BEXX (B-X-X)_
        - Quadriliteral: 4 radicals
            - Repeated bi-radical base, e.g. _GEMGEM (G-M-G-M)_
            - Repeated C3, e.g. _GERBEB (G-R-B-B)_
            - Repeated C1 after C2, e.g. _ŻERŻAQ (Ż-R-Ż-Q)_
            - Added C4 to triradical base, e.g. _ĦARBAT (Ħ-R-B-T)_
    - Weak ("dgħajjef")
        - Assimilative ("assimilativ"): C1 is weak, e.g. _WAQAF (W-Q-F), WASAL (W-S-L)_
        - Hollow ("moħfi"): C2 is weak, long A or IE between C1 & C3, e.g. _DAM (D-W-M), SAR (S-J-R)_
        - Weak-Final ("nieqes"): C3 is weak, e.g. _BEKA (B-K-J), MEXA (M-X-J)_
        - Defective: C3 is silent GĦ, e.g. _BELA' (B-L-GĦ), QATA' (Q-T-GĦ)_  
          Use _kiser_ as model (or _seraq_ when C2 is liquid). {GO pg169}
        - Quadriliteral ("kwadrilitteru"): 4 radicals with C4 weak, e.g. _PINĠA (P-N-Ġ-J)_
    - Irregular: _ĦA, TA, RA, MAR, ĠIE, QAL, KIEL, KELLU, IDDA, EMMEN, IŻŻA, JAF, KIEN_
- Romance
    - Strongly-integrated, e.g. _KANTA, SERREP, BANDAL, BAQQAN_  
    From Italian _-are_ (e.g. _KANTA_), _-ere_ (e.g. _VINĊA_), _-ire_ (e.g. _SERVA_).  
    These are covered by the semitic paradigms above, they merely have a different etymology {T2M}.
    - Loosely-integrated. e.g. _ŻVILUPPA, IPPERFEZZJONA, ANTAGONIZZA, IDDIŻUBBIDIXXA_
- English loan words. e.g. _IBBUKJA, IWWELDJA, ERTJA, IFFITTJA_


### Uncertainties

- Is _WERŻAQ_ weak or strong? {T2M app} says strong, {GM pg48} says weak.


## Pronominal suffixes

Verb can have the following pronominal suffix combinations:

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

This section taken from {GM}

### Basics

Mood:

- Indicative
- Imperative, e.g. _ISRAQ_  
"The imperitive is formed from the imperfect form of the verb" {MDG pg238}

Derived moods:

- Conditional, e.g. _JEKK TIĠI_
- Subjunctive, e.g. _BIEX INKELLEM_

Tense-aspect:

- Perfective, e.g. _SERAQ_
- Imperfective, e.g. _JISRAQ_

### Compound tenses

- Present continuous, e.g. _JIEN QIEGĦED NAĦDEM_
- Past continuous, e.g. _JIEN KONT QIEGĦED NAĦDEM_
- Future continuous, e.g. _JIEN INKUN QIEGĦED NAĦDEM_
- Perfective present continuous, e.g. _ILNI NAĦDEM SIEGĦA_
- Pluperfett kontinwu, e.g. _JIEN KONT QGĦADT NAĦDEM_
- Past imperfective, e.g. _JIEN KONT NAĦDEM_
- Pluperfett, e.g. _JIEN KONT ĦDIMT_
- Future imperfective, e.g. _JIEN INKUN NAĦDEM_
- Future perfective, e.g. _JIEN INKUN ĦDIMT_

### The RGL common tense-polarity system

RGL tenses and how they are expressed in Maltese:

| Anteriority | Temporal Order | Polarity | Description | Example |
|:------------|:---------------|:---------|:------------|:--------|
|Simultaneous | Present        | Positive |Imperfective|_jien norqod_|
|Simultaneous | Present        | Negative |            |_jien ma norqodx_|
|Simultaneous | Past           | Positive |Perfective|_jien irqadt_|
|Simultaneous | Past           | Negative |          |_jien ma rqadtx_|
|Simultaneous | Future         | Positive |Active participle SEJJER (SA/SE/SER/ĦA) + Imperfective|_jien sejjer norqod_|
|Simultaneous | Future         | Negative |                                                      |_jien minix sejjer norqod_|
|Simultaneous | Conditional    | Positive |Past Imperfective: Perfective _kien_ + Imperfective or Active Participle|_jien kont norqod [kieku]_|
|Simultaneous | Conditional    | Negative |     |_jien ma kontx norqod [kieku]_|
|Anterior     | Present        | Positive |  -  |     |
|Anterior     | Present        | Negative |  -  |     |
|Anterior     | Past           | Positive |"Pluperfett": Perfective _kien_ + Perfective|_jien kont irqadt_|
|Anterior     | Past           | Negative |     |_jien ma kontx irqadt_|
|Anterior     | Future         | Positive |Future perfective: Imperfective _kien_ + Imperfective|_jien inkun irqadt_|
|Anterior     | Future         | Negative |     |_jien ma nkunx irqadt_(?)|
|Anterior     | Conditional    | Positive |  -  |     |
|Anterior     | Conditional    | Negative |  -  |     |

**_Notes_**

- _Future_ can also be expressed by means of: Imperfective + temporal adverb, e.g. _GĦADA MMUR NIXTRI_


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

