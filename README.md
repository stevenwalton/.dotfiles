.vim folder for .vimrc
====

Entire .vim folder

This includes everything that is needed to run my current .vimrc as written.

Pathogen, NerdTree, and vividchalk are included in this.

Since the .vimrc file is contained in here I would suggest running the command

ln -s /path/to/.vim/.vimrc ~/.vimrc

so that it is always used, and you can update as you please.

To get the colours, pathogen, and nerdtree to work properly do the following

Move /path/.vim/vim-vividchalk/colors/vividchalk.vim to /path/.vim/colors
Move /path/.vim/nerdtree to /path/.vim/bundle/
Move /path/.vim/vim-pathogen/ to /path/.vim/bundle
