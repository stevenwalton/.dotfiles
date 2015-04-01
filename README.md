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
git clone https://github.com/tpope/vim-vividchalk
mv vim-cicidchalk/colors/vividchalk /colors
cd bundle
git clone https://github.com/tpope/vim-pathogen
git clone https://github.com/scrooloose/nerdtree.git
