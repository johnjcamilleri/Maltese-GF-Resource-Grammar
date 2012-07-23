#! /bin/sh
# Example: $ cc.sh 'mkV "kiteb"'

echo "\
i -retain ParadigmsMlt.gf
cc -table -unqual $*
" | gf --run
