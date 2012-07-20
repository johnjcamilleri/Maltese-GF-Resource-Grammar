# Maltese GF Resource Grammar: Verbs

Notes about the GF implementation of Maltese **verbs**.
This file is both a documentaion, as well as a to-do list, and will be in flux a lot.

## Checklist

1. ~~Conjugations for first-form semitic verbs in Perfect, Imperfect, and Imperative~~
1. Handling of derived-form verbs
1. Non-semitic verbs (romance, English-loan)
1. Polarity, e.g. _oħroġ_ vs _toħroġx_
1. Inflection for direct & indirect object suffixes, e.g. _ħaditu_, _ġabuhielhom_

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
     - Quadriliteral ("kwadrilitteru"): 4 radicals with C4 weak, e.g. _PINĠA (P-N-Ġ-J)_
  - Irregular: _ĦA, TA, RA, MAR, ĠIE, QAL, KIEL, KELLU, IDDA, EMMEN, IŻŻA, JAF, KIEN_
- Romance
  - Strongly-integrated, e.g. _KANTA, SERREP, BANDAL, BAQQAN_  
  From Italian _-are_ (e.g. _KANTA_), _-ere_ (e.g. _VINĊA_), _-ire_ (e.g. _SERVA_).  
  These are covered by the semitic paradigms above, they merely have a different etymology {T2M}.
  - Loosely-integrated. e.g. _ŻVILUPPA, IPPERFEZZJONA, ANTAGONIZZA, IDDIŻUBBIDIXXA_
- English loan words. e.g. _IBBUKJA, IWWELDJA, ERTJA, IFFITTJA_

In the MRG, we currently gather all Romance and English loan verbs under the common verb type `Loan`.

### Uncertainties

- Is _WERŻAQ_ weak or strong? {T2M app} says strong, {GM pg48} says weak.

## Tense

- Perfect (past), e.g. SERAQ
- Imperfect (present), e.g. JISRAQ
- Imperative, e.g. ISRAQ
  - "The imperitive is formed from the imperfect form of the verb" {MDG pg238}
- Present Particible: Intransitive and 'motion' verbs only, eg NIEŻEL
- Past Particible: Both verbal & adjectival function, eg MISRUQ

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

