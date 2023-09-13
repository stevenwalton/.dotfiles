#!/bin/bash
# Simple install script to get zsh up and running as well as soft link all the
#  associated dotfiles to my home directory

# Tell user what we're doing
echo "This script creates soft links to the home directory for dot files that are used"
#echo "It will also install oh-my-zsh and antigen"
git submodule update --init --recursive
	

# Check that home is located correctly
echo "Will install files to $HOME"
read -ep "Is this correct? [y/n]:\n " -n 1 -r
case $REPLY in
    [yY] ) echo Continuing; 
			;;
	[nN] ) echo "Exiting..."; 
			exit ;;
	* ) echo "Invalid response";;
esac

# Check that .dotfiles is in home
if [[ ! -d "$HOME/.dotfiles" ]]
then
    echo "Please place .dotfiles in $HOME"
    exit 1
fi

# Do the linking
# Zshrc
echo "Linking zhsrc to ~/.zshrc"
if ! [ -e "$HOME/.zshrc" ]
then
	ln -s ~/.dotfiles/zshrc ~/.zshrc 2> /dev/null 
	echo "Linking tmux.conf to ~/.tmux.conf"
else
	read -ep "~/.zshrc already exists, would you like to overwrite it? [y/n]:\n " -n 1 -r
	case $REPLY in
		[yY] ) ln -s ~/.dotfiles/zshrc ~/.zshrc 2> /dev/null;
			   echo "Linking tmux.conf to ~/.tmux.conf";
			   ;;
		[nN] ) echo "Leaving it alone...";
				break ;;
		* ) ;;
    esac
fi
echo -e ""$'\n'

# Tmux
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf  2> /dev/null 
echo "Linking tmux.conf to ~/.tmux.conf"
if ! [ -e "$HOME/.tmux.conf" ]
then
	ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf 2> /dev/null 
	echo "Linking tmux.conf to ~/.tmux.conf"
else
	read -ep "~/.tmux.conf already exists, would you like to overwrite it? [y/n]:\n " -n 1 -r
	case $REPLY in
		[yY] ) ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf 2> /dev/null;
			   echo "Linking tmux.conf to ~/.tmux.conf";
			   ;;
		[nN] ) echo "Leaving it alone...";
				;;
		* ) ;;
	esac
fi
echo -e ""$'\n'

# Anaconda
read -n 1 -rep "Install Anaconda? [y/n]:"$'\n'
case $REPLY in
	[yY] ) conda_name=`curl -Ls https://repo.anaconda.com/archive/ | grep 'Linux' | head -n 1 | cut -d '"' -f 2`
			wget "https://repo.anaconda.com/archive/${conda_name}" -O $conda_name # Download it 
      echo "Remember we expect it to be at ~/.anaconda3"
      sleep 2
      bash $conda_name # Run it
      rm $conda_name # remove it 
			;;
	* ) ;;
esac

# i3
#read -ep "Add i3 script? [y/n]:\n " -n 1 -r
#case $REPLY in
#	[yY] ) ln -s ~/.dotfiles/i3.config ~/.i3.config 2> /dev/null || echo "i3.config already exists";
#			;;
#	* ) ;;
#esac
#echo -e ""$'\n'
#
## Polybar
#read -n 1 -r -p "Add polybar script? [y/n]:\n "
#case $REPLY in
#	[yY] ) ln -s ~/.dotfiles/scripts/polybar/launch.sh ~/.config/polybar/launch.sh 2> /dev/null || echo "polybar launch.sh already exists";
#			ln -s ~/.dotfiles/scripts/polybar/config ~/.config/polybar/config 2> /dev/null || echo "polybar config already exists";
#			;;
#	* ) ;;
#esac
#echo -e ""$'\n'

# Kitty
read -n 1 -r -p "Add Kitty config?\n [y/n]:\n "
case $REPLY in
	[yY] ) ln -s ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf 2> /dev/null || echo "kitty.conf already exists";
			;;
	* ) ;;
esac
echo -e ""$'\n'

# Replace the vim files
read -ep "Replace $HOME/.vim and $HOME/.vimrc With those from .dotfile?\n [y/n]:\n " -n 1 -r
case $REPLY in
	[yY] ) rm -r ~/.vim;
			rm -r ~/.vimrc;
			ln -s ~/.dotfiles/vim ~/.vim;
			ln -s ~/.dotfiles/vimrc ~/.vimrc;
			# Install vim plugins;
			vim +PluginInstall +qall
			;;
	[nN] ) echo "You should probably do this";
			echo "When you have backuped please run: ";
			echo "rm -r ~/.vim";
			echo "rm -r ~/.vimrc";
			echo "ln -s ~/.dotfiles/vim ~/.vim";
			echo "ln -s ~/.dotfiles/vimrc ~/.vimrc";;
	* ) ;;
