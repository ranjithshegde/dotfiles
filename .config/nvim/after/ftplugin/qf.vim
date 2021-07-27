nn <silent><buffer>dd :call util#qf_delete(bufnr())<CR>
vn <silent><buffer>d  :call util#qf_delete(bufnr())<CR>

nn <buffer> H :colder<CR>
nn <buffer> L :cnewer<CR>
