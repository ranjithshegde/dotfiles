"************************************ Ranger  --------------------------------------------------

if !exists('s:choice_file_path')
	let s:choice_file_path = '/tmp/chosenfile'
endif

function! ranger#OpenRangerIn(path, edit_cmd) abort
	let currentPath = expand(a:path)
	let rangerCallback = { 'name': 'ranger', 'edit_cmd': a:edit_cmd }
	function! rangerCallback.on_exit(job_id, code, event) abort
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
