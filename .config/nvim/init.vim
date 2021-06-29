"**************Neovim basics -------------------------------------------------------------
lua require ('plugins')
lua require ('settings').settings()
lua require ('mappings').general()
lua require ('mappings').autoComplete()
lua require 'statusline'
lua require 'compiler'
source ~/.cache/calendar.vim/credentials.vim

" Custom tabline
function! TabLine()
	return luaeval("require'statusline'.init()")
endfunction
set tabline=%!TabLine()

" Change local grep
set grepprg=rg\ --vimgrep 
" Set dictionary
set dictionary+=$HOME/.local/share/dict/words

"************************ Built in LSP-------------------------------------------------

nnoremap <silent> K :call Show_documentation()<CR>
" Use keyords, hower functions and vim help-system as available
function! Show_documentation()
	if (&ft==#'supercollider')
		execute &keywordprg . ' ' . expand('<cword>')
	elseif (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		lua vim.lsp.buf.hover()
	endif
endfunction

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
	au FileType * lua require'mappings'.nvim_lsp()
	au FileType gitcommit lua require'mappings'.git_commit()
	au FileType text,tex,vimwiki call WordProcessor()
	au FileType cpp,c,lua,python,javascript,java,toml,yaml,conf,json,supercollider,bib set foldexpr=nvim_treesitter#foldexpr()
augroup end 

augroup MakeDispatch
	au FileType java,lua,python,javascript nn <F5> <cmd>w<CR><cmd>Dispatch<CR>
	au FileType java,lua,python,javascript nn <F10> <cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR>
	au FileType java,lua,python,javascript tnoremap <F10> <esc><cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR>
augroup END

augroup TexFiles
	autocmd!
	au FileType tex,bib nmap <F3> <plug>(vimtex-clean-full)
	au FileType tex,bib nmap <F5> <plug>(vimtex-compile)
	au FileType tex,bib nmap <F6> <plug>(vimtex-view)
	au FileType tex set foldexpr=vimtex#fold#level(v:lnum)
augroup END

"************************ Terminal management -------------------------------------------------
augroup termInsert
	autocmd!
	autocmd BufWinEnter,WinEnter term://* startinsert
	autocmd TermEnter * startinsert
	autocmd BufLeave term://* stopinsert
	autocmd TermClose *  call nvim_input('<CR>')
augroup END
