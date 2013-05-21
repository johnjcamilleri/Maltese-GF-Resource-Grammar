#!/bin/sh

( cd ../../ ; make pgf )

( ghc tester.hs )

./tester "$@"
