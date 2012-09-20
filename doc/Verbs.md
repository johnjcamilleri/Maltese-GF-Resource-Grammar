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

1. ~~IE-reduction when adding affixes needs to be more intelligent. See {GO pg92,100}~~
1. ~~Avoid triples when adding suffixes, e.g. _ħakk_ + _kom_ = _ħakkom_~~

### Test cases

When testing the verb morphology, each of these cases should be considered for the given reason(s). Ideally we will have gold standards for each.

#### Form I

|Verb|Class|Notes|
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

#### Form II

|Derived mamma|Root|Form I|Class|Notes|
|:------------|:---|:-----|-----|:----|
|_ħabbat_|Ħ-B-T|_ħabat_|Strong|  |
|_kisser_|K-S-R|_kiser_|Strong liquid-medial|  |
|_bexxex_|B-X-X|_bexx_|Geminated|Vowel change (_bexxixt_); Avoid triple _xxx_|
|_waqqaf_|W-Q-F|_waqaf_|Weak-initial|  |
|_qajjem_|Q-J-M|_qam_|Weak-medial|Double j/w can only occur when a vowel follows. i.e. _qajmek_, not ~~_qajjmek_~~|
|_neħħa_ |N-Ħ-J|-|Weak-final|  |
|_qatta'_|Q-T-GĦ|_qata'_|Defective|  |
|_kerrah_|K-R-H|-|-|Formed from adjective _ikrah_|

Others:

- _libbes_ L-B-S
- _raqqad_ R-Q-D
- _daħħak_ D-Ħ-K
- _baħħar_ B-Ħ-R
- _ġedded_ Ġ-D-D
- _sewwed_ S-W-D

#### Quad. Form II

|Derived mamma|Root|Form I|Class|Notes|
|:------------|:---|:-----|-----|:----|
|_tħarbat_|Ħ-R-B-T|_ħarbat_|Strong|  |
|_tfixkel_|F-X-K-L|_fixkel_|Strong|Final L causes dubious cases, e.g. _tfixkillilna_|
|_ddardar_|D-R-D-R|_dardar_|Strong|Assimilation of T|
|_tkanta_|K-N-T-J|_kanta_|Weak-final|  |
|_sserva_|S-R-V-J|_serva_|Weak-final|Assimilation of T|


#### Form III

|Derived mamma|Root|Form I|Class|Notes|
|:------------|:---|:-----|-----|:----|
|_ħares_|Ħ-R-S|-|Strong liquid-medial|  |
|_qiegħed_|Q-GĦ-D|_qagħad_|Strong|C2 is 2 chars|
|_wieġeb_|W-Ġ-B|-|Weak-initial|_ie_ is shortened to _e_, not _i_|
|_miera_|M-R-J|-|Weak-final|  |

Others:

- _bierek_ B-R-K (use as model for _qiegħed_)
- _siefer_ S-F-R
- _żiegħel_ Ż-GĦ-L

#### Form IV

|_wera_|
|_għama_|
|_għana_|

#### Form V

|Derived mamma|Root|Form I/II|Class|Notes|
|:------------|:---|:-----|-----|:----|
|_tkisser_|K-S-R|_kiser_/_kisser_|Strong|  |
|_tniżżel_|N-Ż-L|_niżel_/_niżżel_|Strong|  |
|_tgħallaq_|GĦ-L-Q|_għalaq_/_għallaq_|Strong liquid-medial|C1 is two chars|
|_ssellef_|S-L-F|_silef_/_sellef_|Strong liquid-medial|Assimilation of T|
|_twassal_|W-S-L|_wasal_|Weak-initial|  |
|_tfejjaq_|F-J-Q|_fieq_|Weak-medial|  |
|_tfaċċa_|F-Ċ-J|_faċċa_|Weak-final|  |
|_tbeżża'_|B-Ż-GĦ|_beża'_|Weak defective|  |

Others

- _tħallat_ Ħ-L-T
- _ssaħħan_ S-Ħ-N
- _tħammeġ_ Ħ-M-Ġ
- _tgħannaq_ GĦ-N-Q
- _ċċarrat_ Ċ-R-T
- _tmexxa_ M-X-J


#### Form VI

|Derived mamma|Root|Form I/III|Class|Notes|
|:------------|:---|:-------|-----|:----|
|_tħabat_|Ħ-B-T|_ħabat_|Strong|Long vowel Â|
|_tqiegħed_|Q-GĦ-D|_qagħad_/_qiegħed_|Strong|Long vowel IE; C2 is GĦ|
|_ġġieled_|Ġ-L-D|_ġieled_|Strong liquid-medial|Assimilation of T|
|_tbierek_|B-R-K|_bierek_|Strong liquid-medial|  |
|_twieġeb_|W-Ġ-B|_wieġeb_|Weak-initial|  |
|_twiegħed_|W-GĦ-D|_wegħed_/_wiegħed_|Weak-initial|  |
|_tkaża_|K-Ż-J|_tkaża_|Weak-final|  |
|_tgara_|G-R-J|_gara_|Weak-final|  |

#### Form VII

