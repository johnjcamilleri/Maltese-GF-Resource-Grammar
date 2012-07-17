#!/usr/bin/env python

## Process .csv file (as exported from LibreOffice) and create
## a single, cleaned up tab-delimited text file.
## Version for Quad-consonantal roots
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
store = [[],[],[]]
COL=r'([^\t]*\t[^\t]*\t[^\t]*)'
regexp=re.compile(COL+'\t\t'+COL+'\t\t'+COL)
for index,line in enumerate(content):

    # Time to empty buffers?
    if re.match(r'^\t{3}', line):
        for n in range(len(store)):
            if len(store[n]):
                print "\n".join(store[n])
                store[n] = []
    
    # Else split into that shit
    s = regexp.match(line)
    if s:
        for n in range(len(s.groups())):
            store[n].append(s.group(n+1))
