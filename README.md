.vim folder for .vimrc
====

Entire .vim folder

This includes everything that is needed to run my current .vimrc as written.

Run the following commands
----------------------------
To get your vimrc file running correctly

`rm ~/.vimrc

`ln -s ~/.vim/vimrc ~/.vimrc

If you would like to use the bashrc file, then do the same. Note that it has archey3 in it and you might want to remove that line

To update submodules

`git submodule init

`git submodule update

Included Plugins
--------------------------------------
- Vim-pathogen: Makes installing plugins easier
- Nerdtree: Shows file tree on left
- Vim-fugitive: Git wrapper, see https://github.com/tpope/vim-fugitive for more details
- Vim-sensible: Sensible commands that most people like
- Syntastic: Syntax editor, will work for most languages.
- Airline: Makes a nice status bar. See fonts folder to install powerline fonts.
