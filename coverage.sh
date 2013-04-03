#!/bin/sh

# Count missing functions and return as percentage of all functions in RGL
MISSING=`echo "pg -missing | ? wc -w" | gf --run AllMlt.gf | cut -f1 -d' '`
TOTAL=690
PERC=$((100*MISSING/TOTAL))
echo "Missing: ${MISSING}/${TOTAL} (${PERC}%)"
