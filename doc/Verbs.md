# Maltese GF Resource Grammar: Verbs
_John J. Camilleri, 2009-2012_  
_Last updated: 2012-04-16_

Notes about the implementation of Maltese **verbs**.
This file is both a documentaion, as well as a to-do list.

## Checklist

Items marked with a `*` are not yet covered.

1. Conjugations for semitic verbs with 3 and 4 radicals in the root.
1. *Non-semitic verbs (romance, English-loan)
1. *Inflections for:
  1. *Negation, e.g. _ma marritx_
  1. *active/passive/continuous , e.g. _tela'_ vs _tiela_, _miktub_
  1. *direct & indirect object suffixes, e.g. _ħaditu_, _ġabuhielhom_

## Type

Verb classification according to {MDG} and {T2M}.

- Semitic
  - Strong ("sħiħ")
     - Regular: all radicals strong & distinct, _eg QATEL (Q-T-L)_.
     - Liquid-Medial: C2 is liquid {MDG pg246,364; T2M pg18-19}, _eg ŻELAQ (Ż-L-Q)_
     - Reduplicated (also Doubled, Geminated): C2 & C3 are identical ("trux"), _eg ĦABB (Ħ-B-B), XAMM (X-M-M), BEXX (B-X-X)_
  - Weak ("dgħajjef")
     - Assimilative: C1 is weak ("assimilativ"), _eg WAQAF (W-Q-F), WASAL (W-S-L)_
     - Hollow: C2 is weak, long A or IE between C1 & C3 ("moħfi"), _eg DAM (D-W-M), SAR (S-J-R), QAL (Q-W-L)_
     - Weak-Final: C3 is weak ("nieqes"), _eg BEKA (B-K-J), MEXA (M-X-J)_
     - Defective (silent-final): C3 is semivowel GĦ ("?"), _eg BELA' (B-L-GĦ), QATA' (Q-T-GĦ)_
  - Quadriliteral: 4 radicals. _eg QARMEĊ (Q-R-M-Ċ)_
- Romance
  - Strongly-integrated. _eg KANTA, SERREP, BANDAL, BAQQAN_
     - Italian _-are_: _eg KANTA_
     - Italian _-ere_: _eg VINĊA_
     - Italian _-ire_: _eg SERVA_
  - Loosely-integrated. _eg ŻVILUPPA, IPPERFEZZJONA, ANTAGONIZZA, IDDIŻUBBIDIXXA_
- English loan words. _eg IBBUKJA, IWWELDJA, ERTJA, IFFITTJA_

In the MRG, we gather all Romance and English loan verbs under the common verb type `Loan`.


## Tense

- Perfect (past), e.g. SERAQ
- Imperfect (present), e.g. JISRAQ
- Imperative, e.g. ISRAQ
  - "The imperitive is formed from the imperfect form of the verb" {MDG pg238}
- Present Particible: Intransitive and 'motion' verbs only, eg NIEŻEL
- Past Particible: Both verbal & adjectival function, eg MISRUQ

