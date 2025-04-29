
" Split to right 
let g:netrw_altv = 1
"""""""""""""""""""""""""""""""""""""""""""""""""
" K / docs
" When you press "K" hovering over a keyword you 
" will get the docs of that keyword. By default
" this works for C/C++, using man, and if you're
" in a vim file that'll work too using the help
" command. 
" Let's make that work for python and maybe more
" see :help keywordprg and :help K
"
" The Problem:
" We can try the simple version
" autocmd FileType python setlocal keywordprg=:Pydoc
" This will work, but only for native python functions
" It WILL work if you highlight the whole term
" (e.g. <C-V> over torch.randn) but it also shows 
" an error about not being in pydoc and won't 
" work if you import as or from. 
"
" On the other hand, if you use iPython, you can
" even do something like
" import torch
" x = torch.randn(5)
" help(x.exp)
" We want this!
" (note that `help(x.exp())` pulls up Tensor's docs. 
" We don't want this)
"
" Author: Steven Walton
" Licence: MIT
""""""""""""""""""""""""""""""""""""""""""""""""""
function! FindImports()
    let fileimports=
endfunction
