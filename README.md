# Maltese GF Resource Grammar

## Introduction

This is a work-in-progress implementation of a Maltese resource grammar in [GF][3].
This grammar is currently under active development. The code can be found in two places:

1. The [GitHub repository][1] contains all commits and auxiliary files. It may at times contain interim code which doesn't compile.
1. The official [GF repository][2] shall only be updated with significant updates, and should always be compilable.

Feel free to contact me if you are interested in contributing, or just curious.

[1]: https://github.com/johnjcamilleri/Maltese-GF-Resource-Grammar
[2]: http://www.grammaticalframework.org/lib/src/maltese/
[3]: http://www.grammaticalframework.org/

## Repository overview

- This directory contains the grammar itself, split amongst various `.gf` files.
  Check out the [dependancy graph diagram][4] to see how the individual modules plug together.
- Observations on Maltese grammar and implementation notes can be found in [`doc/`][5].
- The [`test/`](https://github.com/johnjcamilleri/Maltese-GF-Resource-Grammar/tree/master/test) directory contains stuff used for, you guessed it, testing.
- Some more in-depth observations of Maltese grammar can be found in my [research blog][8], amongst other less exciting ramblings about my progress in general.

[4]: https://github.com/johnjcamilleri/Maltese-GF-Resource-Grammar/raw/master/doc/dependency_graph.png
[5]: https://github.com/johnjcamilleri/Maltese-GF-Resource-Grammar/tree/master/doc
[6]: http://mlrs.research.um.edu.mt/index.php?page=33
[8]: http://blog.johnjcamilleri.com/category/academic/research/

## License

This work is released under the [GNU Lesser General Public License](http://www.gnu.org/licenses/lgpl.txt).
In a nutshell, this means you can freely use it for whatever you want, including non-open source applications.

## Citations

Please site this work as:

> J. Camilleri, _A computational grammar and lexicon for Maltese_,
> M.Sc. thesis, Chalmers University of Technology. Gothenburg, Sweden, 2013.

## References

These publications are currently being used and can be referenced by citation stamp:

1. _Gwida għall-Ortografija_ by Carmel Azzopardi. It-tieni edizzjoni. Klabb Kotba Maltin, 2007. {GO}
1. _Grammatika Maltija_ by Bro. Henry F.S.C. It-tieni ktieb, is-6 edizzjoni. De La Salle Brothers Publications, 1980. {GM}
1. _Id-Dizzjunarju Malti - u teżawru ta' Malti mħaddem_ by Mario Serracino Inglott. It-tielet edizzjoni. Merlin, 2011. {DM}
1. _Maltese_ (part of "Descriptive Grammars" series) by Albert Borg and Marie Azzopardi-Alexander. Routledge, 1997. {MDG}
1. _Grammatical Framework - Programming with Multilingual Grammars_ by Aarne Ranta. CSLI, 2011. {GF}
1. _A Tale of Two Morphologies: Verb structure and argument alternations in Maltese_ by Michael Spagnol. University of Konstanz dissertation, Germany, 2011. {T2M}
1. _Deċiżjonijiet 1_ by il-Kunsill Nazzjonali tal-Ilsien Malti, 2008. {D1}
1. _Stem allomorphy in the Maltese Verb_ by Ray Fabri. In Ilsienna, Vol 1, 2009. {SA}
1. _The tense and aspect system of Maltese_ in Tense Systems in European Languages II, 1995. {TAS}

Other potentially useful references:

1. Spagnol, Michael. 2009. Lexical and grammatical aspect in Maltese. In Thomas Stolz (ed.), _Ilsienna_, 51--86. Bochum: Universitätsverlag Brockmeyer.
1. Serracino-Inglott’s (1975-1989) monolingual dictionary
1. Aquilina’s (1987-1990) bilingual dictionary
1. Manwel Mifsud (1995, _Loan Verbs in Maltese_. NY: Brill, pp. 272-295)
1. Sutcliffe, Edmund F. 1936. _A grammar of the Maltese language with chrestomathy and vocabulary_. London: Oxford University Press.
1. Borg, Albert. 1981. _A study of aspect in Maltese_. Ann Arbor: Karoma Publishers.
1. Borg, Albert. 1988. ? in _Ilsienna: Studju grammatikali_. Malta.
1. _Introducing Maltese Linguistics: Selected Papers from the 1st International Conference on Maltese Linguistics, Bremen, 18–20 October, 2007_, Edited by Bernard Comrie, Ray Fabri, Elizabeth Hume, Manwel Mifsud, Thomas Stolz and Martine Vanhove.
1. _Tagħrif Fuq Il-Kitba Bil-Malti_ by Għaqda tal-Kittieba tal-Malti, 1924. <http://www.akkademjatalmalti.com/filebank/documents/Taghrif_rivedut.pdf>
1. _Żieda mat-Tagħrif_ by l-Akkademja tal-Malti, 1984. <http://www.akkademjatalmalti.com/filebank/documents/Zieda_rivedut.pdf>
1. _Aġġornament tat-Tagħrif fuq il-Kitba Maltija_ by l-Akkademja tal-Malti, 1992. <http://www.akkademjatalmalti.com/filebank/documents/Aggornament_rivedut.pdf>
1. _Il-Gwida Tal-Istil Dipartimentali_ Il-Kummissjoni Ewropea 2011. <http://ec.europa.eu/translation/maltese/guidelines/documents/styleguide_maltese_dgt_mt.pdf>
