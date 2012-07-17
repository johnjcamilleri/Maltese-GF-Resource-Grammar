#! /bin/bash

## Process .csv file (as exported from LibreOffice) and create
## a single, cleaned up tab-delimited text file.
## Version for Quad-consonantal roots
##
## John J. Camilleri

INFILE=quad.csv
OUTFILE=roots-quad.txt
TMPFILE=out.tmp

# Fix columns using external script
./fix-columns.py $INFILE > $TMPFILE

# Basic cleanup of unwanted lines
egrep --invert-match "^(quad|root|\s+$)" $TMPFILE | egrep --invert-match "	\/?[^\s](	|$)" > $OUTFILE
sed -i "s/\s\/\s/\//" $OUTFILE

# Remove empty lines
egrep --invert-match "^\s*$" $OUTFILE > $TMPFILE
rm $OUTFILE
mv $TMPFILE $OUTFILE

# Add a header
sed -i '1i\
root	I	II' $OUTFILE

# TODO: copy roots as in triliteral version

# Display it (pretty-printed)
#column -c 1 -s $'\t' $OUTFILE
