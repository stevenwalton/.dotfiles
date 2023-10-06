#!/bin/bash
# Simple install script to get zsh up and running as well as soft link all the
#  associated dotfiles to my home directory
#  Note Dont use symbols in comments because it messes them up
#  Things like apostrophes and parenthesis IDK why

# Tell user what we're doing
echo "This script creates soft links to the home directory for dot files that are used"
#echo "It will also install oh-my-zsh and antigen"
git submodule update --init --recursive
	

# Check that home is located correctly
echo -e "[1;31mWill install files to $HOME[0m"
read -ep "Is this correct? [y/n]: " -n 1 -r
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
    echo -e "[1;31mPlease place .dotfiles in $HOME[0m"
    exit 1
fi

# Do the linking
# Zshrc
echo -e "Linking [1;31mzhsrc[0m to ~/.zshrc"
if ! [ -e "$HOME/.zshrc" ]
then
	ln -s ~/.dotfiles/zshrc ~/.zshrc 2> /dev/null 
else
	read -ep "[1;31mWARNING[0m~/.zshrc already exists, would you like to overwrite it? [y/n]:\n " -n 1 -r
	case $REPLY in
		[yY] ) ln -s ~/.dotfiles/zshrc ~/.zshrc 2> /dev/null;
			   echo "Linking [1;31mzshrc[0m to ~/.zshrc";
			   ;;
		[nN] ) echo "Leaving it alone...";
				break ;;
		* ) ;;
    esac
fi
echo -e ""$'\n'

# Tmux
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf  2> /dev/null 
echo "Linking [1;31mtmux.conf[0m to ~/.tmux.conf"
if ! [ -e "$HOME/.tmux.conf" ]
then
	ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf 2> /dev/null 
else
	read -ep "[1;31mWARNING: [0m~/.tmux.conf already exists, would you like to overwrite it? [y/n]: " -n 1 -r
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
      echo "[5;31mRemember we expect it to be at ~/.anaconda3[0m"
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
read -n 1 -r -p "Add [1;31mKitty[0m config?\n [y/n]: "
case $REPLY in
	[yY] ) ln -s ~/.dotfiles/kitty/ ~/.config/kitty/ 2> /dev/null || echo -e "[1;31mWARNING:[0m ~/.config/kitty already exists";
			;;
	* ) ;;
esac
echo -e ""$'\n'

# Replace the vim files
read -ep "Replace [1;31m$HOME/.vim and $HOME/.vimrc[0m With those from .dotfile?\n [y/n]:\n " -n 1 -r
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

# Spaceduck
read -ep "Install [1;31mSpaceduck[0m themes? [y/n]"$'\n' -n 1 -r
case $REPLY in
	[yY] ) git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting;
				git clone https://github.com/bigpick/spaceduck-zsh-syntax-highlighting.git ~/.spaceduck-zsh-syntax-highlighting;;
	* ) ;;
esac
echo -e ""$'\n'

# Make config folder
if ! [ -e "$HOME/.config/" ]
then 
    mkdir -p ~/.config/
fi

