"**************Neovim basics -------------------------------------------------------------
lua require ('plugins')
lua require ('settings').settings()
lua require 'mappings'.general()
lua require 'mappings'.autoComplete()
lua require 'statusline'

function! TabLine()
  return luaeval("require'statusline'.init()")
endfunction
set tabline=%!TabLine()

if executable("rg") 
  set grepprg=rg\ --vimgrep 
endif

nn <silent><leader>fm = gg=G<C-o>zz

set dictionary+=$HOME/.local/share/dict/words

"************************ Whichkey -------------------------------------------------
" nnoremap <silent><Space> :silent WhichKey '<Space>'<CR>
" nnoremap <silent><leader> :silent WhichKey '\'<CR>
" nnoremap <silent> <buffer>, :silent WhichKey ','<CR>
" vnoremap <silent> <buffer>, :silent WhichKeyVisual ','<CR>
" nnoremap <silent> , :silent WhichKey ','<CR>
" vnoremap <silent> , :silent WhichKeyVisual ','<CR>
" nnoremap <silent>;  :silent WhichKey ';'<CR>

"************************ Built in LSP-------------------------------------------------
nnoremap <silent> K :call <SID>show_documentation()<CR>
" Use keyords, hower functions and vim help-system as available
function! s:show_documentation()
  if (&ft=='supercollider')
    execute &keywordprg . " " . expand('<cword>')
  elseif (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    lua vim.lsp.buf.hover()
  endif
endfunction

"************** FileTypes & AutoCompiles-----------------------------------------------

"Open new floating terminal
nnoremap <leader>fr :FloatermNew ranger<CR>

augroup mappings
  autocmd FileType * lua require'mappings'.nvim_lsp()
  autocmd FileType gitcommit lua require'mappings'.git_commit()
  autocmd FileType cpp,c,arduino lua require'mappings'.arduino()
" html browser
  au filetype html nmap <F4> : exec 'silent !qutebrowser % &'
augroup end 

"**************	OpenFrameworks----------------------------------------------------------------

augroup c
  autocmd!
  autocmd FileType cpp,hpp,glsl call MakeRun()
augroup end

function! MakeRun()
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
autocmd filetype txt,vimwiki,tex call WordProcessor()
com! Gram call WordProcessor()

"************** Arduino ---------------------------------------------------------------------

" au filetype arduino nnoremap <F5> :w <CR> :!arduino-cli compile --fqbn arduino:avr:uno % <CR>

" au filetype arduino nnoremap <F7> :w <CR> :!arduino-cli compile --fqbn teensy:avr:teensy31 % <CR>

" au filetype arduino nnoremap <F6> :w <CR> :!arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno % <CR>

" au filetype arduino nnoremap <F8> :w <CR> :!arduino-cli upload -p /dev/ttyACM0 --fqbn teensy:avr:teensy31 % <CR>

