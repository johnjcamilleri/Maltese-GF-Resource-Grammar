#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Lookup each entry in lexicon-dict mapping and replace
# declarations in lexicon with corresponding ones from dict

import sys
import codecs
import re

MAP="lex-dict-mapping.txt"
LEX="LexiconMlt.gf"
DIC="DictMlt.gf"

if __name__ == "__main__":

    # Load mapping into a dictionary
    mapfile = codecs.open(MAP,'r','utf-8')
    d_map = {}
    for l in mapfile.readlines():
        m = l.split("=")
        k = m[0].strip()
        v = m[1].strip()
        d_map[k] = v
    mapfile.close();

    # Load Dict into a dictionary
    dicfile = codecs.open(DIC,'r','utf-8')
    d_dict = {}
    for l in dicfile.readlines():
        m = l.split("=")
        if (len(m)) < 2:
            continue
        k = m[0].strip()
        v = m[1].strip()
        d_dict[k] = v
    dicfile.close();

    # Replace declarations with those in Dict file
    for (k,v) in d_map.items():
        if v in d_dict:
            d_map[k] = d_dict[v]

    # Replace declarations in Lexicon file
    lexfile = codecs.open(LEX,'r','utf-8')
    c = lexfile.read()
    for (k,v) in d_map.items():
        c = re.sub(k+r'.+;', k+r' = '+v, c)
    lexfile = codecs.open(LEX,'w','utf-8')
    lexfile.write(c)
    lexfile.close()

