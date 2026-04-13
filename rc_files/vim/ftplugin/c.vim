" Fold on markers (default markers are curly braces)
setlocal foldmethod=marker
" C \gcc builds C file with no extensions, using gcc
noremap <localleader>gcc :!gcc % -o %:r<CR>
" Extend matching for keywords
setlocal iskeyword+=.,-,>
setlocal cindent
