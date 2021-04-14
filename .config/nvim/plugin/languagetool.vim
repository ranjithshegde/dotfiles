" let g:languagetool_server_jar='$HOME/Software/Curls/languagetool/languagetool-server.jar'
" let g:languagetool = {
"             \ '.' : {
"             \       'disabledRules' : ''
"             \ },
"             \ }

" augroup LT
"   autocmd Filetype tex,text LanguageToolSetUp
"   autocmd User LanguageToolCheckDone LanguageToolSummary
" augroup end
" " " autocmd CursorHold * LanguageToolErrorAtPoint

" hi LanguageToolGrammarError  guisp=#8be9fd gui=undercurl guifg=#8be9fd guibg=NONE ctermfg=white ctermbg=blue term=underline cterm=none
" hi LanguageToolSpellingError guisp=#ff5555  gui=undercurl guifg=#ff5555 guibg=NONE ctermfg=white ctermbg=red  term=underline cterm=none

" let g:languagetool_server_command='languagetool '
" let g:languagetool_preview_flags = 'MC'
" let g:languagetool_useFloatting = 1

" let g:languagetool_debug = 1
" map <silent> <Leader>p :LanguageToolErrorAtPoint<CR>
