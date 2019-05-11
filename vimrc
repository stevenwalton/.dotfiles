syntax on               "Turns on Syntax highlighting 
set mouse=a             "For people that can't use vim
set path+=**            "Recursive path lookup

set t_Co=256
"set cursorline          "Highlight current line
set nocompatible        "Cool stuff in Vim. Makes vi non-compatible 
set lazyredraw          "Faster rendering
set showcmd             "Show command as typing
set wildmenu            "wildmenu buffer, auto completion

" Indenting
set autoindent          "Auto indent
" No indenting on # mark 
set cindent             " Uses C indenting rules (spaces)
set cinkeys-=0#
set indentkeys-=0#
set wrap                "Wraps text
set expandtab           "Spaces and not tabs
set smarttab            "Trys to figure out when to tab
set shiftwidth=4        "Tab width 
set softtabstop=4

set number ruler        "Show line number
set showmode            "Shows mode in bottom left

set scrolloff=5         "Keep at lease 5 lines above and below
set colorcolumn=80      " Vertical white bar at 80 chars

"Error bells.  All are off
set noerrorbells        "Removes error bells
set novisualbell        "Removes visual bells
set t_vb=               "Sets visual bell


"searching
set incsearch           "Search command while typing
set hlsearch            "Highlights all misspelled words
set showmatch           "Shows matching brackets
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>
set ignorecase          " ignore case. Same as /csearchterm
set smartcase           "for searching

"Splitting
set splitright          "Puts new window to right of current (vsplit)
set splitbelow          "Same but below (split)

"Ctags
set tags="./.tags,../.tags,~/.tags"

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

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
   Plugin 'VundleVim/Vundle.vim'
   Plugin 'scrooloose/nerdtree' "Bound to \nt (left)
   Plugin 'godlygeek/tabular' "Tab /delimiter
   "Plugin 'vim-airline/vim-airline' " That bottum line you have
   "Plugin 'tpope/vim-fugitive' " Git wrapper
   Plugin 'scrooloose/syntastic' " Syntax highlighting
   Plugin 'taglist.vim'
   " From jez/vim-as-an-ide
   Plugin 'octol/vim-cpp-enhanced-highlight'
   "Plugin 'xolox/vim-misc'
   "Plugin 'xolox/vim-easytags'
   Plugin 'majutsushi/tagbar'  " Bound to \tb (right)
   "Plugin 'ctrlpvim/ctrlp.vim'
   "Plugin 'vim-scripts/a.vim'
   Plugin 'airblade/vim-gitgutter' " Shows diff from git in left sidebar (fantastic)
   " Add debug
   "Plugin 'Shougo/vimproc'
   Plugin 'mbbill/undotree' " Creates an undo tree, bound to \ut (left)
   "Plugin 'vim-scripts/Conque-GDB' " :(
   Plugin 'ludovicchabant/vim-gutentags' " Auto generates tab
call vundle#end()

filetype plugin indent on
" :PluginInstall Install plugins
" :PluginClean cleans removal of unused plugins
" :PluginList
" :PluginSearch foo -searches for foo
"" Mapping and Plugin section

" CtrlP
map <Leader>p :CtrlP<CR>
map <Leader>bp :CtrlPBuffer<CR>

" Sensible defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1
" tagbar settings
" Open close tagbar with \b
nmap <silent> <leader>tb :TagbarToggle <CR>

" Gitgutter settings
"   let g:airline#extensions#hunks#non_zero_only = 1


" NERDTree Options
let g:NERDTreeDirArrows=0
" Toggle NERDTree with \nt
map <Leader>nt :NERDTreeToggle<CR>

" auto open UndoTree
let g:undotree_SplitWidth = 25
map <Leader>ut :UndotreeToggle<CR>

" Syntastic Options
command Synt normal! :SyntasticToggleMode<CR>
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_check_header = 1
let g:syntastic_loc_list_height = 3

" Syntax for c++
let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:syntastic_cpp_check_header = 1 " Checks headers
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_checkers = ['gcc']

" Airline configuration
"   let g:airline#extensions#tabline#enabled = 1
"   " Comment this out if you don't have powerline fonts. Or install them from the
"   " font directory
"   let g:airline_powerline_fonts = 1

" ConqueGDB
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly  


" Map for version incrementation. 
" Will save and update version
map <Leader>x  :g/Version/norm! $h <C-A><CR>:x<CR>
map <Leader>w  :g/Version/norm! $h <C-A><CR>:call feedkeys("``")<CR>:w<CR>
map <Leader>v+ :g/Version/norm! $h <C-A><CR>:call feedkeys("``")<CR>:w<CR>
map <Leader>v- :g/Version/norm! $h <C-X><CR>:call feedkeys("``")<CR>:w<CR>


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
    set undofile
    set undodir=~/.vim/undodir
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Custom Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Make
map <Leader>mm :make<CR>
map <Leader>mc :make clean<CR>
map <Leader>md :make distclean<CR>

""LaTeX  \tex builds latex file
map <Leader>tex :!pdflatex %<CR>
cnoremap texmake :make<CR> touch %<CR> make<CR>
" C++ \cpp builds C++ file with no extension, using g++
map <Leader>cpp :!g++ % -o %:r<CR>
" C \gcc builds C file with no extensions, using gcc
map <Leader>gcc :!gcc % -o %:r<CR>

"" Git commands (Uses command line mode ":")
command Add normal! :!git add %<CR>
command Commit normal! :!git commit<CR>
command Push normal! :!git push<CR>
command Log normal! :!git log --graph --oneline --decorate<CR>
command Pull normal! :!git pull<CR>
command Status normal! :!git status<CR>

" Turn into a hex editor
command Hex normal! :%!xxd<CR>

" Hack (keep at bottom)
try
   colorscheme vividchalk   "Colour Scheme (in ~/.vim/colors)
catch
   colorscheme peachpuff   "backup colour scheme (in /usr/share/vim...)
endtry

