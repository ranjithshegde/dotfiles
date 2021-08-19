"************************ CamelCase -------------------------------------------------
function! util#CamelCase() abort
    PackerLoad CamelCaseMotion
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

"************** Word Processor ----------------------------------------------------
" Word Processor 
func! util#WordProcessor() abort
    setlocal wrap
    setlocal linebreak
    setlocal noexpandtab
    setlocal spell spelllang=en_us
    set complete+=k
    set thesaurus+=$HOME/.config/nvim/thesaurus/mthesaur.txt

    "add double spacing
    nn <leader><Space> :g/^/pu =\"\n\"<CR>
    nn zG <cmd>call writefile([expand("<cword>")], "/usr/share/words.txt", "a")<CR>
endfu

"************** custom Sudo ----------------------------------------------------
func! util#sudoWrite() abort
    w !sudo tee %
endfu

"************************************ Ranger  --------------------------------------------------

if !exists('s:choice_file_path')
    let s:choice_file_path = '/tmp/chosenfile'
endif

function! util#OpenRangerIn(path, edit_cmd) abort
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


"***************************** Better quickfixmanagement-------------------------

function! util#qf_delete(bufnr) range
    " get current qflist
    let l:qfl = getqflist()
    " no need for filter() and such; just drop the items in range
    call remove(l:qfl, a:firstline - 1, a:lastline - 1)
    " replace items in the current list, do not make a new copy of it;
    " this also preserves the list title
    call setqflist([], 'r', {'items': l:qfl})
    " restore current line
    call setpos('.', [a:bufnr, a:firstline, 1, 0])
endfunction
