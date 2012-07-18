#! /bin/bash

## Tri-consonantal roots
## Process individual .csv files (as exported from LibreOffice) and
## combine into a single, cleaned up tab-delimited text file.
##
## John J. Camilleri

INFILES=?.csv
OUTFILE=roots.txt
TMPFILE=out.tmp

# Basic combining and cleanup
cat $INFILES | egrep --invert-match "^(strong|weak|root|\s+$)" | egrep --invert-match "^\s{2}b\s{5}ċ" > $OUTFILE
sed -i "s/\s\/\s/\//" $OUTFILE

# Copy roots when spread over two lines
./copy-roots.py $OUTFILE > $TMPFILE
rm $OUTFILE ; mv $TMPFILE $OUTFILE

# Add a header
sed -i '1i\
root	I	II	III	V	VI	VII	VIII	IX	X' $OUTFILE

# Display it (pretty-printed)
column -n -t -c 1 -s $'\t' $OUTFILE
