"**************Neovim basics -------------------------------------------------------------
lua require ('plugins')
lua require ('settings').settings()
lua require ('mappings').general()
lua require ('mappings').autoComplete()
lua require 'statusline'
" lua require 'compiler'

" Custom tabline
function! TabLine()
	return luaeval("require'statusline'.init()")
endfunction
set tabline=%!TabLine()

" Change local grep
set grepprg=rg\ --vimgrep 

" Set dictionary
set dictionary+=$HOME/.local/share/dict/words

"************** Word Processor ----------------------------------------------------------------
func! WordProcessor()
	setlocal noexpandtab
	setlocal wrap 
	setlocal linebreak
	setlocal tw=150
	setlocal colorcolumn=150
	" spelling and thesaurus
	set thesaurus+=$HOME/.config/nvim/thesaurus/mthesaur.txt
	setlocal spell spelllang=en_us
	set complete+=k
	"add double spacing
	nn <leader><Space> :g/^/pu =\"\n\"<CR>
	nn zG <cmd>call writefile([expand("<cword>")], "/usr/share/words.txt", "a")<CR>
endfu
com! Gram call WordProcessor()

"************** Functions ----------------------------------------------------
func! SuWrite()
	w !sudo tee %
endfu
com! Su call SuWrite()

function! GitRepo() 
	silent! !git rev-parse --is-inside-work-tree
	if v:shell_error == 0
		PackerLoad gitsigns.nvim
	endif
endfunction

augroup GitRepos
	au BufEnter * call GitRepo()
augroup end

"************** FileTypes & AutoCompiles-----------------------------------------------

augroup GenericFiles
	au FileType text,tex,vimwiki call WordProcessor()
	au FileType org setlocal iskeyword+=:,#,+
	au FileType vim nn <silent>,K <cmd>exe 'h '.expand('<cword>')<CR> |
				\ set foldexpr=getline(v:lnum)[0]==\"\\t\"
augroup end 

augroup MakeDispatch
	au FileType java,lua,python,javascript nn <F5> <cmd>w<CR><cmd>Dispatch<CR> |
				\ nn <F10> <cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR> |
				\ tnoremap <F10> <esc><cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR>
augroup END

augroup TexFiles
	autocmd!
	au FileType tex,bib nmap <F3> <plug>(vimtex-clean-full) |
				\ nmap <F5> <plug>(vimtex-compile) |
				\ nmap <F6> <plug>(vimtex-view)
	" au FileType tex set foldexpr=vimtex#fold#level(v:lnum)
augroup END

"************************ Terminal management -------------------------------------------------
augroup termInsert
	let g:gdbBuff = bufwinnr('gdb [-]')
	autocmd!
	autocmd BufWinEnter,WinEnter term://* startinsert
	autocmd TermEnter * startinsert
	if g:gdbBuff ==# 0
		autocmd BufLeave term://* stopinsert
	endif
	autocmd TermClose *  call nvim_input('<CR>')
augroup END
