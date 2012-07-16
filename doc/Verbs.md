# Maltese GF Resource Grammar: Verbs
_John J. Camilleri, 2009-2012_  
_Last updated: 2012-04-16_

Notes about the implementation of Maltese **verbs**.
This file is both a documentaion, as well as a to-do list.

## Checklist

Items marked with a `*` are not yet covered.

1. Conjugations for first-form semitic verbs in Perfect, Imperfect, and Imperative tense.
1. *Handling of derived-form verbs
1. *Non-semitic verbs (romance, English-loan)
1. *Inflections for:
  1. *Negation, e.g. _ma marritx_
  1. *active/passive/continuous , e.g. _tela'_ vs _tiela_, _miktub_
  1. *direct & indirect object suffixes, e.g. _ħaditu_, _ġabuhielhom_

## Classification

Verb classification according to {MDG} and {T2M}.

- Semitic
  - Strong ("sħiħ")
     - Regular: all radicals strong & distinct, _eg QATEL (Q-T-L)_.
     - Liquid-Medial: C2 is liquid {MDG pg246,364; T2M pg18-19}, _eg ŻELAQ (Ż-L-Q)_
     - Reduplicated/Doubled/Geminated ("trux"): C2 & C3 are identical, _eg ĦABB (Ħ-B-B), XAMM (X-M-M), BEXX (B-X-X)_
  - Weak ("dgħajjef")
     - Assimilative ("assimilativ"): C1 is weak, _eg WAQAF (W-Q-F), WASAL (W-S-L)_
     - Hollow ("moħfi"): C2 is weak, long A or IE between C1 & C3, _eg DAM (D-W-M), SAR (S-J-R)_
     - Weak-Final ("nieqes"): C3 is weak, _eg BEKA (B-K-J), MEXA (M-X-J)_
     - Defective: C3 is silen GĦ, _eg BELA' (B-L-GĦ), QATA' (Q-T-GĦ)_
  - Quadriliteral: 4 radicals. _eg QARMEĊ (Q-R-M-Ċ)_
  - Irregular: _ĦA, TA, RA, MAR, ĠIE, QAL, KIEL, KELLU_
- Romance
  - Strongly-integrated. _eg KANTA, SERREP, BANDAL, BAQQAN_
     - Italian _-are_: _eg KANTA_
     - Italian _-ere_: _eg VINĊA_
     - Italian _-ire_: _eg SERVA_
  - Loosely-integrated. _eg ŻVILUPPA, IPPERFEZZJONA, ANTAGONIZZA, IDDIŻUBBIDIXXA_
- English loan words. _eg IBBUKJA, IWWELDJA, ERTJA, IFFITTJA_

In the MRG, we currently gather all Romance and English loan verbs under the common verb type `Loan`.


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

