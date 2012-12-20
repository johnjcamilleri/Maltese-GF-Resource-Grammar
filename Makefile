all: batch

rgl:
	runghc ../Make lang api langs=Mlt

batch:
#	time gf +RTS -K1000M -RTS --batch AllMlt.gf
	time gf --batch AllMlt.gf

interactive:
	gf AllMlt.gf

clean:
	rm --force *.gfo
	rm --force .gfbuild/*.gf-tags

rebuild: clean batch

tags:
	gf --tags --output-dir=.gfbuild AllMlt.gf

wordlist:
	echo "print_grammar -words" | gf --run AllMlt.gf | sed 's/ /\n/g' > test/wordlist.txt


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

