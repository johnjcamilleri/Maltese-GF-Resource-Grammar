clean:
	rm -f *.gfo

old: clean
	time --output=results-old.txt gf --old-comp --batch VerbsMlt.gf

new: clean
	time --output=results-new.txt gf --new-comp --batch VerbsMlt.gf
