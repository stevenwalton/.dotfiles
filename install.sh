#!/bin/sh
# Simple install script to get zsh up and running as well as soft link all the
#  associated dotfiles to my home directory

# Tell user what we're doing
echo "This script creates soft links to the home directory for dot files that are used"
#echo "It will also install oh-my-zsh and antigen"
git submodule update --init --recursive

# Check that home is located correctly
echo "Will install files to $HOME"
read -p "Is this correct? [y/n]: " -n 1 -r
if [[ $REPLY =~ [Nn]$ ]]
then
    exit 1
fi 
echo ""
# Check that .dotfiles is in home
if [[ ! -d $HOME/.dotfiles ]]
then
    echo "Please place .dotfiles in $HOME"
    exit 1
fi

# Do the linking
echo "Linking zhsrc to ~/.zshrc"
ln -s ~/.dotfiles/zshrc ~/.zshrc 2> /dev/null || echo -e "~/.zshrc already exists!\n"
echo "Linking tmux.conf to ~/.tmux.conf"
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf  2> /dev/null || echo -e "~/.tmux.conf already exists!\n"

# i3
#read -n 1 -p "Add i3 script?\n [y/n "
read -p "Add i3 script? [y/n]: " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    ln -s ~/.dotfiles/i3.config ~/.i3.config 2> /dev/null || echo "i3.config already exists"
fi
echo ""

# Polybar
read -n 1 -r -p "Add polybar script? [y/n]: "
if [[ $REPLY =~ ^[Yy]$ ]]
then
    ln -s ~/.dotfiles/scripts/polybar/launch.sh ~/.config/polybar/launch.sh 2> /dev/null || echo "polybar launch.sh already exists"
    ln -s ~/.dotfiles/scripts/polybar/config ~/.config/polybar/config 2> /dev/null || echo "polybar config already exists"
fi
echo ""

# Kitty
read -n 1 -r -p "Add Kitty config?\n [y/n]: "
if [[ $REPLY =~ ^[Yy]$ ]]
then
    ln -s ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf 2> /dev/null || echo "kitty.conf already exists"
fi
echo ""

# Replace the vim files
read -p "Replace $HOME/.vim and $HOME/.vimrc With those from .dotfile?\n [y/n]: " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    rm -r ~/.vim
    rm -r ~/.vimrc
    ln -s ~/.dotfiles/vim ~/.vim
    ln -s ~/.dotfiles/vimrc ~/.vimrc
    # Install vim plugins
    vim +PluginInstall +qall
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
#echo "Installing antigen to home folder (hidden)"
#git clone https://github.com/zsh-users/antigen ~/.antigen
# Spaceduck
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/bigpick/spaceduck-zsh-syntax-highlighting.git ~/.spaceduck-zsh-syntax-highlighting

if [[ $(uname) == "Darwin" ]]; 
then
    read -p "Install homebrew? [y/n]: " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    read -p "Install brew packages? [y/n]: " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        brew install \
            htop \
            tmux \
            mactex-no-gui \
            lsd \
            tre \
            stats \
            git-lfs \
            zplug \
            navi \
            vifm \
            curl \
            jq \
            glow \
            zathura \
            zathura --with-synctex \
            zathura-pdf-poppler \
            ranger \
            fd \
            fzf
        brew tap homebrew/cask-fonts
        brew install --cask \
            mactex \
            kitty \
            font-fira-code \
            font-fira-code-nerd-font \
            font-fira-mono-for-powerline \
            font-fira-mono-for-nerd-font \
            font-powerline-symbols
    fi
else
    read -p "Automatically install packages? Assumes `apt` (y/n):"
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        apt install \
            htop \
            tmux \
            fzf \
            fd-find \
            lsd \
            tre \
            git-lfs \
            zathura \
            ranger \
            kitty \
            fonts-powerline
fi

read -p "Locally install FiraCode font? (y/n):"
if [[ $REPLY =~ ^[Yy]$ ]]
then
		fonts_dir="${HOME}/.local/share/fonts"
		if [ ! -d "${fonts_dir}" ]; then
				echo "mkdir -p $fonts_dir"
				mkdir -p "${fonts_dir}"
		else
				echo "Found fonts dir $fonts_dir"
		fi
    # We'll automatically try to grab the version
    # Assuming github keeps format of release 
    version=`curl https://github.com/tonsky/FiraCode -Ls | grep "css-truncate-target text-bold mr-2" | cut -d ">" -f2 | cut -d "<" -f1`
		zip=Fira_Code_v${version}.zip
		curl --fail --location --show-error https://github.com/tonsky/FiraCode/releases/download/${version}/${zip} --output ${zip}
		unzip -o -q -d ${fonts_dir} ${zip}
		rm ${zip}

		echo "fc-cache -f"
		fc-cache -f
fi

if (hash zsh &> /dev/null)
then
    zsh &> /dev/null
    if (hash zplug &> /dev/null)
    then
        zplug update
    else
        echo "Zplug not found"
    fi
else
    echo "ZSH couldn't load. Try manually"
fi

# Create soft links
if (hash zathura &> /dev/null)
then
    mkdir -p $(brew --prefix zathura)/lib/zathura
    ln -s $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib
fi

ln -s ~/.dotfiles/vifm ~/.config/vifm
# Make a root bin folder
mkdir ~/.bin
ln -s ~/.dotfiles/vifm/vifmimg ~/.bin/vifmimg
ln -s ~/.dotfiles/vifm/vifmrun ~/.bin/vifmrun

# Nerd fonts
if [[ $(uname) == "Darwin" ]]; then
    read -p "Install Nerd fonts? [y/n]: " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
        brew tap homebrew/cask-fonts
        brew install font-hack-nerd-font
    fi
fi

### Configure Git ###
# diff so fancy for git
if (hash diff-so-fancy &> /dev/null)
then
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global interactive.diffFilter "diff-so-fancy --patch"
fi
# Add the git templates
git config --global init.templatedir $HOME/.git_template
# Gives command `git ctags` to run ctags hook
git config --global alias.ctags '!.git/hooks/ctags'

#############
echo "Installation complete"
echo "It is suggested that you install powerline fonts."
