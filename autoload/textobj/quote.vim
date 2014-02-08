" ============================================================================
" File:        quote.vim
" Description: autoload functions for vim-textobj-quote plugin
" Maintainer:  Reed Esau <github.com/reedes>
" Created:     February 6, 2013
" License:     The MIT License (MIT)
" ============================================================================

scriptencoding utf-8

if &cp || (  exists('g:autoloaded_textobj_quote') &&
          \ !exists('g:force_reload_textobj_quote'))
  finish
endif

function! s:unicode_enabled()
  return &encoding == 'utf-8'
endfunction

function! textobj#quote#getRegex(mode)
  " regex to match previous character
  " mode=1 is double; mode=0 is single
  return '\v(^|[[({& ' .
        \ (a:mode
        \   ? (b:textobj_quote_sl . '''])')
        \   : (b:textobj_quote_dl . '"])'))
endfunction

" set up mappings for current buffer only
" initialize buffer-scoped variables
" args: { 'double':'“”', 'single':'‘’',}
function! textobj#quote#init(...)
  if !s:unicode_enabled() | return | endif

  let l:args = a:0 ? a:1 : {}
  let l:double_pair = get(l:args, 'double', g:textobj#quote#doubleDefault)
  let l:single_pair = get(l:args, 'single', g:textobj#quote#singleDefault)

  " obtain the individual quote characters
  let l:d_arg = split(l:double_pair, '\zs')
  let l:s_arg = split(l:single_pair, '\zs')
  let b:textobj_quote_dl = l:d_arg[0]
  let b:textobj_quote_dr = l:d_arg[1]
  let b:textobj_quote_sl = l:s_arg[0]
  let b:textobj_quote_sr = l:s_arg[1]

  let l:xtra = '\ze\(\W\|$\)' " specialized closing pattern to ignore use of quote in contractions
  call textobj#user#plugin('quote', {
  \      'double-quotation-mark': {
  \         'pattern':   [ b:textobj_quote_dl,
  \                        b:textobj_quote_dr . (b:textobj_quote_dr ==# '’' ? l:xtra : '') ],
  \         'select-a': 'a' . g:textobj#quote#doubleMotion,
  \         'select-i': 'i' . g:textobj#quote#doubleMotion,
  \      },
  \      'single-quotation-mark': {
  \         'pattern':   [ b:textobj_quote_sl,
  \                        b:textobj_quote_sr . (b:textobj_quote_sr ==# '’' ? l:xtra : '') ],
  \         'select-a': 'a' . g:textobj#quote#singleMotion,
  \         'select-i': 'i' . g:textobj#quote#singleMotion,
  \      },
  \})

  " initialize extensions

  if get(l:args, 'match', g:textobj#quote#matchit) &&
   \ exists("b:match_words")
    " support '%' navigation of textobj_quote pairs
    if b:textobj_quote_dl != b:textobj_quote_dr
      let b:match_words .= ',' . b:textobj_quote_dl . ':' . b:textobj_quote_dr
    endif
    if b:textobj_quote_sl != b:textobj_quote_sr
      let b:match_words .= ',' . b:textobj_quote_sl . ':' . b:textobj_quote_sr
    endif
  endif

  if get(l:args, 'educate', g:textobj#quote#educate)
    call textobj#quote#educate#mapKeys(1)
  endif

endfunction

let g:autoloaded_textobj_quote = 1
