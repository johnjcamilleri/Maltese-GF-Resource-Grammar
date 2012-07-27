#! /bin/bash

TMP_GOLD=/tmp/gold.tmp
TMP_CMD=/tmp/cmd.tmp
TMP_OUT=/tmp/out.tmp
TMP_DIFF=/tmp/diff.tmp

clear

# Select only desired regions of gold file
sed -n -e '1,1154p;1155,2308p;16157,17310p' test/verbs.gold > $TMP_GOLD

# Select only desired regions of command file
sed -n -e '1,3p' test/strong_verbs.gfs > $TMP_CMD
sed -n -e '12p' test/weak_verbs.gfs >> $TMP_CMD

# Run and save output
gf --run < $TMP_CMD > $TMP_OUT

# Diff
diff $TMP_OUT $TMP_GOLD > $TMP_DIFF

# Output
echo "================================================================================"
cat $TMP_DIFF | colordiff
echo "================================================================================"
cat $TMP_DIFF | diffstat
