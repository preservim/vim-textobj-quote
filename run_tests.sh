#!/usr/bin/env bash

VIMRC="$TMPDIR/mini-vimrc"

cat > $VIMRC << EOF
set nocompatible
syntax on
set shortmess+=I

for dep in ['vader.vim', 'vim-textobj-user']
  execute 'set rtp+=' . finddir(dep, expand('~/.vim').'/**')
endfor
set rtp+=.
EOF

vim -u $VIMRC "+Vader spec/*"
#vim -u $VIMRC '+Vader!*' && echo Success || echo Failure

rm -f $VIMRC
