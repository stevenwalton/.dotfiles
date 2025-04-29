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

" NetRW options (file browser)
" Should explore more. Seems netrw can do a lot and we could
" drop NerdTree. There's info about remote connections and 
" even bookmarks...
" Thanks: https://shapeshed.com/vim-netrw/
" Hide banner
let g:netrw_banner = 0
" Tree style listing
let g:netrw_liststyle = 3
" Hide these files (regex)
let g:netrw_list_hide = '.*\.sw[op]$'
" Open like previous window
let g:netrw_browse_split = 0
" Preview file
let g:netrw_preview = 1
"let g:netrw_winsize = 15
" Split to right (Need altv = 1 AND alto = 0)
let g:netrw_altv = 1
let g:netrw_alto = 0
" Human readable sizes
let g:netrw_sizestyle = 'H'

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
    " Add syntax based autocompletion to omnicompletion: <C-x><C-o>
    filetype plugin on
    set omnifunc=syntaxcomplete#Complete
    " If python file loaded load the python3 completion
    " Must be built with +python3
    autocmd FileType python setlocal omnifunc=python3complete#Complete
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
    " MARKDOWN
    syn match markdownIgnore "\$.*_.*\$" " Doesn't highlight _ while in latex
    " tex compile on current file
    nnoremap <buffer> <localleader>tex :!pdflatex %<CR>
    " Tex make files can be finicky so we make, touch (to change) and run
    " make again. This will help ensure we get cites and links
    "cnoremap <buffer>make :make<CR> touch %<CR> make<CR>
    cnoremap <buffer>make :make<CR>
    nnoremap <localleader>m :make<CR>
    "nnoremap <localleader>mc :make clean<cr> touch %<cr> make
    nnoremap <localleader>mc :make clean<CR>
    " Ignore indenting when...
    " https://vi.stackexchange.com/questions/20560/why-does-vim-still-auto-indent-latex-after-i-set-noai-noci-nosi
    " Note that there are no help pages for these files 😡
    " But do look at :h ft-tex
    let g:vimtex_indent_ignored_envs = [
        \ 'document', 
        \ 'verbatim', 
        \ 'lstlisting', 
        \ 'frame',
        \]
endfunction
" Note: setfiletype only sets if ft is unset. 
" We need to reset filetype to 'tex' for this to work correctly.
" Not sure why au FileType plaintex call TexSettings doesn't work.
autocmd BufNewFile,BufRead *.tex set filetype=tex
autocmd FileType tex call TexSettings()

" ===== Markdown =====
function! MarkdownSettings()
    " Operate on header of section. i.e. 'cih' = delete header and go to insert
    " mode. 'dih' = delete header. Header defined by underline with == or --
    onoremap ih :<c-u>execute "normal !?^\(==\|--\)\\+$\r:nohlsearch\rkvg_"<cr>
    " MARKDOWN
    syn match markdownIgnore "\$.*_.*\$" " Doesn't highlight _ while in latex
endfunction
autocmd FileType md call MarkdownSettings()
