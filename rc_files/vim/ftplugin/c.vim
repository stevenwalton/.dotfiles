" Fold on markers (default markers are curly braces)
set foldmethod=marker
" C \gcc builds C file with no extensions, using gcc
noremap <localleader>gcc :!gcc % -o %:r<CR>
autocmd Filetype c setlocal foldmethod=marker
" Extend matching for keywords
set iskeyword+=.,-,>
