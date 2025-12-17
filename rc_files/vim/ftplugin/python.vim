" Make fold on indention
set foldmethod=indent
" Sets K to look in pydocs. 
" Not great, but helps. Can highlight for better results
setlocal keywordprg=:Pydoc
" Add syntax based autocompletion to omnicompletion: <C-x><C-o>
filetype plugin on
set omnifunc=syntaxcomplete#Complete
" If python file loaded load the python3 completion
" Must be built with +python3
autocmd FileType python setlocal omnifunc=python3complete#Complete
" Extend matching for keywords
set iskeyword+=.
