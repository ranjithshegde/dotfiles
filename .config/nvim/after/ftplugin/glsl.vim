setlocal foldmethod=indent
setlocal foldignore=

setlocal suffixesadd=.glsl,.vs,.fs
setlocal path+=**

setlocal keywordprg=:help
setlocal completefunc=glsl#CompleteFunc

if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

setlocal cindent

let b:undo_indent = "setl cin<"
