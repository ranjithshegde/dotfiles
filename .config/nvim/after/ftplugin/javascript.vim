let b:dispatch = 'node %'
let g:repl = 'node'

" nn <F6> <cmd>Dispatch browser-sync start --server --files "*.js, *.html, *.css"<CR>
nn <buffer><F6> <cmd>Dispatch browser-sync start --server --files *.html<CR>
