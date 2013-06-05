#!/bin/bash

# Find sed/gsed
if hash gsed 2>/dev/null; then
    sed="gsed"
else
    sed="sed"
fi

# Build things
( cd ../../ ; make pgf_engmlt )
( make tester )

# Run test
outfile=history/`date +%Y%m%d_%H%M%S`.txt
echo
./tester "$@" | tee >( $sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" > "$outfile" )
