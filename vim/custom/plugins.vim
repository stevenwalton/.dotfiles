"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""" VIM Plugin Options"""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep at top. Helps ensure that format options work correctly
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
" :PluginInstall Install plugins
" :PluginClean cleans removal of unused plugins
" :PluginList
" :PluginSearch foo -searches for foo
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    """"" Editing
    Plugin 'frazrepo/vim-rainbow'            " Improved Parentheses
    Plugin 'sheerun/vim-polyglot'            " Comprehensive syntax highlighting
    Plugin 'xolox/vim-misc'                  " Needed for easy-tags
    "Plugin 'xolox/vim-easytags'              " Automatically creates tags
    Plugin 'ludovicchabant/vim-gutentags'    " Ctags
    Plugin 'MattesGroeger/vim-bookmarks'     " Annotated marks
    """"" Interface
    Plugin 'pineapplegiant/spaceduck'        " Spaceduck theme
    Plugin 'ryanoasis/vim-devicons'          " Font icons helpful for nerdtree/airline
    Plugin 'scrooloose/nerdtree'             " Project drawer (File explorer)
    Plugin 'tiagofumo/vim-nerdtree-syntax-highlight' " Increased syntax highlighting for nerdtree
    Plugin 'vim-airline/vim-airline'         " That bottum line you have
    Plugin 'vim-airline/vim-airline-themes'
    Plugin 'taglist.vim'                     " Helps with determining code structure (:TlistToggle)
    Plugin 'majutsushi/tagbar'               " Bound to \tb (right)
    Plugin 'linediff.vim'
    Plugin 'nathanaelkane/vim-indent-guides' " Shows the indents
    """"" Integrations
    Plugin 'airblade/vim-gitgutter'          " Shows diff from git in left sidebar (fantastic)
    Plugin 'rhysd/git-messenger.vim'         " Shows commit message associated with line of code
    Plugin 'iamcco/markdown-preview.nvim'
    Plugin 'xuyuanp/nerdtree-git-plugin'     " Integration for git with nerdtree
    """"" Commands
    Plugin 'godlygeek/tabular'               " Tab /delimiter
    " Plugin 'segeljakt/vim-silicon'          " Screenshot highlighted text :Silicon fname
    " Shougo/unite.vim                       " Plugin for development: make user interfaces
call vundle#end()
call mkdp#util#install()

filetype plugin indent on

" Rainbow Parenthesis 
let g:rainbow_active = 1
autocmd VimEnter * RainbowLoad
"let g:rainbow_load_separately = [
"    \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"    \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
"    \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"    \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
"    \ ]
"
"let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
"let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']
"autocmd VimEnter * RainbowLoad

" Bookmarks
" Bookmark toolbar
nmap <Leader>bm <Plug>BookmarkShowAll
" Enable line highlighting (False)
let g:bookmark_highlight_lines = 0
" Save bookmarks per working directory (False)
let g:bookmark_save_per_working_dir = 0
" Display annotation in status line
let g:bookmark_display_annotation = 1
" Mapped Commands
" mm :BookmarkToggle
" mi :BookmarkAnnotate
" mn :BookmarkNext
" mp :BookmarkPrev
" ma :BookmarkShowAll
" mc :BookmarkClear
" mx :BookmarkClearAll
" mkk :BookmarkMoveUp
" mjj :BookmarkMoveDown

"
" SpaceDuck
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" Sensible defaults
"let g:easytags_events = ['BufReadPost', 'BufWritePost']
"let g:easytags_async = 1
"let g:easytags_dynamic_files = 2
"let g:easytags_resolve_links = 1
"let g:easytags_suppress_ctags_warning = 1
"
" GutenTags
set statusline+=%{gutentags#statusline()}
" Root directory is considered if it has one of these files in it
let g:gutentags_project_root = ['.git', 'Makefile', 'src', 'main.py']
" Write ctags to this location instead
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_ctags_exclude = [
    \ 'wandb/',
    \ '.git',
    \ '.DS_Store',
    \ '__*__',
    \ '*.pth',
    \ '*.tar',
    \ '*.gz'
    \ ]
let g:gutentags_ctags_exclude_wildignore = 1
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]
"                  ||||||_ Signature of routine
"                  |||||__ Line number of tag def 
"                  ||||___ Implementation info
"                  |||____ Language of input file
"                  ||_____ Inheritance 
"                  |______ Access of Class Member

" tagbar settings
" Open close tagbar with \b
nmap <silent> <leader>tb :TagbarToggle <CR>

" Gitgutter settings
let g:airline#extensions#hunks#non_zero_only = 1

" NERDTree Options
let g:NERDTreeDirArrows=0
let NERDTreeWinSize=20
" Toggle NERDTree with \nt
map <Leader>nt :NERDTreeToggle<CR>

" auto open UndoTree
let g:undotree_SplitWidth = 25
map <Leader>ut :UndotreeToggle<CR>

" Airline configuration
let g:airline#extensions#tabline#enabled = 1
" Comment this out if you don't have powerline fonts. Or install them from the
" font directory
let g:airline_powerline_fonts = 1
let g:airline_theme='spaceduck'

" ConqueGDB
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly

" Markdown Preview
let g:mkdp_auto_close = 0

let g:silicon = {
    \ 'theme':              'Dracula',
    \ 'font':                  'Hack',
    \ 'background':         '#FFFFFF',
    \ 'shadow-color':       '#555555',
    \ 'line-pad':                   2,
    \ 'pad-horiz':                  0,
    \ 'pad-vert':                   0,
    \ 'shadow-blur-radius':         0,
    \ 'shadow-offset-x':            0,
    \ 'shadow-offset-y':            0,
    \ 'line-number':           v:true,
    \ 'round-corner':          v:false,
    \ 'window-controls':       v:false,
    \ }
