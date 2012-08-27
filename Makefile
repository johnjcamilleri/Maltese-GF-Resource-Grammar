all: batch

batch:
	clear
	gf --batch AllMlt.gf

interactive:
	gf AllMlt.gf

wordlist:
	echo "print_grammar -words" | gf --run AllMlt.gf | sed 's/ /\n/g' > test/wordlist.txt

tags:
	gf --tags --output-dir=.gfbuild AllMlt.gf

clean:
	rm *.gfo
	rm .gfbuild/*.gf-tags

# Only ever add a treebank here if its gold standard has been checked!
treebank_strong_verbs:
	test/treebank.sh verbs "fetaħ kiteb ħass xamm ħareġ lagħab għamel"

treebank_weak_verbs:
	test/treebank.sh verbs "wasal waqaf żied qata'"

treebank_quad_verbs:
	test/treebank.sh verbs "ċempel ħarbat għargħax kanta serva"