case `uname` in
	Darwin) read -ep "Install [1;31mhomebrew[0m? [y/n]:\n " -n 1 -r
			case $REPLY in
				[yY] ) /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
					;;
				* ) 
					;;
			esac # homebrew
			
			echo -e "\n"
			read -ep "Install brew packages? [y/n]:\n " -n 1 -r
			case $REPLY in
					[yY] ) brew install \
							htop \ # better top
							tmux \ # wish I didnt need
							mactex-no-gui \
              lsd \ # fancy ls exa is deprecitated
							tre \ # tree
							stats \ # stats in top bar
							git-lfs \
							navi \ # cheat sheet tool
							vifm \ # vim file manager
							curl \
							jq \ # json parser 
							glow \ # render md in cli
							zathura \ # better pdf 
							zathura --with-synctex \
							zathura-pdf-poppler \
							ranger \ # File browser
							fd \ # better find
							fzf \ # fuzzy finder
							sheldon \ # zsh
              muesli/homebrew-tap/duf # better du
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
			esac # brew installs 

			if (hash zathura &> /dev/null)
			then
				mkdir -p $(brew --prefix zathura)/lib/zathura
				ln -s $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib
			fi # zahura
			read -ep "\nInstall [1;31mNerd fonts[0m? [y/n]:\n " -n 1 -r

			case $REPLY in
				[yY] ) brew tap homebrew/cask-fonts
						brew install font-hack-nerd-font
						;;
				* ) ;;
			esac # nerd fonds
			;; # Darwin

	Linux) read -ep "[1;31mAutomatically install packages[0m? Assumes `sudo apt` [y/n]:"$'\n'
		   case $REPLY in
		   	[yY] ) sudo apt update
          echo -e "[1;32======================[0m"
          echo -e "[1;32mSuccessfully updated[0m"
          echo -e "[1;32======================[0m"
					yes | sudo apt upgrade
          echo -e "[1;32======================[0m"
          echo -e "[1;32mSuccessfully upgraded[0m"
          echo -e "[1;32======================[0m"
					yes | sudo apt install \
						build-essential \
						pkg-config \
						openssl \
						libssl-dev \
            universal-ctags \
						cmake \
            unzip \
            zsh \
            htop \
            tmux \
            fzf \
            fd-find \
            git-lfs \
            zathura \
            ranger \
            kitty \
            fonts-powerline \
            fonts-firacode
          echo -e "[1;32=================================[0m"
          echo -e "[1;32mSuccessfully Installed packages[0m"
          echo -e "[1;32=================================[0m"
          if [ $(lsb_release -d | cut -d " " -f 2 | cut -d "." -f1) -ge 22 ]
          then
              echo -e "Trying to install [1;31mlsd[0m. Won't work on 20.04"
              sudo apt install lsd 
              echo -e "Trying to install [1;31mtre\1\[0m. Won't work on 20.04"
              sudo apt install tre 
          else
              echo -e "[1;31mUbuntu version <22.04 does not have [1;32m lsd[0m nor [1;32mtre [1;31mSkipping[0m"
          fi # Ubuntu 22+
				;;
		   	* )  ;;
		   esac # Apt

		   read -ep -n 1 -r "\nInstall [1;31mCargo\e\0m? Needed if going to install Sheldon or Starship\n (runs `curl https://sh.rustup.rs -sSf | sh`) [y/n]:\n "
		   case $REPLY in
		   	[yY] ) echo "Piping into bash";
		   			sleep 2;
		   			curl https://sh.rustup.rs -sSf | sh
					;;
		   	* ) ;;
		   esac # Cargo

       # straight hash won't accurately pick it up because we haven't exited yet
       #if ( hash cargo &>/dev/null )
       if ( hash ~/.cargo &>/dev/null )
       then
		        read -ep "\nInstall [1;31mSheldon[0m? (needs cargo) [y/n]:\n " -n 1 -r

		        case $REPLY in
		        	[yY] ) ~/.cargo/bin/cargo install sheldon --locked
                     ln -s ~/.dotfiles/sheldon/ ~/.config/
			       	;;
		        	* ) ;;
		        esac # Sheldon

		        read -ep "\nInstall (zsh) [1;31mStarship[0m? (default cargo) [y/(c)onda/(h)ttp via curl/n]: " -n 1 -r
		        case $REPLY in
		        	[yY] ) ~/.cargo/bin/cargo install starship --locked
			       	;;
		        	[cC] ) conda install -c conda-forge starship
			       	;;
		        	[hH] ) echo "WARNING: pipes into bash";
		        			sleep 2;
		        			curl -sS https://starship.rs/install.sh | sh
			       	;;
		        	* ) ;;
		        esac # Starship

            if ! ( hash lsd &>/dev/null )
            then
                read -ep "\nInstall [1;31mLSD[0m? (needs cargo) (you're missing LSD) [y/n]:\n " -n 1 -r
                case $REPLY in
                 [yY] ) ~/.cargo/bin/cargo install lsd --locked
                   ;;
                 * ) ;;
                esac # LSD
            fi # lsd
       fi # Cargo possible installs
		   ;; # Linux
	*) echo -e "Don't know operating system `uname` so not automatically installing stuff"
		;;
esac # Installs

read -ep "Locally install [1;31mFiraCode font[0m? [y/n]:"$'\n'
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

# Make a root bin folder
mkdir ~/.bin
if ( hash vifm &> /dev/null )
then
    ln -s ~/.dotfiles/vifm ~/.config/vifm
		ln -s ~/.dotfiles/vifm/vifmimg ~/.bin/vifmimg
		ln -s ~/.dotfiles/vifm/vifmrun ~/.bin/vifmrun
fi


read -n 1 -rep "Link Dotfile [1;31mSheldon[0m to ~/.config? [y/n]:"$'\n'
case $REPLY in
    [yY] ) ln -s ~/.dotfiles/sheldon/ ~/.config/
        ;;
    * ) ;;
esac

read -n 1 -rep $"Link Dotfile [1;31mRanger[0m to ~/.config? [y/n]:"$'\n'
case $REPLY in
    [yY] ) ln -s ~/.dotfiles/ranger/ ~/.config/
        ;;
    * ) ;;
esac


### Configure Git ###
# diff so fancy for git
if (hash diff-so-fancy &> /dev/null)
then
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global interactive.diffFilter "diff-so-fancy --patch"
fi
# Add the git templates
mkdir $HOME/.git_template
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
