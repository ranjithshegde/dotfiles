function! qf#qf_delete(bufnr) range
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
