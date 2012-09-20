#! /bin/bash

# test/blanktreebank.sh verbs "mkV" "kiteb fetaħ qata'"

# Check args
if [ $# -lt 3 ]; then
    echo "Usage: test/blanktreebank.sh verbs \"mkV\" \"kiteb fetaħ qata'\""
    exit 1 ;
fi
DIR="test/$1/"
CMD="$2"
FILES="$3"

set -e

for FILENAME in $FILES ; do
    FILE="$DIR$FILENAME.treebank"
    echo "i -retain ParadigmsMlt.gf
cc -table -unqual ${CMD} \"${FILENAME}\"
---" > "$FILE"
    echo "Wrote ${FILE}"
done


