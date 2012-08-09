#! /bin/bash

TMP_CMD=/tmp/cmd.tmp
TMP_OUT=/tmp/out.tmp

# test/treebank.sh verbs \"kiteb fetaħ qata'\"

# Check args
if [ $# -lt 2 ]; then
    echo "Usage: test/makegold.sh verbs \"kiteb fetaħ qata'\""
    exit 1 ;
fi
DIR="test/$1/"
FILES="$2"

#set -e
rm --force "$TMP_CMD" "$TMP_OUT"

for FILENAME in $FILES ; do
    FILE="$DIR$FILENAME.treebank"
    IX=`grep -m 1 -n "^---" "$FILE" | cut -f1 -d':'`

    # Run
    head -n `expr $IX` "$FILE" > "$TMP_CMD"
    head -n `expr $IX - 1` "$FILE" | gf --run > "$TMP_OUT"

    # Combine to treebank
    cat "$TMP_CMD" "$TMP_OUT" > "$FILE"
    echo "Wrote to ${FILE}"
done

# Output
echo "================================================================================"
echo "Done - remember to manually check your gold standard files"