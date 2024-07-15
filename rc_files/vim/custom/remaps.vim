"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""" VIM Remaps """""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove trailing whitespaces on write
"autocmd BufWrite * :%s/\s\+$//g
command CleanFile normal! :%s/\s\+$//g<CR>

" Makes * not jump to next word (but may move screen)
nnoremap * *``
"" Git commands (Uses command line mode ":")
command Add normal! :!git add %<CR>
command Commit normal! :!git commit<CR>
command Push normal! :!git push<CR>
command Log normal! :!git log --graph --oneline --decorate<CR>
command Pull normal! :!git pull<CR>
command Status normal! :!git status<CR>

" Open all buffers in a new tab (open bunch of files then run this)
command Buf2Tab normal! :bufdo tab split<CR>
" Turn into a hex editor
command Hex normal! :%!xxd<CR>
"Return to last edit position
autocmd BufReadPost * 
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ endif

"Search and replace text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>
" Open vimgrep and put the cursor in the right position
noremap <leader>grep :vimgrep // **/*.<left><left><left><left><left><left><left>
" Vimgrep in the current file
noremap <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

""""""""""""""""""""""""""""""""""""""""
" Shortcuts using <leader>
""""""""""""""""""""""""""""""""""""""""
" Spelling shortcuts
noremap <leader>sn ]s   | " Move to next misspelled word 
noremap <leader>sp [s
noremap <leader>sa zg   | " Make word good
noremap <leader>s? z=   | " get suggestions

" Map for version incrementation.
" Will save and update version
noremap <Leader>x  :g/Version/norm! $h <C-A><CR>:x<CR>
noremap <Leader>w  :g/Version/norm! $h <C-A><CR>:call feedkeys("``")<CR>:w<CR>
noremap <Leader>v+ :g/Version/norm! $h <C-A><CR>:call feedkeys("``")<CR>:w<CR>
noremap <Leader>v- :g/Version/norm! $h <C-X><CR>:call feedkeys("``")<CR>:w<CR>

""""""""""""""""""""""""""""""""""""""""
" Filetype commands
" Make sure to use localleader and 
" <buffer>
""""""""""""""""""""""""""""""""""""""""
" ===== Python =====
function! PythonSettings()
    " Sets K to look in pydocs. 
    " Not great, but helps. Can highlight for better results
    setlocal keywordprg=:Pydoc
endfunction
autocmd FileType py call PythonSettings()

" ===== C / C++ =====
" C shortcuts \m executes make, \mc executes make clean
function! MakeSettings()
    noremap <localleader>m :make<cr>
    noremap <localleader>mc :make clean<cr>
    noremap <localleader>md :make distclean<CR>
    " run with :make
    cnoremap <buffer>make :make<cr>
endfunction

function! CSettings()
    " C \gcc builds C file with no extensions, using gcc
    noremap <localleader>gcc :!gcc % -o %:r<CR>
endfunction
function! CPPSettings()
    " C++ \cpp builds C++ file with no extension, using g++
    map <localleader>cpp :!g++ % -o %:r<CR>
    map <localleader>gcc :!g++ % -o %:r<cr>
endfunction
autocmd FileType cpp call MakeSettings()
autocmd FileType cpp call CPPSettings()
autocmd FileType c call CSettings()

" ===== LaTeX =====
function! TexSettings()
    " tex compile on current file
    nnoremap <buffer> <localleader>tex :!pdflatex %<CR>
    " Tex make files can be finicky so we make, touch (to change) and run
    " make again. This will help ensure we get cites and links
    cnoremap <buffer>make :make<CR> touch %<CR> make<CR>
    nnoremap <localleader>m :make<cr>
    nnoremap <localleader>mc :make clean<cr> touch %<cr> make
endfunction
autocmd FileType plaintex call TexSettings()

" ===== Markdown =====
function! MarkdownSettings()
    " Operate on header of section. i.e. 'cih' = delete header and go to insert
    " mode. 'dih' = delete header. Header defined by underline with == or --
    onoremap ih :<c-u>execute "normal !?^\(==\|--\)\\+$\r:nohlsearch\rkvg_"<cr>
endfunction
autocmd FileType md call MarkdownSettings()
