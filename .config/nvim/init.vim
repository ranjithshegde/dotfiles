"**************Neovim basics -------------------------------------------------------------
lua require ('plugins')
lua require ('settings').settings()
lua require ('mappings').general()
lua require ('mappings').autoComplete()
lua require 'statusline'
lua require 'compiler'

" hi Normal guibg=none ctermbg=none
" hi LineNr guibg=none ctermbg=none
" hi Folded guibg=none ctermbg=none
" hi NonText guibg=none ctermbg=none
" hi SpecialKey guibg=none ctermbg=none
" hi VertSplit guibg=none ctermbg=none
" hi SignColumn guibg=none ctermbg=none
" hi EndOfBuffer guibg=none ctermbg=none


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

nnoremap <silent> K :call <SID>show_documentation()<CR>
" Use keyords, hower functions and vim help-system as available
function! s:show_documentation()
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
	" movement changes
	map j gj
	map k gk
	" formatting text
	setlocal formatoptions=1
	setlocal noexpandtab
	setlocal wrap
	setlocal linebreak
	set thesaurus+=$HOME/.config/nvim/thesaurus/mthesaur.txt
	" spelling and thesaurus
	setlocal spell spelllang=en_us
	set complete+=k
	packadd vim-grammarous
endfu
com! Gram call WordProcessor()

"************** File permissions  ----------------------------------------------------
func! SuWrite()
	w !sudo tee %
endfu
com! Su call SuWrite()

"************** FileTypes & AutoCompiles-----------------------------------------------

function! GitRepo() 
silent! !git rev-parse --is-inside-work-tree
if v:shell_error == 0
	PackerLoad vim-fugitive
	PackerLoad gitsigns.nvim
endif
endfunction

augroup GitRepos
	au BufEnter * call GitRepo()
augroup end


"Open new floating terminal
nnoremap <leader>fr :FloatermNew ranger<CR>

augroup GenericFiles
	au FileType * lua require'mappings'.nvim_lsp()
	au FileType gitcommit lua require'mappings'.git_commit()
	au filetype text,vimwiki,tex call WordProcessor()
	au filetype html nmap <F4> : exec 'silent !qutebrowser % &'
augroup end 

augroup MakeDispatch
	au FileType java let b:dispatch = 'javac %'
	au FileType lua let b:dispatch = 'lua %'
	au FileType python let b:dispatch = 'python %'
	au FileType javascript let b:dispatch = 'node %'
	au FileType java,lua,python,javascript nn <F5> <cmd>w<CR><cmd>Dispatch<CR>
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
