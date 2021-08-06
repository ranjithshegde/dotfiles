"**************Neovim basics -------------------------------------------------------------
lua require ('plugins')
lua require ('settings').settings()
lua require ('mappings').general()

" hi LspSignatureActiveParameter guifg=#2E3440 guibg=#F2AF5C

" Custom tabline
function! TabLine()
    return luaeval("require'statusline'.tabs()")
endfunction
set tabline=%!TabLine()

"************** FileTypes & AutoCompiles-----------------------------------------------

augroup GenericFiles
    au FileType text,tex,vimwiki call util#WordProcessor()
    au FileType org setlocal iskeyword+=:,#,+
    au FileType vim nn <silent>,K <cmd>exe 'h '.expand('<cword>')<CR> |
                \ set foldexpr=getline(v:lnum)[0]==\"\\t\"
augroup end 

augroup MakeDispatch
    au FileType java,lua,python,javascript nn <F5> <cmd>w<CR><cmd>Dispatch<CR> |
                \ nn <F10> <cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR> |
                \ tno <F10> <esc><cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR>
augroup END

"************************ Terminal management -------------------------------------------------
augroup termInsert
    autocmd!
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd TermEnter * startinsert
    autocmd TermClose * call nvim_input('<CR>')
augroup END

"************************* Netrw management--------------------------------------------------
let g:netrw_browse_split = 4
let g:netrw_winsize = 15
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:loaded_netrwFileHandlers = 1

" Quit vim is netrw is the only buffer open
augroup ProjectDrawer
    autocmd!
    autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" |q|endif
    autocmd filetype netrw nn <buffer> cd :execute "cd ".b:netrw_curdir<cr>:pwd<cr>
augroup END
nn <leader>e <cmd>Lexplore<CR>
