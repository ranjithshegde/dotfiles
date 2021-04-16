"************** Direcyoty browsing, structres and navigation -----------------------------------------

" let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 15
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:loaded_netrwFileHandlers = 1

function! NetrwMapping()
  nnoremap <buffer> cd  :execute "cd ".b:netrw_curdir<cr>:pwd<cr>
endfunction

augroup ProjectDrawer
  autocmd!
  autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
  autocmd filetype netrw call NetrwMapping()
augroup END
"Netrw Toggle
let g:NetrwIsOpen=0

function! ToggleNetrw()
  if g:NetrwIsOpen
    let i = bufnr("$")
    while (i >= 1)
      if (getbufvar(i, "&filetype") == "netrw")
	silent exe "bwipeout " . i 
      endif
      let i-=1
    endwhile
    let g:NetrwIsOpen=0
  else
    let g:NetrwIsOpen=1
    silent Lexplore
  endif
endfunction
noremap <silent> <leader>e :call ToggleNetrw()<CR>



"************** Arduino ---------------------------------------------------------------------

" au filetype arduino nnoremap <F5> :w <CR> :!arduino-cli compile --fqbn arduino:avr:uno % <CR>

" au filetype arduino nnoremap <F7> :w <CR> :!arduino-cli compile --fqbn teensy:avr:teensy31 % <CR>

" au filetype arduino nnoremap <F6> :w <CR> :!arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno % <CR>

" au filetype arduino nnoremap <F8> :w <CR> :!arduino-cli upload -p /dev/ttyACM0 --fqbn teensy:avr:teensy31 % <CR>

