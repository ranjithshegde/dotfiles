"**************Neovim basics -------------------------------------------------------------
lua require ('plugins')
lua require ('settings').settings()
lua require ('mappings').general()
lua require ('mappings').autoComplete()

" hi LspSignatureActiveParameter guifg=#2E3440 guibg=#F2AF5C

" Custom tabline
function! TabLine()
    return luaeval("require'statusline'.tabs()")
endfunction
set tabline=%!TabLine()

" Change local grep
set grepprg=rg\ --vimgrep 

" Set dictionary
set dictionary+=$HOME/.local/share/dict/words

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
