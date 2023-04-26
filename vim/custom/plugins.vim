"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""" VIM Plugin Options"""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep at top. Helps ensure that format options work correctly
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'godlygeek/tabular' "Tab /delimiter
    Plugin 'vim-airline/vim-airline' " That bottum line you have
    Plugin 'vim-airline/vim-airline-themes'
    "Plugin 'scrooloose/syntastic' " Syntax highlighting
    "Plugin 'taglist.vim'
    Plugin 'majutsushi/tagbar'  " Bound to \tb (right)
    Plugin 'airblade/vim-gitgutter' " Shows diff from git in left sidebar (fantastic)
    "Plugin 'mbbill/undotree' " Creates an undo tree, bound to \ut (left)
    Plugin 'linediff.vim'
    "Plugin 'segeljakt/vim-silicon' " Screenshot highlighted text :Silicon fname
    Plugin 'iamcco/markdown-preview.nvim' 
    "Plugin 'dense-analysis/ale'
    Plugin 'rhysd/git-messenger.vim' " Shows commit message associated with line of code
    "Plugin 'pineapplegiant/spaceduck' " Spaceduck theme
    Plugin 'frazrepo/vim-rainbow'   " Improved Parentheses
    Plugin 'sheerun/vim-polyglot'
    Plugin 'vimwiki/vimwiki'
    Plugin 'lervag/vimtex'
call vundle#end()
call mkdp#util#install()

filetype plugin indent on
" :PluginInstall Install plugins
" :PluginClean cleans removal of unused plugins
" :PluginList
" :PluginSearch foo -searches for foo
"" Mapping and Plugin section
" CtrlP
"map <Leader>p :CtrlP<CR>
"map <Leader>bp :CtrlPBuffer<CR>

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

"
"SpaceDuck
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

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
let g:airline#extensions#hunks#non_zero_only = 1

" NERDTree Options
let g:NERDTreeDirArrows=0
let NERDTreeWinSize=20
" Toggle NERDTree with \nt
map <Leader>nt :NERDTreeToggle<CR>

" auto open UndoTree
let g:undotree_SplitWidth = 25
map <Leader>ut :UndotreeToggle<CR>

" Syntastic Options
"command Synt normal! :SyntasticToggleMode<CR>
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0
"let g:syntastic_cpp_check_header = 1
"let g:syntastic_loc_list_height = 3
"
"" Syntax for c++
"let g:cpp_class_scope_highlight = 1
"let g:cpp_member_variable_highlight = 1
"let g:cpp_class_decl_highlight = 1
"let g:cpp_experimental_template_highlight = 1
"let g:cpp_concepts_highlight = 1
"let g:syntastic_cpp_check_header = 1 " Checks headers
"let g:syntastic_cpp_compiler = "g++"
"let g:syntastic_cpp_checkers = ['gcc']
"let g:syntastic_cpp_compiler_options = "-std=c++11 -stdlib=c++11"

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

" Vimwiki
filetype plugin on
let g:vimwiki_list = [{'path': '~/.vimwiki/',
                      \ 'syntax': 'markdown',
                      \ 'ext': '.md',
                      \ 'auto_toc': 1}]
let g:vimwiki_global_ext = 0
" For todo lists
let g:vimwiki_listsyms = '✗○◐●✓'

" Vimtex
" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ","
