"**************Neovim basics -------------------------------------------------------------
lua require('impatient')
lua require ('plugins')
lua require('packer_compiled')
lua require ('settings').settings()
lua require ('mappings').general()

" Custom tabline
function! TabLine()
    return luaeval("require'statusline'.tabs()")
endfunction
set tabline=%!TabLine()

"************** FileTypes & AutoCompiles-----------------------------------------------

augroup commonFtRules
    au FileType text,tex,vimwiki,org call util#WordProcessor()
    au FileType org setlocal iskeyword+=:,#,+
    au FileType vim nn <silent>,K <cmd>exe 'h '.expand('<cword>')<CR>
augroup end 

augroup MakeDispatch
    au!
    au FileType java,lua,python,javascript nn<buffer><F5> <cmd>w<CR><cmd>Dispatch<CR> |
                \ nn <F10> <cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR> |
                \ tno <F10> <esc><cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR>
augroup END

"************************ Terminal management -------------------------------------------------
augroup terminalInsertModes
    autocmd!
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd TermEnter * startinsert
    autocmd TermClose * call nvim_input('<CR>')
augroup END

"************************* Netrw management--------------------------------------------------
" let g:netrw_browse_split = 4
" let g:netrw_winsize = 15
" let g:netrw_liststyle = 3
" let g:netrw_altv = 1
" let g:loaded_netrwFileHandlers = 1

" " Quit vim is netrw is the only buffer open
" augroup ProjectDrawer
"     autocmd!
"     autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" |q|endif
"     autocmd filetype netrw nn <buffer> cd :execute "cd ".b:netrw_curdir<cr>:pwd<cr>
" augroup END
" nn <leader>e <cmd>Lexplore<CR>
