set foldmethod=marker
" C++ \cpp builds C++ file with no extension, using g++
map <localleader>cpp :!g++ % -o %:r<CR>
map <localleader>gcc :!g++ % -o %:r<cr>
autocmd Filetype cpp setlocal foldmethod=marker
" Extend matching for keywords
set iskeyword+=.,-,>
