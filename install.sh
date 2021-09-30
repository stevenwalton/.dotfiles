#!/bin/sh
# Simple install script to get zsh up and running as well as soft link all the
#  associated dotfiles to my home directory

# Tell user what we're doing
echo "This script creates soft links to the home directory for dot files that are used"
echo "It will also install oh-my-zsh and antigen"

# Check that home is located correctly
echo "Will install files to $HOME"
read -p "Is this correct? [y/n]: " -n 1 -r
if [[ $REPLY =~ [Nn]$ ]]
then
    exit 1
fi 
# Check that .dotfiles is in home
if [[ ! -d $HOME/.dotfiles ]]
then
    echo "Please place .dotfiles in $HOME"
    exit 1
fi

# Do the linking
echo "Linking zhsrc to ~/.zshrc"
ln -s ~/.dotfiles/zshrc ~/.zshrc
echo "Linking tmux.conf to ~/.tmux.conf"
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf

# i3
read -p "Add i3 script?\n [y/n]: "-n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    ln -s ~/.dotfiles/i3.config ~/.i3.config
fi

# Polybar
read -p "Add polybar script?\n [y/n]: "-n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    ln -s ~/.dotfiles/scripts/polybar/launch.sh ~/.config/polybar/launch.sh
    ln -s ~/.dotfiles/scripts/polybar/config ~/.config/polybar/config
fi
# Kitty
read -p "Add Kitty config?\n [y/n]: "-n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
    ln -s ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf
fi

# Replace the vim files
read -p "Replace $HOME/.vim and $HOME/.vimrc With those from .dotfile?\n [y/n]: " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    rm -r ~/.vim
    rm -r ~/.vimrc
    ln -s ~/.dotfiles/vim ~/.vim
    ln -s ~/.dotfiles/vimrc ~/.vimrc
    echo "Remember to run :PluginInstall from vim"
else
    echo "You should probably do this"
    echo "When you have backuped please run: "
    echo "rm -r ~/.vim"
    echo "rm -r ~/.vimrc"
    echo "ln -s ~/.dotfiles/vim ~/.vim"
    echo "ln -s ~/.dotfiles/vimrc ~/.vimrc"
fi

# Setup zsh
echo "Installing oh-my-zsh to home folder (hidden)"
git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
ln -s ~/.dotfiles/jdavis-modified.zsh-theme ~/.oh-my-zsh/themes/
echo "Installing antigen to home folder (hidden)"
git clone https://github.com/zsh-users/antigen ~/.antigen
# Spaceduck
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone git@github.com:bigpick/spaceduck-zsh-syntax-highlighting.git ~/.spaceduck-zsh-syntax-highlighting


echo "Installation complete"
echo "It is suggested that you install powerline fonts."
