#! /bin/bash

TMP_GOLD=/tmp/gold.tmp
TMP_OUT=/tmp/out.tmp
TMP_DIFF=/tmp/diff.tmp

DIR=test/verbs/
FILES="kiteb fetaħ qata'"
# FILES="qata'"

clear
rm $TMP_GOLD $TMP_OUT $TMP_DIFF

for FILENAME in $FILES ; do
    FILE=$DIR$FILENAME.treebank
    IX=3

    # Append to gold
    tail -n +`expr $IX + 1` $FILE >> $TMP_GOLD

    # Run and append to out
    head -n `expr $IX - 1` $FILE | gf --run >> $TMP_OUT
done

# Diff
diff $TMP_OUT $TMP_GOLD > $TMP_DIFF

# Output
echo "================================================================================"
cat $TMP_DIFF | colordiff
echo "================================================================================"
cat $TMP_DIFF | diffstat
