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
	autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" |q|endif
	autocmd filetype netrw call NetrwMapping()
augroup END
"Netrw Toggle
let g:NetrwIsOpen=0

function! ToggleNetrw()
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
noremap <silent> <leader>e :call ToggleNetrw()<CR>

"************************************ Ranger  --------------------------------------------------

if !exists('s:choice_file_path')
	let s:choice_file_path = '/tmp/chosenfile'
endif

function! OpenRangerIn(path, edit_cmd)
	let currentPath = expand(a:path)
	let rangerCallback = { 'name': 'ranger', 'edit_cmd': a:edit_cmd }
	function! rangerCallback.on_exit(job_id, code, event)
		if a:code == 0
			silent! Bclose!
		endif
		try
			if filereadable(s:choice_file_path)
				for f in readfile(s:choice_file_path)
					exec self.edit_cmd . f
				endfor
				call delete(s:choice_file_path)
			endif
		endtry
	endfunction
	enew
	if isdirectory(currentPath)
		call termopen('ranger' . ' --choosefiles=' . s:choice_file_path . ' "' . currentPath . '"', rangerCallback)
	else
		call termopen('ranger' . ' --choosefiles=' . s:choice_file_path . ' --selectfile="' . currentPath . '"', rangerCallback)
	endif
	startinsert
endfunction

nn <silent><leader>rvf <cmd>vnew<CR><cmd>call OpenRangerIn("%", "vs ")<CR>
nn <silent><leader>rvc <cmd>vnew<CR><cmd>call OpenRangerIn("%:p:h", "vs ")<CR>
nn <silent><leader>rvd <cmd>vnew<CR><cmd>call OpenRangerIn(".", "vs ")<CR>

nn <silent><leader>rtf <cmd>tabnew<CR><cmd>call OpenRangerIn("%", "tab drop ")<CR>
nn <silent><leader>rtc <cmd>tabnew<CR><cmd>call OpenRangerIn("%:p:h", "tab drop ")<CR>
nn <silent><leader>rtd <cmd>tabnew<CR><cmd>call OpenRangerIn(".", "tab drop ")<CR>
