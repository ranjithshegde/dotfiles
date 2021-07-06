augroup glsl
	autocmd!
	autocmd BufEnter,BufWinEnter,BufNewFile,BufRead *.fs set filetype=glsl
	autocmd BufEnter,BufWinEnter,BufNewFile,BufRead *.vs set filetype=glsl
augroup END

packadd vim-glsl
