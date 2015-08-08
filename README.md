.vim folder for .vimrc
====

Entire .vim folder

This includes everything that is needed to run my current .vimrc as written.

Pathogen, NerdTree, and vividchalk are included in this.

Since the .vimrc file is contained in here I would suggest running the command

ln -s /path/to/.vim/.vimrc ~/.vimrc

If you do it this way then you can update with git and not have to copy the rc file over every time you update

To get the colours, pathogen, and nerdtree to work properly do the following

Run the following commands
----------------------------
git submodule init
git submodule update

Included Plugins
--------------------------------------
- Vim-pathogen: Makes installing plugins easier
- Nerdtree: Shows file tree on left
- Vim-fugitive: Git wrapper, see https://github.com/tpope/vim-fugitive for more details
- Vim-sensible: Sensible commands that most people like
- Syntastic: Syntax editor, will work for most languages.
- Airline: Makes a nice status bar. See fonts folder to install powerline fonts.
