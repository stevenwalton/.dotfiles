"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""" VIM Plugin Options"""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep at top. Helps ensure that format options work correctly
" " :PlugInstall Install plugins
" " :PlugClean cleans removal of unused plugins
" " :PlugList
" " :PlugSearch foo -searches for foo
" Switch to Plug: https://github.com/junegunn/vim-plug
" Adds a bit more power than Vundle, which is deprecated
call plug#begin()
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "                               Editing 
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "Plug 'frazrepo/vim-rainbow'            " This version fucks up spell checking in LaTex
    Plug 'luochen1990/rainbow'             " Improved Parentheses
    " redundant with ALE?
    "Plug 'sheerun/vim-polyglot'            " Comprehensive syntax highlighting
    Plug 'MattesGroeger/vim-bookmarks'     " Annotated marks
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "                           Interface
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    Plug 'pineapplegiant/spaceduck'        " Spaceduck theme
    Plug 'ryanoasis/vim-devicons'          " Font icons helpful for nerdtree/airline
    "Plug 'scrooloose/nerdtree'             " Project drawer (File explorer)
    Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'vim-airline/vim-airline'         " That bottum line you have
    "Plug 'vim-airline/vim-airline-themes'
    "Plug 'taglist.vim'                     " Helps with determining code structure (:TlistToggle)
    " Shows a list of tags in a drawer
    Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' } 
    " Causing tabstop issues
    "Plug 'nathanaelkane/vim-indent-guides' " Shows the indents
    " FZF with :Files (or other options) opens up in a balloon
    " I guess we need both ¯\_(ツ)_/¯	
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "                           Debugging 
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    Plug 'ludovicchabant/vim-gutentags'    " Ctags
    Plug 'dense-analysis/ale'              " ALE for linting
    " Diff between visual selections
    Plug 'AndrewRadev/linediff.vim', { 'on': 'Linediff' } 
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "                           Integrations
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Really need to make this work with popups in native vim instead of neo
    Plug 'airblade/vim-gitgutter'          " Shows diff from git in left sidebar (fantastic)
    " Shows commit message associated with line of code
    "Plug 'rhysd/git-messenger.vim'         (Redundant via gitgutter?)
    " Opens a browser to show a preview of markdown doc
    " Note: this doesn't like running manually :/
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
    " Increased syntax highlighting for nerdtree
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': 'NERDTreeToggle' }
    " Integration for git with nerdtree
    Plug 'xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
    " Highlights files opened in a buffer
    Plug 'PhilRunninger/nerdtree-buffer-ops', { 'on': 'NERDTreeToggle' }
    " Images in vim (Needs to be configured)
    "Plug '3rd/image.nvim'
    " Edit notebooks
    Plug 'goerz/jupytext.nvim' ", { 'on': What goes here? JSON? Or Python?}
    " Python Cells for running blocks
    Plug 'jpalardy/vim-slime', { 'for': 'python' }
    Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "                               Commands
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Tab /delimiter (format spacing by delimiter)
    Plug 'godlygeek/tabular'               
    "  Screenshot highlighted text :Silicon fname
    " Plug 'segeljakt/vim-silicon'          
call plug#end()
  
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

" Polyglot
" -------------------- 
" Default sensible settings
" let g:polyglot_disabled = ['sensible']

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
" If you want to automatically open when entering a blank file uncomment these
" lines
" if !exists('s:std_in') && argc() == 0 
"     " Open NERDTree and switch to it
"     autocmd VimEnter * NERDTree 
" endif

" Show number of lines in file
" WARNING! Might make NERDTree take forever!
"let g:NERDTreeFileLines = 1


" Toggle NERDTree with \nt
noremap <Leader>nt :NERDTreeToggle<CR>
" NERDTree git use powerline
let g:NERDTreeGitStatusUseNerdFonts = 1 
" Defaults
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
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'📝',
                \ 'Staged'    :'✳️',
                \ 'Untracked' :'🚷',
                \ 'Renamed'   :'🚘',
                \ 'Unmerged'  :'🚧',
                \ 'Deleted'   :'🚮',
                \ 'Dirty'     :'⚠️',
                \ 'Ignored'   :'🙈',
                \ 'Clean'     :'🧼',
                \ 'Unknown'   :'❓',
                \ }
" Ipython Cells
let g:slime_target = 'neovim'
 
" tagbar settings
" -------------------- 
" Open close tagbar with \b
nmap <silent> <leader>tb :TagbarToggle <CR>

" Gitgutter settings
" -------------------- 
" Enable showing only non-zero hunks
"let g:airline#extensions#hunks#non_zero_only = 1

" ]c and [c to jump to the {next,prev} hunk
" Redefine to also show the hunk's preview
nmap ]c :GitGutterNextHunk<CR>:GitGutterPreviewHunk<CR>
nmap [c :GitGutterPrevHunk<CR>:GitGutterPreviewHunk<CR>
" Remove message that says what the hunk number is when jumping
let g:gitgutter_show_msg_on_hunk_jumping = 0
" Show the summary of the hunk (same as \hp)
:command Preview :GitGutterPreviewHunk
" Stage the hunk (same as \hs)
:command Stage :GitGutterStageHunk
" Diff with the original file
:command GitDiff :GitGutterDiffOrig

"   " Indent Guides
"   " -------------------- 
"   " Start
"   let g:indent_guides_enable_on_vim_startup = 1
"   " Make indent guide only one char
"   let g:indent_guides_guide_size=1
"   " Make guide color pretty faint
"   let g:indent_guides_color_change_percent=3

"-------------------------------------------------------------------------------
"--------------------------------- Debugging -----------------------------------
"-------------------------------------------------------------------------------

" GutenTags
" -------------------- 
"Ctags
"set tags="./.tags,../.tags,~/.tags"
" Docs: https://bolt80.com/gutentags/
" Trace because it's been using a lot of CPU lately
"let g:gutentags_trace = 1
set statusline+=%{gutentags#statusline()}
" Root directory is considered if it has one of these files in it
"let g:gutentags_project_root = ['.git', 'Makefile', 'src', 'main.py']
let g:gutentags_enabled = 0
" Make less noisy for now
let g:gutentags_project_root = ['pyproject.toml', 'Makefile']
" Write ctags to this location instead (centralized and not in project)
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
" Don't generate tags for files like these or in these directories 
let g:gutentags_ctags_exclude = [
    \ 'wandb/',
    \ '[.]config/',
    \ '.git',
    \ '.DS_Store',
    \ '__*__',
    \ '*.pt[h]',
    \ '*.tar',
    \ '*.tar.*',
    \ '*.[gx]z',
    \ '[.]cache/',
    \ '[.]venv/',
    \ 'test*',
    \ '*.sw?',
    \ '*.cache',
    \ '[_]test[_].*',
    \ 'test/',
    \ ]

"let g:gutentags_exclude_filetypes = []
" Ignore these places (It seems to need extra help...)
let g:gutentags_exclude_project_root = [
    \ '/usr/local',
    \ '/opt/homebrew',
    \ '/home/linuxbrew/.linuxbrew',
    \ "/home/${USER}",
    \ "/home/${USER}/Downloads",
    \ "/home/${USER}/Pictures",
    \ "/home/${USER}/Documents",
    \ "/home/${USER}/.config",
    \ "/home/${USER}/.venv",
    \ "/home/${USER}/.cache",
    \]

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
" Helpful for debugging: add the gutentag statusline
"   set statusline+=%{gutentags#statusline()}
"   let g:gutentags_trace = 1

" ALE
" -------------------- 
" Add ruff to ale
"" Linter
let g:ale_linters = { 'python': ['ruff'] }
"" Formatter
let g:ale_fixers = { 'python' : ['ruff-format'], }
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

"   " ConqueGDB
"   let g:ConqueTerm_Color = 2         " 1: strip color after 200 lines, 2: always with color
"   let g:ConqueTerm_CloseOnEnd = 1    " close conque when program ends running
"   let g:ConqueTerm_StartMessages = 0 " display warning messages if conqueTerm is configured incorrectly
"   
"   
"   let g:silicon = {
"       \ 'theme':              'Dracula',
"       \ 'font':                  'Hack',
"       \ 'background':         '#FFFFFF',
"       \ 'shadow-color':       '#555555',
"       \ 'line-pad':                   2,
"       \ 'pad-horiz':                  0,
"       \ 'pad-vert':                   0,
"       \ 'shadow-blur-radius':         0,
"       \ 'shadow-offset-x':            0,
"       \ 'shadow-offset-y':            0,
"       \ 'line-number':           v:true,
"       \ 'round-corner':          v:false,
"       \ 'window-controls':       v:false,
"       \ }
