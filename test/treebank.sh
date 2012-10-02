#! /bin/bash

TMP_GOLD=/tmp/gold.tmp
TMP_OUT=/tmp/out.tmp
TMP_DIFF=/tmp/diff.tmp

# test/treebank.sh verbs \"kiteb fetaħ qata'\"

# Check args
if [ $# -lt 2 ]; then
    echo "Usage: test/treebank.sh verbs \"kiteb fetaħ qata'\""
    exit 1 ;
fi
DIR="test/$1/"
FILES="$2"

#set -e
rm --force "$TMP_GOLD" "$TMP_OUT" "$TMP_DIFF"

for FILENAME in $FILES ; do
    FILE="$DIR$FILENAME.treebank"
    IX=`grep -m 1 -n "^---" "$FILE" | cut -f1 -d':'`

    # Append to gold
    tail -n +`expr $IX + 1` "$FILE" >> "$TMP_GOLD"

    # Run and append to out
    head -n `expr $IX - 1` "$FILE" | gf --run >> "$TMP_OUT"
done

# Try and see if something went wrong
LINES_OUT=`wc -l "$TMP_OUT" | cut -f1 -d' '`
LINES_GOLD=`wc -l "$TMP_GOLD" | cut -f1 -d' '`
if [[ $LINES_OUT != $LINES_GOLD ]] ; then
    echo "Number of lines doesn't match! Something went wrong..."
    echo "================================================================================"
    # colordiff "$TMP_OUT" "$TMP_GOLD"
    exit 1
fi

# Diff
diff "$TMP_OUT" "$TMP_GOLD" > "$TMP_DIFF"

# Output
#echo "================================================================================"
#cat "$TMP_DIFF" | colordiff
#echo "================================================================================"
cat "$TMP_DIFF" | diffstat
