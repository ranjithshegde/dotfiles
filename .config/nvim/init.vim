"**************Neovim basics -------------------------------------------------------------
lua require ('plugins')
lua require ('settings').settings()
lua require 'mappings'.general()
lua require 'mappings'.autoComplete()
lua require 'statusline'
" lua require 'scnvim'

function! TabLine()
  return luaeval("require'statusline'.init()")
endfunction
set tabline=%!TabLine()

if executable('rg') 
  set grepprg=rg\ --vimgrep 
endif

nn <silent><leader>fm = gg=G<C-o>zz

set dictionary+=$HOME/.local/share/dict/words

" augroup terminal_setup | au!
"   autocmd TermOpen * nnoremap <buffer><LeftRelease><RightRelease>i
" augroup end

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

"**************	OpenFrameworks----------------------------------------------------------------

function! Clang()
  packadd vim-ccls
  nnoremap <buffer> <leader>rt :!ctags -R .<CR>
  let g:ccls_levels = 5
  setlocal commentstring=//%s
  lua require 'mappings'.clang()
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
  " packadd LanguageTool.nvim
endfu
com! Gram call WordProcessor()

"************** FileTypes & AutoCompiles-----------------------------------------------

"Open new floating terminal
nnoremap <leader>fr :FloatermNew ranger<CR>

augroup fileTypes
  au FileType * lua require'mappings'.nvim_lsp()
  au FileType c,cpp,hpp,glsl call Clang()
  au FileType gitcommit lua require'mappings'.git_commit()
  au FileType cpp,c,arduino lua require'mappings'.arduino()
  au filetype text,vimwiki,tex call WordProcessor()
  au filetype html nmap <F4> : exec 'silent !qutebrowser % &'
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