esac
echo -e ""$'\n'

# Setup zsh
#echo "Installing oh-my-zsh to home folder (hidden)"
#git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
#ln -s ~/.dotfiles/jdavis-modified.zsh-theme ~/.oh-my-zsh/themes/
#echo "Installing antigen to home folder (hidden)"
#git clone https://github.com/zsh-users/antigen ~/.antigen
# Spaceduck
read -ep "Install spaceduck themes? [y/n]"$'\n' -n 1 -r
case $REPLY in
	[yY] ) git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting;
				git clone https://github.com/bigpick/spaceduck-zsh-syntax-highlighting.git ~/.spaceduck-zsh-syntax-highlighting;;
	* ) ;;
esac
echo -e ""$'\n'

case `uname` in
	Darwin) read -ep "Install homebrew? [y/n]:\n " -n 1 -r
			case $REPLY in
				[yY] ) /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
					;;
				* ) 
					;;
			esac
			
			echo -e ""$'\n'
			read -ep "Install brew packages? [y/n]:\n " -n 1 -r
			case $REPLY in
					[yY] ) brew install \
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
							fzf \
							sheldon
						brew tap homebrew/cask-fonts
						brew install --cask \
							mactex \
							kitty \
							font-fira-code \
							font-fira-code-nerd-font \
							font-fira-mono-for-powerline \
							font-fira-mono-for-nerd-font \
							font-powerline-symbols
						;;
					* ) ;;
			esac

			if (hash zathura &> /dev/null)
			then
				mkdir -p $(brew --prefix zathura)/lib/zathura
				ln -s $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib
			fi
			read -ep "\nInstall Nerd fonts? [y/n]:\n " -n 1 -r

			case $REPLY in
				[yY] ) brew tap homebrew/cask-fonts
						brew install font-hack-nerd-font
						;;
				* ) ;;
			esac
			;; # Darwin

	Linux) read -ep "\nAutomatically install packages? Assumes `sudo apt` [y/n]:"$'\n'
		   case $REPLY in
		   	[yY] ) sudo apt update
					yes | sudo apt upgrade
					yes | sudo apt install \
						build-essential \
						pkg-config \
						openssl \
						libssl-dev \
            universal-ctags \
						cmake \
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
				;;
		   	* )  ;;
		   esac

		   read -ep -n 1 -r "\nInstall cargo? Needed if going to install Sheldon or Starship\n (runs `curl https://sh.rustup.rs -sSf | sh`) [y/n]:\n "
		   case $REPLY in
		   	[yY] ) echo "Piping into bash";
		   			sleep 2;
		   			curl https://sh.rustup.rs -sSf | sh
					;;
		   	* ) ;;
		   esac

		   read -ep "\nInstall Sheldon? (needs cargo) [y/n]:\n " -n 1 -r

		   case $REPLY in
		   	[yY] ) cargo install sheldon --locked
                if ! [ -e ~/.config/sheldon ]
                then 
                    mkdir -p ~/.config/sheldon
                fi
                ln -s ~/.dotfiles/sheldon_plugins.toml ~/.config/sheldon/plugins.toml
					;;
		   	* ) ;;
		   esac

		   read -ep "\nInstall (zsh) Starship? (default cargo) [y/(c)onda/(h)ttp via curl/n]: " -n 1 -r
		   case $REPLY in
		   	[yY] ) cargo install starship --locked
					;;
		   	[cC] ) conda install -c conda-forge starship
					;;
		   	[hH] ) echo "WARNING: pipes into bash";
		   			sleep 2;
		   			curl -sS https://starship.rs/install.sh | sh
					;;
		   	* ) ;;
		   esac
		   ;; # Linux
	*) echo -e "Don't know operating system `uname` so not automatically installing stuff"
		;;
esac

read -ep "Locally install FiraCode font? [y/n]:"$'\n'
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

# Using Sheldon now
#if (hash zsh &> /dev/null)
#then
#    zsh &> /dev/null
#    if (hash zplug &> /dev/null)
#    then
#        zplug update
#    else
#        echo "Zplug not found"
#    fi
#else
#    echo "ZSH couldn't load. Try manually"
#fi

# Create soft links

ln -s ~/.dotfiles/vifm ~/.config/vifm
# Make a root bin folder
mkdir ~/.bin
if ( hash vifm &> /dev/null )
then
		ln -s ~/.dotfiles/vifm/vifmimg ~/.bin/vifmimg
		ln -s ~/.dotfiles/vifm/vifmrun ~/.bin/vifmrun
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
echo "\nInstallation complete"
#echo "\nIt is suggested that you install powerline fonts."

read -ep "Make zsh the default shell? (y/n)"$'\n'
case $REPLY in
    [yY] ) chsh -s /usr/bin/zsh `whoami`
        ;;
    * ) ;;
esac
