#!/bin/sh

# Count missing functions and return as percentage of all functions in RGL
MISSING=`echo "pg -missing" | gf --run AllMlt.gf | wc -w | sed -e 's/^[ \t]*//'`
TOTAL=690
PERC=$((100*MISSING/TOTAL))
echo "Missing: ${MISSING}/${TOTAL} (${PERC}%)"
