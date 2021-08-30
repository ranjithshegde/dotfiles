"******************* function calls --------------------------------------------
com! Su call util#sudoWrite()
com! Cam call util#CamelCase()
com! Gram call util#WordProcessor()
com! Cpractice lua require('compiler').cpractice()
com! TexWordCount lua require('utils').TexWordCount()
" com! LspCapabilities lua require('utils').lspcapabilities()

"open ranger over current buffer
nn <silent><leader>rr <cmd>call util#OpenRangerIn("%:p:h", "e ")<CR>
nn <silent><leader>rR <cmd>call util#OpenRangerIn(".", "e ")<CR>
"open ranger as vertical split
nn <silent><leader>rv <cmd>vnew %<CR><cmd>call util#OpenRangerIn("%:p:h", "vs ")<CR>
nn <silent><leader>rV <cmd>vnew %<CR><cmd>call util#OpenRangerIn(".", "vs ")<CR>
"open ranger in new tab
nn <silent><leader>rt <cmd>tabnew %<CR><cmd>call util#OpenRangerIn("%:p:h", "tab drop ")<CR>
nn <silent><leader>rT <cmd>tabnew %<CR><cmd>call util#OpenRangerIn(".", "tab drop ")<CR>
