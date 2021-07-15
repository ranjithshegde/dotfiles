nnoremap <silent><buffer>dd :call utils#qf_delete(bufnr())<CR>
vnoremap <silent><buffer>d  :call utils#qf_delete(bufnr())<CR>

nnoremap <buffer> H :colder<CR>
nnoremap <buffer> L :cnewer<CR>
