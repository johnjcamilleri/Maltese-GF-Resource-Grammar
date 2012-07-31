# Maltese GF Resource Grammar
_John J. Camilleri, 2009-2012_  

## Introduction

This is a work-in-progress implementation of a Maltese resource grammar in [GF][3].
This grammar is currently under active development. The code can be found in two places:

1. The [GitHub repository][1] contains all commits and auxiliary files. It may at times contain interim code which doesn't compile.
1. The official [GF repository][2] shall only be updated with significant updates, and should always be compilable.

Feel free to contact me if you are interested in contributing, or just curious.

[1]: https://github.com/johnjcamilleri/Maltese-GF-Resource-Grammar
[2]: http://www.grammaticalframework.org/lib/src/maltese/
[3]: http://www.grammaticalframework.org/

## Overview

- This directory contains the grammar itself, split amongst various `.gf` files.
  Check out the [dependancy graph diagram][4] to see how the individual modules plug together.
- Observations on Maltese grammar and implementation notes can be found in [`doc/`][5].
- The [`test/`](https://github.com/johnjcamilleri/Maltese-GF-Resource-Grammar/tree/master/test) directory contains stuff used for, you guessed it, testing.
- Some more in-depth studies of Maltese grammar can be found in my [research blog][8], amongst other less exciting ramblings about my progress in general.

If you are looking for the tab-delimited plain text versions of Michael Spagnol's [compilation of Maltese verb roots][6], they have now
been moved to their own repository [here][7].


[4]: https://github.com/johnjcamilleri/Maltese-GF-Resource-Grammar/raw/master/doc/dependency_graph.png
[5]: https://github.com/johnjcamilleri/Maltese-GF-Resource-Grammar/tree/master/doc
[6]: http://mlrs.research.um.edu.mt/index.php?page=33
[7]: https://github.com/johnjcamilleri/maltese-verb-roots-db
[8]: http://blog.johnjcamilleri.com/category/academic/research/

## Checklist

1. ~~Numerals - ordinal and cardinals~~ (still buggy but ok)
1. Nouns, Adjectives, Verbs (see separate `.md` files in [`doc/`][5])
1. Determiners and prepositions, e.g. _ir-ramel_, _lil huh_, _mis-sema_
1. Phrase-level categories, ie NP, VP, AP etc.
1. Everything else...

## References

These publications are currently being used and can be referenced by citation stamp:

1. _Gwida għall-Ortografija_ by Carmel Azzopardi. It-tieni edizzjoni. Klabb Kotba Maltin, 2007. {GO}
1. _Grammatika Maltija_ by Bro. Henry F.S.C. It-tieni ktieb, is-6 edizzjoni. De La Salle Brothers Publications, 1980. {GM}
1. _Id-Dizzjunarju Malti - u teżawru ta' Malti mħaddem_ by Mario Serracino Inglott. It-tielet edizzjoni. Merlin, 2011. {DM}
1. _Maltese_ (part of "Descriptive Grammars" series) by Albert Borg and Marie Azzopardi-Alexander. Routledge, 1997. {MDG}
1. _Grammatical Framework - Programming with Multilingual Grammars_ by Aarne Ranta. CSLI, 2011. {GF}
1. _A Tale of Two Morphologies: Verb structure and argument alternations in Maltese_ by Michael Spagnol. University of Konstanz dissertation, Germany, 2011. {T2M}
1. _Deċiżjonijiet 1_ by il-Kunsill Nazzjonali tal-Ilsien Malti, 2008. {D1}

Some sources of enlightenment:

1. _Korpus Malti_ - <http://mlrs.research.um.edu.mt/corpusquery/cwb/malti01/>
1. _Kelmet il-Malti_ Facebook group - <https://www.facebook.com/groups/246657308743181/>
1. _Is-Suffissi tan-Nazzjonijiet fil-Malti_ - Michael Spagnol. (unpublished).
1. _Basic Maltese Grammar_ by Grazio Falzon. <http://aboutmalta.com/grazio/maltesegrammar.html>, 1997. {BMG}

Other potentially useful references:

1. Spagnol, Michael. 2009. Lexical and grammatical aspect in Maltese. In Thomas Stolz (ed.), _Ilsienna_, 51--86. Bochum: Universitätsverlag Brockmeyer.
1. Serracino-Inglott’s (1975-1989) monolingual dictionary
1. Aquilina’s (1987-1990) bilingual dictionary
1. Manwel Mifsud (1995, _Loan Verbs in Maltese_. NY: Brill, pp. 272-295)
1. Sutcliffe, Edmund F. 1936. _A grammar of the Maltese language with chrestomathy and vocabulary_. London: Oxford University Press.
1. Borg, Albert. 1981. _A study of aspect in Maltese_. Ann Arbor: Karoma Publishers.
1. Borg, Albert. 1988. ? in _Ilsienna: Studju grammatikali_. Malta.

