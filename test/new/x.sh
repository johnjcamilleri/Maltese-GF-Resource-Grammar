#!/bin/sh

( cd ../../ ; make pgf_engmlt )

( make tester )

echo
./tester "$@"
