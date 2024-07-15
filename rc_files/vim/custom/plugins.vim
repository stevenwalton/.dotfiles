"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""" VIM Plugin Options"""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep at top. Helps ensure that format options work correctly
filetype off " Required
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
    Plugin 'MattesGroeger/vim-bookmarks'     " Annotated marks
    """"" Interface
    Plugin 'pineapplegiant/spaceduck'        " Spaceduck theme
    Plugin 'ryanoasis/vim-devicons'          " Font icons helpful for nerdtree/airline
    Plugin 'scrooloose/nerdtree'             " Project drawer (File explorer)
    Plugin 'vim-airline/vim-airline'         " That bottum line you have
    "Plugin 'vim-airline/vim-airline-themes'
    "Plugin 'taglist.vim'                     " Helps with determining code structure (:TlistToggle)
    Plugin 'majutsushi/tagbar'               " Shows a list of tags
    Plugin 'nathanaelkane/vim-indent-guides' " Shows the indents
    """"" Debugging 
    Plugin 'ludovicchabant/vim-gutentags'    " Ctags
    Plugin 'dense-analysis/ale'              " ALE for linting
    Plugin 'AndrewRadev/linediff.vim'        " Diff between visual selections
    """"" Integrations
    Plugin 'airblade/vim-gitgutter'          " Shows diff from git in left sidebar (fantastic)
    " Really need to make this work with popups in native vim instead of neo
    Plugin 'rhysd/git-messenger.vim'         " Shows commit message associated with line of code
    Plugin 'iamcco/markdown-preview.nvim'
    Plugin 'tiagofumo/vim-nerdtree-syntax-highlight' " Increased syntax highlighting for nerdtree
    Plugin 'xuyuanp/nerdtree-git-plugin'     " Integration for git with nerdtree
    Plugin 'PhilRunninger/nerdtree-buffer-ops' " Highlights files opened in a buffer
    """"" Commands
    Plugin 'godlygeek/tabular'               " Tab /delimiter
    " Plugin 'segeljakt/vim-silicon'          " Screenshot highlighted text :Silicon fname
    " Shougo/unite.vim                       " Plugin for development: make user interfaces
    " Testing
call vundle#end()
call mkdp#util#install()

filetype plugin indent on
"-------------------------------------------------------------------------------
"---------------------------------- Editing ------------------------------------
"-------------------------------------------------------------------------------

" Rainbow Parenthesis 
" -------------------- 
let g:rainbow_active = 1
"let g:rainbow_load_separately = [
"    \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"    \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
"    \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"    \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
"    \ ]
" Change this if you want a different color scheme
" let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']

" Bookmarks
" -------------------- 
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
 
"-------------------------------------------------------------------------------
"--------------------------------- Interface -----------------------------------
"-------------------------------------------------------------------------------

" SpaceDuck
" -------------------- 
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" Devicons
" -------------------- 
set encoding=UTF-8

" NERDTree 
" -------------------- 
" Autostart nerdtree
" autocmd VimEnder *NERDTree | wincmd p
" Start NERDTree if vim is started without file arguments
"  Read before stdin
autocmd StdinReadPre * let s:std_in=1
" It seems will already open if we open a directory so don't need ||
"if !exists('s:std_in') && (argc() == 0 || (argc() == 1 && isdirectory(argv()[0])))
if !exists('s:std_in') && argc() == 0 
    " Open NERDTree and switch to it
    autocmd VimEnter * NERDTree 
endif
" Show number of lines in file
" WARNING! Might make NERDTree take forever!
"let g:NERDTreeFileLines = 1


" Toggle NERDTree with \nt
noremap <Leader>nt :NERDTreeToggle<CR>
" NERDTree git use powerline
let g:NERDTreeGitStatusUseNerdFonts = 1 
" Really for documentation
"let g:NERDTreeGitStatusIndicatorMapCustom = {
"                \ 'Modified'  :'✹',
"                \ 'Staged'    :'✚',
"                \ 'Untracked' :'✭',
"                \ 'Renamed'   :'➜',
"                \ 'Unmerged'  :'═',
"                \ 'Deleted'   :'✖',
"                \ 'Dirty'     :'✗',
"                \ 'Ignored'   :'☒',
"                \ 'Clean'     :'✔︎',
"                \ 'Unknown'   :'?',
"                \ }
 
" tagbar settings
" -------------------- 
" Open close tagbar with \b
nmap <silent> <leader>tb :TagbarToggle <CR>

" Gitgutter settings
" -------------------- 
" Enable showing only non-zero hunks
"let g:airline#extensions#hunks#non_zero_only = 1

" Indent Guides
" -------------------- 
" Make indent guide only one char
let g:indent_guides_guide_size=1
" Make guide color pretty faint
let g:indent_guides_color_change_percent=3

"-------------------------------------------------------------------------------
"--------------------------------- Debugging -----------------------------------
"-------------------------------------------------------------------------------

" GutenTags
" -------------------- 
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
    \ '*.pt',
    \ '*.tar',
    \ '*.gz',
    \ '*.xz',
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
" Generate tags on write
let g:gutentags_generate_on_write = 1

" ALE
" -------------------- 
" Add ruff to ale
let g:ale_linters = { 'python': ['ruff'] }
let g:ale_fixers = { 'python' : ['black', 'ruff'], }
" Allow ale-hover when mouse over
let g:ale_set_balloons=1
" Change the error and warning symbols to powerline
let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" Integrate into airline
let g:airline#extensions#ale#enabled = 1

" Linediff
" -------------------- 
" Short for linediff when in visual mode
vmap <Leader>diff :Linediff<CR>

"-------------------------------------------------------------------------------
"-------------------------------- Integrations ---------------------------------
"-------------------------------------------------------------------------------
" Git Gutter
" -------------------- 
" Some docs
" ]c = GitGutterNextHunk " Move to the next hunk
" [c = GitGutterPrevHunk
" Modify like: 
" nmap ]h <Plug>(GitGutterNextHunk)

" \hs = Stage (git add) a hunk 
" \hu = undo staging (this doesn't see to work...)
" \hp = preview hunk
" Augment foldtext to indicate if folded lines have been changed
set foldtext=gitgutter#fold#foldtext()
" GitGutterDiffOrig will show difference from original
map <Leader>gitdiff :GitGutterDiffOrig<CR>

" Git Messenger
" -------------------- 
" Use :GitMessenger to show the commit for a specific line
" Also mapped to \gm
" Include the diff
let g:git_messenger_include_diff=1
" Move into the popup
"let g:git_messenger_always_into_popup=1

" Airline 
" -------------------- 
" Comment this out if you don't have powerline fonts. Or install them from the
" font directory
let g:airline_powerline_fonts = 1
let g:airline_theme='spaceduck'

 
" Markdown Preview
" -------------------- 
let g:mkdp_auto_close = 0
"-------------------------------------------------------------------------------
"--------------------------------- Commands ------------------------------------
"-------------------------------------------------------------------------------

" ConqueGDB
let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly


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
