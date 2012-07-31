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
