let g:NERDTreeDirArrows=0
syntax on               "Turns on Syntax highlighting 
"Will try to use vividchalk.  If it doesn't exist then dark blue will be used
"for the colorscheme.
try
   colorscheme vividchalk   "Colour Scheme (in ~/.vim/colors)
catch
   colorscheme peachpuff   "backup colour scheme (in /usr/share/vim...)
endtry

set t_Co=256
set mouse=a             "Enables mouse function, won't highlight numbers
"set cursorline          "Highlight current line
set nocompatible        "Cool stuff in Vim
set lazyredraw          "Faster rendering
set showcmd             "Show command as typing
set wildmenu            "wildmenu buffer, auto completion

" Indenting
set autoindent          "Auto indent
set smartindent         "Guesses when to indent
"inoremap # X#     "Disables the auto-unindent from octothrope for python
set wrap                "Wraps text
set expandtab           "Spaces and not tabs
set smarttab            "Trys to figure out when to tab
set shiftwidth=3        "Tab width of 3
set softtabstop=3

set number ruler        "Show line number
set showmode            "Shows mode in bottom left

set scrolloff=5         "Keep at lease 5 lines above and below

"Error bells.  All are off
set noerrorbells        "Removes error bells
set novisualbell        "Removes visual bells
set t_vb=


"searching
set incsearch
set hlsearch            "Highlights all misspelled words
set showmatch           "Shows matching brackets
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>
set smartcase           "for searching

"Spell checking
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
set spell                     "Turns on Spellcheck
hi clear SpellBad             "Highlights misspelled words
hi SpellBad cterm=underline,bold ctermfg=white  "Makes misspelled words highlited, bold, and underline white
" Shortcuts using <leader> 
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Folding
set foldmethod=indent


"" Mapping and Plugin section

" C shortcuts \m executes make, \mc executes make clean
autocmd FileType cpp call MapCShortcuts()
function MapCShortcuts()
   map <leader>m :make<cr>          
   map <leader>mc :make clean<cr>
endfunction

autocmd BufReadPost *   "Return to last edit position
   \ if line("'\"") > 0 && line("'\"") <= line("$") |
   \ exe "normal! g`\"" |
   \ endif

"Search and replace text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>
" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgrep in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
" means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
 catch
endtry

"LaTeX  \tex builds latex file
map <Leader>tex :!pdflatex %<CR>
" C++ \cpp builds C++ file with no extension, using g++
map <Leader>cpp :!g++ % -o %:r<CR>
" C \gcc builds C file with no extensions, using gcc
map <Leader>gcc :!gcc % -o %:r<CR>

"Pathogen
syntax on
filetype plugin indent on
try 
   "Pathogen 
   "makes easier to install plugins by extracting zip to ~/.vim/bundles
   "https://github.com/tpope/vim-pathogen
   execute pathogen#infect()
   call pathogen#helptags() " generate helptags for everything in 'runtimepath'


   "git clone https://github.com/scrooloose/nerdtree.git
   autocmd VimEnter * NERDTree      "Autostart NERDTree with vim
   autocmd VimEnter * wincmd l      "When Vim starts the focus is on the editing screen and not on NERDTreee 
   autocmd VimEnter * NERDTreeToggle
catch
endtry
" Toggle NERDTree with \nt
map <Leader>nt :NERDTreeToggle<CR>


" Syntastic defaults
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_mode_map = {'passive_filetypes':['cpp']}                                             
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_cpp_check_header = 1


" Airline configuration
let g:airline#extensions#tabline#enabled = 1
" Comment this out if you don't have powerline fonts. Or install them from the
" font directory
let g:airline_powerline_fonts = 1


" Map vim obsessive
" starts Obsessive
map <Leader>ob :Obsess<CR>
" stops obsessive
map <Leader>ob! :Obsess!<CR>
