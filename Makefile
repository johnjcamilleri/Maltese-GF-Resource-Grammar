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
