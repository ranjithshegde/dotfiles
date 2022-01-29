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

augroup formatOptions
    autocmd!
    autocmd FileType * set formatoptions+=cqnj2
    autocmd FileType * set formatoptions-=ator
augroup END

augroup commonFtRules
    au FileType text,tex,vimwiki,org call util#WordProcessor()
    au FileType org setlocal iskeyword+=:,#,+
    au FileType vim nn <silent>,K <cmd>exe 'h '.expand('<cword>')<CR>
augroup END 

augroup MakeDispatch
    au!
    au FileType java,lua,python,javascript nn<buffer><F5> <cmd>w<CR><cmd>Dispatch<CR> |
                \ nn <F10> <cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR> |
                \ tno <F10> <esc><cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR>
augroup END

augroup PluginLoad
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
augroup END 

"************************ Terminal management -------------------------------------------------
augroup terminalInsertModes
    autocmd!
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd TermEnter * startinsert
    autocmd TermClose * call nvim_input('<CR>')
augroup END
