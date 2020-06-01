" ============================================================================
" File:        replace.vim
" Description: autoload functions for replace feature
" Maintainer:  Reed Esau <github.com/reedes>
" Created:     February 6, 2013
" License:     The MIT License (MIT)
" ============================================================================
"
if exists('g:autoloaded_textobj_quote_replace') &&
 \ g:autoloaded_textobj_quote_replace
  fini
en

" Copied from vim-yoink
function! textobj#quote#replace#getDefaultReg() abort
    let clipboardFlags = split(&clipboard, ',')
    if index(clipboardFlags, 'unnamedplus') >= 0
        return '+'
    elseif index(clipboardFlags, 'unnamed') >= 0
        return '*'
    else
        return '"'
    endif
endfunction

function! textobj#quote#replace#replace(mode, visual) abort
  " 0=C->S  1=S->C
  if !exists('b:textobj_quote_dl') | return | endif
  " Extract the target text...
  if len(a:visual) > 0
      execute 'normal! gv"' . textobj#quote#replace#getDefaultReg() . 'y'
    else
      execute 'normal! vi"' . textobj#quote#replace#getDefaultReg() . 'py'
  endif
  let l:text = getreg(textobj#quote#replace#getDefaultReg())

  if a:mode ==# 0     " replace curly with straight
    let l:text = substitute(l:text, '[' . b:textobj_quote_sl . b:textobj_quote_sr . ']', "'", 'g')
    let l:text = substitute(l:text, '[' . b:textobj_quote_dl . b:textobj_quote_dr . ']', '"', 'g')
  else                " replace straight with curly
    let l:text = substitute(l:text, textobj#quote#getPrevCharRE(0) . '\zs''', b:textobj_quote_sl, 'g')
    let l:text = substitute(l:text, textobj#quote#getPrevCharRE(1) . '\zs"' , b:textobj_quote_dl, 'g')
    let l:text = substitute(l:text, "'", b:textobj_quote_sr, 'g')
    let l:text = substitute(l:text, '"', b:textobj_quote_dr, 'g')
  endif

  " Paste back into buffer in place of original...
  call setreg(textobj#quote#replace#getDefaultReg(), l:text, mode())
  execute 'normal! gv"' . textobj#quote#replace#getDefaultReg() . 'p'
endfunction

let g:autoloaded_textobj_quote_replace = 1
