 if exists("b:did_indent")
  finish
endif

runtime! indent/c.vim

let b:did_indent = 1
