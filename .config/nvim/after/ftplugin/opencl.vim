if exists("b:did_ftplugin") | finish | endif

runtime! ftplugin/c.vim

" Smaller tab stops.
setlocal tabstop=4
setlocal shiftwidth=4

" Smart tabbing/indenting
setlocal smarttab
setlocal smartindent

let b:did_ftplugin = 1
