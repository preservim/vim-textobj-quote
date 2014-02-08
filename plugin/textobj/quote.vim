" ============================================================================
" File:        textobj_quote.vim
" Description: load functions for vim-textobj-quote plugin
" Maintainer:  Reed Esau <github.com/reedes>
" Created:     February 6, 2013
" License:     The MIT License (MIT)
" ============================================================================

scriptencoding utf-8

if exists('g:loaded_textobj_quote') | finish | endif

if !exists('g:textobj#quote#doubleMotion')
  let g:textobj#quote#doubleMotion = 'q'
endif
if !exists('g:textobj#quote#singleMotion')
  let g:textobj#quote#singleMotion = 'Q'
endif

let g:textobj#quote#doubleStandard = '“”'
let g:textobj#quote#singleStandard = '‘’'

if !exists('g:textobj#quote#doubleDefault')
  "  “double”
  let g:textobj#quote#doubleDefault = g:textobj#quote#doubleStandard
endif
if !exists('g:textobj#quote#singleDefault')
  "  ‘single’
  let g:textobj#quote#singleDefault = g:textobj#quote#singleStandard
endif

" enable/disable features
if !exists('g:textobj#quote#match')
  let g:textobj#quote#match = 1
endif
if !exists('g:textobj#quote#educate')
  let g:textobj#quote#educate = 1
endif
if !exists('g:textobj#quote#replace')
  let g:textobj#quote#replace = 1
endif
if !exists('g:textobj#quote#surround')
  let g:textobj#quote#surround = 1
endif

" needed to match pairs of quotes (via tpope/vim-sensible)
if g:textobj#quote#match &&
      \ !exists('g:loaded_matchit') &&
      \ findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" commands to toggle key mappings
if g:textobj#quote#educate
  command! -nargs=0 Educate call textobj#quote#educate#mapKeys(1)
  command! -nargs=0 NoEducate call textobj#quote#educate#mapKeys(0)
  command! -nargs=0 ToggleEducate call textobj#quote#educate#toggleMappings()
endif

" replace quotes in bulk
if g:textobj#quote#replace
  nnoremap <Plug>QuoteReplaceWithCurly    :call textobj#quote#replace#replace(1, '')<cr>
  vnoremap <Plug>QuoteReplaceWithCurly    :<C-u>call textobj#quote#replace#replace(1, visualmode())<cr>
  nnoremap <Plug>QuoteReplaceWithStraight :call textobj#quote#replace#replace(0, '')<cr>
  vnoremap <Plug>QuoteReplaceWithStraight :<C-u>call textobj#quote#replace#replace(0, visualmode())<cr>
endif

" a simple alterative to tpope/vim-surround
if g:textobj#quote#surround
  nnoremap <Plug>QuoteSurroundDouble :call textobj#quote#surround#surround(1, '')<cr>
  vnoremap <Plug>QuoteSurroundDouble :<C-u>call textobj#quote#surround#surround(1, visualmode())<cr>
  nnoremap <Plug>QuoteSurroundSingle :call textobj#quote#surround#surround(0, '')<cr>
  vnoremap <Plug>QuoteSurroundSingle :<C-u>call textobj#quote#surround#surround(0, visualmode())<cr>
endif

let g:loaded_textobj_quote = 1
