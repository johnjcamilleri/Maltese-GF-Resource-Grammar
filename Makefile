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

treebank_strong_verbs:
	test/treebank.sh verbs "fetaħ kiteb ħass xamm ħareġ lagħab għamel"

treebank_weak_verbs:
	test/treebank.sh verbs "qata'"

treebank_quad_verbs:
	test/treebank.sh verbs "ċempel"

clean:
	rm *.gfo
	rm .gfbuild/*.gf-tags