|Derived mamma|Root|Form I|Class|Notes|
|:------------|:---|:-------|-----|:----|
|_nġabar_|Ġ-B-R|_ġabar_|Strong|  |
|_nħasel_|Ħ-S-L|_ħasel_|Strong|N prefix|
|_nfirex_|F-R-X|_firex_|Strong liquid-medial|  |
|_ntrifes_|R-F-S|_rifes_|Strong|NT prefix|
|_nxteħet_|X-Ħ-T|_xeħet_|Strong|N-T infix|
|_ntgħaġen_|GĦ-Ġ-N|_għaġen_|Strong|C1 is GĦ, NT prefix|
|_nxtamm_|X-M-M|_xamm_|Geminated|N-T infix|
|_ntemm_|T-M-M|_temm_|Geminated|N prefix|
|_ntiżen_|W-Ż-N|_wiżen_|Weak-inital|NT prefix with dropped C1|
|_nstab_|S-J-B|_sab_|Weak-medial|  |
|_nbeda_|B-D-J|_beda_|Weak-final|  |
|_ntlewa_|L-W-J|_lewa_|Weak-final|NT prefix|
|_nqata'_|Q-T-GĦ|_qata'_|Defective|  |
|_ntqal_|Q-W-L|_qal_|Weak-medial/Irreg|_qal_ is irregular in the imperfective|

Others

- _nġieb_ Ġ-J-B
- _nħeba_ Ħ-B-J


#### Form VIII

|Derived mamma|Root|Form I|Class|Notes|
|:------------|:---|:-------|-----|:----|
|_xteħet_|X-Ħ-T|_xeħet_|Strong|  |
|_mtedd_|M-D-D|_medd_|Geminated|  |
|_xtaq_|X-W-Q|_xaq_|Weak-medial|  |
|_mtela_|T-L-J|_tela_|Weak-final|  |
|_ltaqa'_|L-Q-GĦ|_laqa'_|Defective|  |

Others

- _ntefaq_ N-F-Q
- _stabat_ S-B-T
- _ltewa_ L-W-J
- _ntesa_ N-S-J
- _ftaqar_ F-Q-R

#### Form IX

|Derived mamma|Root|Class|Notes|
|:------------|:---|:----|:----|
|_ħdar_|Ħ-D-R|Strong|  |
|_rqaq_|R-Q-Q|Geminated|  |
|_twal_|T-W-L|Weak Medial|  |

Others:

- _sfar_ S-F-R
- _qsar_ Q-S-R
- _blieh_ B-L-H
- _bjad_ B-J-D
- _krieh_ K-R-H

#### Form X

|Derived mamma|Root|Form I/II|Class|Notes|
|:------------|:---|:-------|-----|:----|
|_stagħġeb_|GĦ-Ġ-B|II:_għaġġeb_|Strong|  |
|_stenbaħ_|N-B-Ħ|II:_nebbaħ_|Strong|  |
|_stħarreġ_|Ħ-R-Ġ|I:_ħareġ_|Strong liquid-medial|Stem is in second form (double _R_)|
|_stkerrah_|K-R-H|II:_kerrah_|Strong liquid-medial|  |
|_stqarr_|Q-R-R|I:_qarr_|Geminated|  |
|_strieħ_|S-R-Ħ|II:_serraħ_|Weak-medial|  |
|_staħba_|Ħ-B-J|I:_ħeba_|Weak-Final|  |
|_stenna_|'-N-J|-|Irregular|  |
|_stieden_|'-D-N|-|Irregular|  |

### Table of derived forms by verb class

Adapted from {MDG}

|Class|II|III|IV|V |VI|VII|VIII|IX|X |
|-----|---|---|---|---|---|---|----|---|---|
|Strong|_daħħal_|_bierek_|_wera_|_tfarrak_|_tbierek_|_nġabar_|_ntefaq_|_ħdar_|_stkerrah_|
|Geminated|_ħabbeb_|_qarar_||_tħabbeb_||_ntemm_|_mtedd_|_rqaq_|_stqarr_|
|Assimilative (Weak-initial)|_wassal_|_wieġeb_||_twassal_|_twieġeb_|_ntiżen_||||
|Hollow (Weak-medial)|_fejjaq_|||_tfejjaq_||_nġieb_|_xtaq_|_twal_|_strieħ_|
|Lacking (Weak-final)|_mexxa_|_miera_||_tmexxa_|_tkaża_|_nbeda_|_mtela_||_staħba_|
|Defective (GĦ-final)|_beżża'_|||_tbeżża'_||_nqata'_|_ltaqa'_|||
|Quad Strong|_tħarbat_|||||||||
|Quad Weak-final|_sserva_|||||||||

## Classification

Verb classification according to {MDG}, {T2M} and {GM}.

- Semitic
    - Strong ("sħiħ")
        - Regular: all radicals strong & distinct, e.g. _QATEL (Q-T-L)_.
        - Liquid-Medial: C2 is liquid {MDG pg246,364; T2M pg18-19}, e.g. _ŻELAQ (Ż-L-Q)_
        - Geminated/Reduplicative/Doubled ("trux"): C2 & C3 are identical, e.g. _ĦABB (Ħ-B-B), XAMM (X-M-M), BEXX (B-X-X)_
    - Weak ("dgħajjef")
        - Assimilative ("assimilativ"/"xebbiehi"): C1 is weak, e.g. _WAQAF (W-Q-F), WASAL (W-S-L)_
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

