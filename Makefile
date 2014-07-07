SOURCES=AdjectiveMlt.gf AdverbMlt.gf AllMlt.gf AllMltAbs.gf CatMlt.gf ConjunctionMlt.gf DictMlt.gf DictMltAbs.gf ExtraMlt.gf ExtraMltAbs.gf GrammarMlt.gf IdiomMlt.gf IrregMlt.gf IrregMltAbs.gf LangMlt.gf LexiconMlt.gf MorphoMlt.gf NounMlt.gf NumeralMlt.gf ParadigmsMlt.gf PhraseMlt.gf QuestionMlt.gf RelativeMlt.gf ResMlt.gf SentenceMlt.gf StructuralMlt.gf SymbolMlt.gf VerbMlt.gf
OBJECTS=AdjectiveMlt.gfo AdverbMlt.gfo AllMlt.gfo AllMltAbs.gfo CatMlt.gfo ConjunctionMlt.gfo DictMlt.gfo DictMltAbs.gfo ExtraMlt.gfo ExtraMltAbs.gfo GrammarMlt.gfo IdiomMlt.gfo IrregMlt.gfo IrregMltAbs.gfo LangMlt.gfo LexiconMlt.gfo MorphoMlt.gfo NounMlt.gfo NumeralMlt.gfo ParadigmsMlt.gfo PhraseMlt.gfo QuestionMlt.gfo RelativeMlt.gfo ResMlt.gfo SentenceMlt.gfo StructuralMlt.gfo SymbolMlt.gfo VerbMlt.gfo

# rgl:
# 	runghc ../Make lang api langs=Mlt

# lexicon:
# 	runghc update_lexicon.hs > tmp
# 	mv tmp LexiconMlt.gf

PGF/AllMlt.pgf: $(SOURCES)
	gf --make --name=PGF/AllMlt AllMlt.gf

PGF/LangEngMlt.pgf: $(SOURCES)
	gf --make --name=PGF/LangEngMlt LangMlt.gf ../english/LangEng.gf

clean:
	rm -f _tmpi _tmpo
	rm -f *.gfo
	rm -f .gfbuild/*.gf-tags

wordlist:
	echo "print_grammar -words" | gf --run AllMlt.gf | sed 's/ /\n/g' > test/wordlist.txt

doc/dependency_graph.png: $(SOURCES)
	echo "dg -only=AdjectiveMlt,AdverbMlt,AllMlt,CatMlt,ConjunctionMlt,DictMlt,ExtraMlt,GrammarMlt,IdiomMlt,IrregMlt,LangMlt,LexiconMlt,MorphoMlt,NounMlt,NumeralMlt,ParadigmsMlt,PhraseMlt,QuestionMlt,RelativeMlt,ResMlt,SentenceMlt,StructuralMlt,SymbolMlt,TextMlt,VerbMlt.gf" | gf --run --retain AllMlt.gf
	mv _gfdepgraph.dot doc/dependency_graph.dot
	dot -Tpng doc/dependency_graph.dot -o doc/dependency_graph.png

# Only ever add a treebank here if its gold standard has been checked!
treebank_all: \
	treebank_verbs_strong \
	treebank_verbs_weak \
	treebank_verbs_quad \
	treebank_verbs_loan \
	treebank_verbs_formII \
	treebank_verbs_formII_quad \
	treebank_verbs_formIII \
	treebank_verbs_formV \
	treebank_verbs_formVI \
	treebank_verbs_formVII \
	treebank_verbs_formVIII \
	treebank_verbs_formIX \
	treebank_verbs_formX

treebank_verbs_strong:
	test/treebank.sh verbs "fetaħ kiteb ħass xamm ħareġ lagħab għamel"

treebank_verbs_weak:
	test/treebank.sh verbs "wasal waqaf sab żied mexa qara qata'"

treebank_verbs_quad:
	test/treebank.sh verbs "ċempel ħarbat għargħax kanta serva"

treebank_verbs_loan:
	test/treebank.sh verbs "żviluppa antagonizza ssuġġerixxa"

treebank_verbs_formII:
	test/treebank.sh verbs "ħabbat kisser bexxex waqqaf qajjem neħħa qatta'"

treebank_verbs_formII_quad:
	test/treebank.sh verbs "tħarbat sserva tkanta"

treebank_verbs_formIII:
	test/treebank.sh verbs "ħares qiegħed wieġeb"

treebank_verbs_formV:
	test/treebank.sh verbs "tniżżel ssellef twassal" # tfejjaq tfaċċa tbeżża'

treebank_verbs_formVI:
	test/treebank.sh verbs "tqiegħed ġġieled" #  tħabat ... tbierek twieġeb tkaża

treebank_verbs_formVII:
	test/treebank.sh verbs "nġabar nħasel ntiżen nqata'" #  ... nfirex ntrifes nxteħet ntgħaġen nxtamm ntemm ... nstab nbeda ntlewa ...

treebank_verbs_formVIII:
	test/treebank.sh verbs "ntefaq mtedd ltaqa'" #  ... xtaq mtela ...

treebank_verbs_formIX:
	test/treebank.sh verbs "ħdar rqaq twal"

treebank_verbs_formX:
	test/treebank.sh verbs "stagħġeb stħarreġ stqarr" #  staħba (strieħ)
