# Maltese GF Resource Grammar: Numerals

Notes about the implementation of Maltese **numerals**.
This file is both a documentation, as well as a to-do list, and will be in flux a lot.

## Case

{MDG, 133} mentions "type A" and "type B" numerals, which in {GM, 202} are described as "użu aġġettiv" and "użu nominali" respectively.

## Implementation notes

An important note is that regardless of the magnitude of a number, for inflection purposes it is the latter part
of a numeral which is important, e.g.:

|3    |_tlett siegħat_                  |
|-----|---------------------------------|
|103  |_mija u tlett siegħat_           |
|1003 |_elf u tlett siegħat_            |

