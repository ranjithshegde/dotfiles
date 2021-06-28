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

"**************	C Projects ----------------------------------------------------------------

function! Clang()
	let g:ccls_levels = 5
	setlocal commentstring=//%s
	lua require('compiler').set_ctype()
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
	au FileType vimwiki,markdown setlocal tabstop=2
	au FileType tex set foldexpr=vimtex#fold#level(v:lnum)
augroup end 

augroup MakeDispatch
	au FileType java let b:dispatch = 'javac %'
	au FileType java let g:repl = 'javac'
	au FileType lua let b:dispatch = 'lua %'
	au FileType lua let g:repl = 'lua'
	au FileType python let b:dispatch = 'python %'
	au FileType python let g:repl = 'ipython'
	au FileType javascript let b:dispatch = 'node %'
	au FileType javascript let g:repl = 'node'
	au FileType java,lua,python,javascript nn <F5> <cmd>w<CR><cmd>Dispatch<CR>
	au FileType java,lua,python,javascript nn <F10> <cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR>
	au FileType java,lua,python,javascript tnoremap <F10> <esc><cmd>lua require('utils').toggleTerm(vim.g.repl, "repl", 0)<CR>
	au FileType html nn <F5> : exec 'silent !qutebrowser % &'
	au FileType markdown,vimwiki nn <F5> <cmd>MarkdownPreview<CR>
augroup END

augroup TexRemap
	autocmd!
	au FileType tex,bib nmap <F3> <plug>(vimtex-clean-full)
	au FileType tex,bib nmap <F5> <plug>(vimtex-compile)
	au FileType tex,bib nmap <F6> <plug>(vimtex-view)
augroup END

augroup CFiles
	au FileType c,cpp,cmake call Clang()
augroup end

"************************ CamelCase -------------------------------------------------
function! CamelCase()
	packadd CamelCaseMotion
	map <silent> w <Plug>CamelCaseMotion_w
	map <silent> b <Plug>CamelCaseMotion_b
	map <silent> e <Plug>CamelCaseMotion_e
	map <silent> ge <Plug>CamelCaseMotion_ge
	sunmap w
	sunmap b
	sunmap e
	sunmap ge

	omap <silent> iw <Plug>CamelCaseMotion_iw
	xmap <silent> iw <Plug>CamelCaseMotion_iw
	omap <silent> ib <Plug>CamelCaseMotion_ib
	xmap <silent> ib <Plug>CamelCaseMotion_ib
	omap <silent> ie <Plug>CamelCaseMotion_ie
	xmap <silent> ie <Plug>CamelCaseMotion_ie

	imap <silent> <S-Left> <C-o><Plug>CamelCaseMotion_b
	imap <silent> <S-Right> <C-o><Plug>CamelCaseMotion_w
endfunction
com! Cam call CamelCase()

"************************ Terminal management -------------------------------------------------
augroup termInsert
	autocmd!
	autocmd BufWinEnter,WinEnter term://* startinsert
	" autocmd TermOpen * startinsert
	autocmd TermEnter * startinsert
	autocmd BufLeave term://* stopinsert
	autocmd TermClose term://*  call nvim_input('<CR>')
augroup END
