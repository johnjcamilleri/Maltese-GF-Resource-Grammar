#! /bin/bash

## Process individual .csv files (as exported from LibreOffice) and
## combine into a single, cleaned up tab-delimited text file.
## Version for Tri-consonantal roots
##
## John J. Camilleri

OUTFILE=roots.txt
TMPFILE=out.tmp

# Basic combining and cleanup
cat ?.csv | egrep --invert-match "^(strong|weak|root|\s+$)" | egrep --invert-match "^\s{2}b\s{5}ċ" > $OUTFILE
sed -i '1i\
root	I	II	III	V	VI	VII	VIII	IX	X' $OUTFILE

# Copy roots when spread over two lines
# Run repeatedly until there are no blanks left
REPLACE='s/^\(\S\+\)\(.*\)\n\(\t.*\)/\1\2\n\1\3/'
BLANKS=999
while [ $BLANKS -gt 0 ]; do
    # This is a hack which runs 2 out-of-phase passes over the file
    sed '1i \n' $OUTFILE | sed "{ N; $REPLACE }" | tail -n +2 | sed "{ N; $REPLACE }" > $TMPFILE
    rm $OUTFILE
    mv $TMPFILE $OUTFILE
    BLANKS=`egrep "^\s" $OUTFILE | wc -l`
    echo Remaining $BLANKS
done

# Display it (pretty-printed)
column -c 1 -s $'\t' $OUTFILE
