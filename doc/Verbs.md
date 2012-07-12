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

Verb classification according to {MDG}.

- Semitic
  - Strong verb: none of radicals are semi-vowels. _eg ĦAREĠ (Ħ-R-Ġ)_
  - Defective verb: third radical is semivowel GĦ. _eg QATA' (Q-T-GĦ)_
  - Weak verb: third radical is semivowel J. _eg MEXA (M-X-J)_
  - Hollow verb: long A or IE btw radicals 1 & 3. _eg QAL (Q-W-L) or SAB (S-J-B)_
  - Double/Geminated verb: radicals 2 & 3 identical. _eg ĦABB (Ħ-B-B)_
  - Quadriliteral verb: 4 radicals. _eg QARMEĊ (Q-R-M-Ċ)_
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
- Present Particible: Intransitive and 'motion' verbs only, eg NIEŻEL
- Past Particible: Both verbal & adjectival function, eg MISRUQ

