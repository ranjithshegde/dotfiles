"************** Direcyoty browsing, structres and navigation -----------------------------------------

" let g:netrw_banner = 0
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

"Netrw Toggle
let g:NetrwIsOpen=0
function! drawer#ToggleNetrw() abort
	if g:NetrwIsOpen
		let i = bufnr('$')
		while (i >= 1)
			if (getbufvar(i, '&filetype') ==# 'netrw')
				silent exe 'bwipeout ' . i 
			endif
			let i-=1
		endwhile
		let g:NetrwIsOpen=0
	else
		let g:NetrwIsOpen=1
		silent Lexplore
	endif
endfunction
