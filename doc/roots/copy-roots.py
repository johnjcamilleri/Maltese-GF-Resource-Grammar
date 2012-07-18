#!/usr/bin/env python

## Copy roots when subsequent entries are blank.
##
## John J. Camilleri

import re
import sys

# Check usage & set file names
if (len(sys.argv) < 2):
    exit("You must specify a filename")
INFILE = sys.argv[1]

# Read file
try:
    with open(INFILE, 'r') as f:
        content = f.readlines()
except IOError as (errno, strerror):
    exit("I/O error({0}): {1}".format(errno, strerror))

# Process
reROOT=re.compile(r'([^\t]+)')
root=""
for index,line in enumerate(content):
    line = line[:-1]

    # Consume the current root
    m = reROOT.match(line)
    if m:
        root = m.group(1)
        print line
    else:
        print root + line

