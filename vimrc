"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""" VIM Option """""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.vim/custom/plugins.vim " Plugins and plugin options
source ~/.vim/custom/remaps.vim " Personal Remaps

" Keep loads above this so they don't mess with these settings
" These settings will override those from above
syntax on               "Turns on Syntax highlighting 
try
    colorscheme vividchalk   "Colour Scheme (in ~/.vim/colors)
catch
    colorscheme peachpuff   "backup colour scheme (in /usr/share/vim...)
endtry
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
" means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undofile
    set undodir=~/.vim/undodir
catch
endtry

