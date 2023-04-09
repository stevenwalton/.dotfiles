# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
if [ `hostname` = "Orion" ] || [ `hostname` = "Serenity" ] || [ `hostname` = "Bebop" ] || [ `hostname` = "Rama" ] || [ `hostname` = "Swordfish" ]
then
    ZSH_THEME="jdavis-modified"
else
    ZSH_THEME="lambda"
fi

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(history-substring-search colored-man-pages zsh-syntax-highlighting)

# User configuration

#export PATH=$HOME/bin:/usr/local/bin:$PATH
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

# Fixes tmux window renaming
DISABLE_AUTO_TITLE="true"

# Unset the autonaming for tmux
DISABLE_AUTO_TITLE="true"

##########
# Aliases
##########
############################################
############ Fancy Bash Tools ##############
############################################
if hash htop &> /dev/null
then
    alias top='htop'
fi
if (hash bat &> /dev/null) || (hash batcat &> /dev/null)
then
    if hash batcat &> /dev/null
    then
        # Ubuntu
        alias cat='batcat -p'
    else
        alias cat='bat -p'
    fi
fi

# Make sure this is above ls aliases 
if hash exa &> /dev/null
then
    alias ls='exa'
fi

# Add color and make human readable
#alias ls='ls --color=auto -h' # add a splash of color, human readable
#alias ls='ls -v --color=auto -h' # numerical sort
alias la='ls -a'
alias ll='ls -lh'
alias vi='vim'
alias pacman='pacman --color=auto'
alias ssh='ssh -YC'
# Grep to have color, give line number, don't tell me it can't access restricted files (sudo), and don't process binary files (garbage output ):
alias grep='grep --color=always --line-number --no-messages --binary-files=without-match'

# Tmux doesn't like to recognize 256 colouring, so let's force it
# -u fixes backspace error thing
alias tmux='tmux -2 -u'
alias df='df -h'
alias log='git log --graph --oneline --decorate'

# Linux only commands. This is kinda hacky
if [[ `command -v lsb_release` ]]
then
    alias open='xdg-open' 
fi


alias alaska='ssh -L 21:ix.cs.uoregon.edu:21 -l swalton2 alaska.cs.uoregon.edu'
alias ix='ssh -L 21:ix.cs.uoregon.edu:21 -l swalton2 ix.cs.uoregon.edu'
#################################
# KILL SSH AGENTS
# ###############################
#function sshpid()
#{
#    echo `ps aux | grep ssh-agent -s | cut -d " " -f6 | head -n1`
#}
#sshpid
#if [[ ! -z "$(sshpid)" ]]; then
#    export SSH_AGENT_PID=$(sshpid)
#    ssh-add ~/.ssh/*_rsa 1&> /dev/null
#else
eval $(ssh-agent -s) > /dev/null
ssh-add ~/.ssh/*_rsa 1&> /dev/null
#fi
function killssh()
{
    kill -9 $SSH_AGENT_PID
}
trap killssh 0

# Pyenv
#export PYENV_ROOT="${HOME}/.pyenv"
#if [ `hostname` = "Bebop" ]
#then
#    export PATH="${HOME}/.homebrew/bin:${PATH}"
#else
#    export PATH="${PYENV_ROOT}/bin:${PATH}"
#fi
#eval "$(pyenv init -)"

# Kitty
#if [ $TERM = xterm-kitty ]
#then
#    autoload -Uz compinit
#    compinit
#    kitty + complete setup zsh | source /dev/stdin
#    # Makes backspace work in python
#    export TERMINFO=/usr/share/terminfo
#fi

#################################
# Machine Specific Configurations
#################################
# UO
if [ `hostname` = "Orion" ] 
then
    alias ls='ls -v --color=auto -h' # numerical sort
    alias visit='~/.builds/visit*.linux-x86_64/bin/visit'
    # For some reason this isn't there
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/walton/Programming/ORNL/conduit-install/lib
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/walton/Programming/ORNL/vtk-h-install/lib/
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/walton/Programming/ORNL/vtk-m-install/lib/
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/walton/Programming/ORNL/adios2-install/lib
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/walton/Programming/ORNL/ascent-official-install/lib
    
    alias pycharm="sh ~/.builds/pycharm-community-2019.1.1/bin/pycharm.sh"
elif [ `hostname` = "Serenity" ]
# Serenity
then
    alias ls='ls -v --color=auto -h' # numerical sort
# Rama
elif [ `hostname` = "rama" ]
then
    alias ssh='TERM="xterm-256color" ssh'
    alias ls='ls -v --color=auto -h' # numerical sort
# source ${HOME}/.anaconda3/bin/activate  # commented out by conda initialize  # commented out by conda initialize
    export PATH=${PATH}:${HOME}/.anaconda3/bin/
    # Algorand node
    export ALGORAND_DATA="$HOME/.algonode/data"
    export PATH="$PATH:$HOME/.algonode"
# Alaska
elif [ `hostname` = "alaska" ] 
then
    alias ls='ls -v --color=auto -h' # numerical sort
    export DISPLAY=:0.0
# M2 Air
elif [ `hostname` = "Swordfish" ]
then
    alias ssh='kitty +kitten ssh'
# Air
elif [ `hostname` = "Bebop" ] 
then
    export PATH=${PATH}:~/.homebrew/bin/
    #export PATH=${PATH}:/Library/TeX/texbin/
# Shi Machines
elif [[ `hostname` = shi* ]]
then
    __conda_setup="$('/workspace/swalton2/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/workspace/swalton2/anaconda3/etc/profile.d/conda.sh" ]; then
# . "/workspace/swalton2/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
        else
# export PATH="/workspace/swalton2/anaconda3/bin:$PATH"  # commented out by conda initialize
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
fi



# SpaceDuck Theme (for zsh-syntax-highlighting)
#
# Code licensed under the MIT license
#
# @author George Pickering <@bigpick>

# Paste this files contents inside your ~/.zshrc before you activate zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# Italics not yet supported by zsh; potentially soon:
#    https://github.com/zsh-users/zsh-syntax-highlighting/issues/432
#    https://www.zsh.org/mla/workers/2021/msg00678.html
# ... in hopes that they will, labelling accordingly with ,italic where appropriate
#
# Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md

### General
#### Diffs
#### Markup
### Classes
### Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#30365F'
### Constants
### Entitites
### Functions/methods
ZSH_HIGHLIGHT_STYLES[alias]='fg=#5ccc96'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#5ccc96'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#5ccc96'
ZSH_HIGHLIGHT_STYLES[function]='fg=#5ccc96'
ZSH_HIGHLIGHT_STYLES[command]='fg=#5ccc96'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#5ccc96,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#e39400,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#b3a1e6'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#b3a1e6'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#b3a1e6'
### Keywords
### Built ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#5ccc96'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#5ccc96'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#5ccc96'
### Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#ce6f8f'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#ce6f8f'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#ce6f8f'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#ce6f8f'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#ce6f8f'
### Serializable / Configuration Languages
### Storage
### Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#00a3cc'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#00a3cc'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#00a3cc'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#e33400'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#00a3cc'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#e33400'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#00a3cc'
### Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#e33400'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#ecf0c1'
### No category relevant in spec
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e33400'
ZSH_HIGHLIGHT_STYLES[path]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#ce6f8f'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#ce6f8f'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#b3a1e6'
#ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
#ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#e33400'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#ecf0c1'
ZSH_HIGHLIGHT_STYLES[default]='fg=#ecf0c1'
#
ZSH_HIGHLIGHT_STYLES[cursor]='standout'

export PATH=$PATH:$HOME/.bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Shell like vim
set -o vi
