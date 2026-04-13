setlocal foldmethod=marker
" C++ \cpp builds C++ file with no extension, using g++
map <localleader>cpp :!g++ % -o %:r<CR>
map <localleader>gcc :!g++ % -o %:r<cr>
" Extend matching for keywords
setlocal iskeyword+=.,-,>
setlocal cindent
