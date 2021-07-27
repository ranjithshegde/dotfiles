"******************* function calls --------------------------------------------
com! Cam call util#CamelCase()
com! LspCapabilities lua require('utils').lspcapabilities()
com! Cpractice lua require('compiler').cpractice()
" com -nargs=* -complete=shellcmd TTerm lua require('utils').toggleTerm(<f-args>, 1)
com! TexWordCount lua require('utils').TexWordCount()

nn <silent> <leader>e :call util#ToggleNetrw()<CR>

nn <silent><leader>rv <cmd>vnew %<CR><cmd>call util#OpenRangerIn("%:p:h", "vs ")<CR>
nn <silent><leader>rV <cmd>vnew %<CR><cmd>call util#OpenRangerIn(".", "vs ")<CR>

nn <silent><leader>rt <cmd>tabnew %<CR><cmd>call util#OpenRangerIn("%:p:h", "tab drop ")<CR>
nn <silent><leader>rT <cmd>tabnew %<CR><cmd>call util#OpenRangerIn(".", "tab drop ")<CR>

nn <silent><leader>rr <cmd>call util#OpenRangerIn("%:p:h", "e ")<CR>
nn <silent><leader>rR <cmd>call util#OpenRangerIn(".", "e ")<CR>

com! Su call util#sudoWrite()
com! Gram call util#WordProcessor()
