#!/bin/sh

( cd ../../ ; make pgf )

( make tester )

echo
./tester "$@"
