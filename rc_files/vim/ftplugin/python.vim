" Make fold on indention
setlocal foldmethod=indent
" Add syntax based autocompletion to omnicompletion: <C-x><C-o>
" If python file loaded load the python3 completion
" Only needed for vim (not neovim)
if !has('nvim')
    setlocal omnifunc=python3complete#Complete
    setlocal completefunc=syntaxcomplete#Complete
    " Conflicts with neovim
    " Sets K to look in pydocs. 
    " Not great, but helps. Can highlight for better results
    setlocal keywordprg=:Pydoc
endif
" Extend matching for keywords (ctags needs --extras=+q)
" Note: iskeyword+=. breaks LSP completion (LSP needs '.' as a trigger char)
if !has('nvim')
    setlocal iskeyword+=.
endif
