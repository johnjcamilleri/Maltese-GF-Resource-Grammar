#!/bin/sh

cd ..

# Count missing functions and return as percentage of all functions in RGL
MISSING=`echo "pg -missing" | gf --run AllMlt.gf | wc -w | sed -e 's/^[ \t]*//'`
TOTAL=690

# Adjust for those even Eng doesn't implement
CONSTANT=8
MISSING=$((MISSING-CONSTANT))
TOTAL=$((TOTAL-CONSTANT))

PERC=$((100*MISSING/TOTAL))
echo "Missing: ${MISSING}/${TOTAL} (${PERC}%)"
