# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="jdavis"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(history-substring-search colored-man-pages)

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
#
# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
#bindkey -v
# Enable history search with up/down keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit
# End of lines added by compinstall
#[ -e "${HOME}/.zsh_aliases" ] && source "${HOME}/.zsh_aliases"
#[ -e "${HOME}/.zshrc_local" ] && source "${HOME}/.zshrc_local"

# General Exports
export EDITOR="vim"
export DISPLAY=:0.0

##########
# Aliases
##########
# Add color and make human readable
alias ls='ls --color=auto -h' # add a splash of color, human readable
alias la='ls -a'
alias ll='ls -lh'
alias vi='vim'
alias top='htop'
alias pacman='pacman --color=auto'
alias ssh='ssh -X'
# Grep to have color, give line number, don't tell me it can't access restricted files (sudo), and don't process binary files (garbage output ):
alias grep='grep --color=always --line-number --no-messages --binary-files=without-match'
#alias mountRepo='/home/steven/.scripts/mountRepo'
# Tmux doesn't like to recognize 256 colouring, so let's force it
alias tmux='tmux -2'
alias df='df -h'
alias log='git log --graph --oneline --decorate'

# FOR UO
#alias cmake='~/.build/cmake-3.11.4-Linux-x86_64/bin/cmake'
#alias ccmake='~/.build/cmake-3.11.4-Linux-x86_64/bin/cmake'
alias visit='~/.build/visit2_13_2.linux-x86_64/bin/visit'

##########
# Exports For UO
##########
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/walton/Programming/ORNL/conduit-install/lib
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/walton/Programming/ORNL/vtk-h-install/lib/
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/walton/Programming/ORNL/vtk-m-install/lib/
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/walton/Programming/ORNL/adios2-install/lib
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/walton/Programming/ORNL/ascent-official-install/lib
