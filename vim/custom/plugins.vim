"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""" VIM Plugin Options"""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep at top. Helps ensure that format options work correctly
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'scrooloose/nerdtree' "Bound to \nt (left)
    Plugin 'godlygeek/tabular' "Tab /delimiter
    "Plugin 'vim-airline/vim-airline' " That bottum line you have
    "Plugin 'tpope/vim-fugitive' " Git wrapper
    Plugin 'scrooloose/syntastic' " Syntax highlighting
    "Plugin 'taglist.vim'
    Plugin 'octol/vim-cpp-enhanced-highlight'
    "Plugin 'majutsushi/tagbar'  " Bound to \tb (right)
    Plugin 'airblade/vim-gitgutter' " Shows diff from git in left sidebar (fantastic)
    "Plugin 'mbbill/undotree' " Creates an undo tree, bound to \ut (left)
    "Plugin 'vim-scripts/Conque-GDB' " :(
    "Plugin 'ludovicchabant/vim-gutentags' " Auto generates tab
    Plugin 'linediff.vim'
    Plugin 'segeljakt/vim-silicon' " Screenshot highlighted text :Silicon fname
    Plugin 'iamcco/markdown-preview.nvim' 
    Plugin 'dense-analysis/ale'
    Plugin 'rhysd/git-messenger.vim' " Shows commit message associated with line of code
    Plugin 'pineapplegiant/spaceduck' " Spaceduck theme
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
let NERDTreeWinSize=20
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
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let g:syntastic_cpp_check_header = 1 " Checks headers
let g:syntastic_cpp_compiler = "g++"
let g:syntastic_cpp_checkers = ['gcc']
let g:syntastic_cpp_compiler_options = "-std=c++11 -stdlib=c++11"

" Airline configuration
"   let g:airline#extensions#tabline#enabled = 1
"   " Comment this out if you don't have powerline fonts. Or install them from the
"   " font directory
"   let g:airline_powerline_fonts = 1

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

