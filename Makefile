all: batch

batch:
	clear
	gf --batch AllMlt.gf

interactive:
	gf AllMlt.gf

tags:
	gf --tags --output-dir=.gfbuild AllMlt.gf

clean:
	rm *.gfo
	rm .gfbuild/*.gf-tags

verbs:
	gf -run < test/verbs.gfs

loan_verbs:
	gf -run < test/loan_verbs.gfs
