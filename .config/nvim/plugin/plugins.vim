"******************* function calls --------------------------------------------
com! Cam call camel#CamelCase()
com! LspCapabilities lua require('utils').lspcapabilities()
com! Cpractice lua require('compiler').cpractice()
" com -nargs=* -complete=shellcmd TTerm lua require('utils').toggleTerm(<f-args>, 1)

nn <silent> <leader>e :call drawer#ToggleNetrw()<CR>

nn <silent><leader>rv <cmd>vnew %<CR><cmd>call ranger#OpenRangerIn("%:p:h", "vs ")<CR>
nn <silent><leader>rV <cmd>vnew %<CR><cmd>call ranger#OpenRangerIn(".", "vs ")<CR>

nn <silent><leader>rt <cmd>tabnew %<CR><cmd>call ranger#OpenRangerIn("%:p:h", "tab drop ")<CR>
nn <silent><leader>rT <cmd>tabnew %<CR><cmd>call ranger#OpenRangerIn(".", "tab drop ")<CR>

nn <silent><leader>rr <cmd>call ranger#OpenRangerIn(".", "e ")<CR>

