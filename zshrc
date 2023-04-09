# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
if [ `hostname` = "Orion" ] || [ `hostname` = "Serenity" ] || [ `hostname` = "Bebop" ] || [ `hostname` = "Rama" ] || [ `hostname` = "Swordfish" ]
then
    ZSH_THEME="jdavis-modified"
else
    ZSH_THEME="lambda"
fi
# Source Antigen
source ${HOME}/.antigen/antigen.zsh
#####################
## General Exports ##
#####################
export EDITOR="vim"
# Plug dir (in process of replacing antigen)
if [[ $(uname) == "Darwin" ]]; then
    export ZPLUG_HOME=/opt/homebrew/opt/zplug
else
    export ZPLUG_HOME=${HOME}/.zplug
fi
###########
## zplug ##
###########
# See list of all plugins:
# https://github.com/unixorn/awesome-zsh-plugins
source ${ZPLUG_HOME}/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug 'zsh-users/zsh-history-substring-search'
zplug 'ael-code/zsh-colored-man-pages'
zplug 'zdharma-continuum/fast-syntax-highlighting'
zplug 'z-shell/zsh-diff-so-fancy'
zplug 'kaplanelad/shellfirm'
zplug 'justjanne/powerline-go'
zplug 'xylous/gitstatus'
zplug 'arialdomartini/oh-my-git'

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load 
eval "$(navi widget zsh)" &> /dev/null


if (hash shellfirm &> /dev/null)
then
    source ${HOME}/.dotfiles/shellfirm-plugin.sh
fi

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(history-substring-search colored-man-pages zsh-syntax-highlighting diff-so-fancy navi shellfirm powerline-go gitstatus oh-my-git ranger)

# User configuration

#export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
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

# Fixes tmux window renaming
DISABLE_AUTO_TITLE="true"

# Unset the autonaming for tmux
DISABLE_AUTO_TITLE="true"

# Shell like vim
set -o vi

#################################
# Aliases
#################################
# Fancy Bash Tools #
if (hash htop &> /dev/null)
then
    alias top='htop'
fi
if (hash bat &> /dev/null) || (hash batcat &> /dev/null)
then
    if (hash batcat &> /dev/null)
    then
        # Ubuntu
        alias cat='batcat -p'
    else
        alias cat='bat -p'
    fi
    export MANPAGER="sh -c 'col -bx | bat -l man -p"
fi

# Make sure this is above ls aliases 
if (hash exa &> /dev/null)
then
    alias ls='exa'
fi
####################
# Normal Aliases

alias ls='ls -v --color=auto -h' # numerical sort, color, human readable
alias la='ls -a'
alias ll='ls -lh'
alias vi='vim'
alias ssh='ssh -YC'
# Tree replacement if don't have tree
if ! (hash tree &> /dev/null)
then
    alias tree='find . | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"'
fi
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
#################################
# Exports 
#################################
# Add custom bin to path and make it take priority
export PATH=$HOME/.bin:$PATH

#################################
# Machine Specific Configurations
#################################
if [[ $(uname) == "Darwin" ]]; then
    CONDA_ROOT="/opt/anaconda3"

    if (hash kitty &> /dev/null)
    then
        alias ssh='kitty +kitten ssh'
    fi
    export ZSH_ASK_API_KEY=`cat ${HOME}/.dotfiles/api_keys/openai.api`
    source ${HOME}/.dotfiles/zsh-ask/zsh-ask.zsh
    alias ask='ask -mi' # Add markdown and interactive
elif [[ $(uname) == "Linux" ]]; then
    if [[ `hostname` = shi* ]]
    then
        CONDA_ROOT="/workspace/swalton2/anaconda3"
    else
        CONDA_ROOT="${HOME}/.anaconda3"
    fi
else
    echo "I don't know the conda path for a machine of type `uname`"
fi

#################################
# Custom Functions
#################################
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('${CONDA_ROOT}/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${CONDA_ROOT}/etc/profile.d/conda.sh" ]; then
        . "${CONDA_ROOT}/etc/profile.d/conda.sh"
    else
        export PATH="${CONDA_ROOT}/bin:$PATH"
    fi
fi
unset __conda_setup

# KILL SSH AGENTS
#function sshpid()
#{
#    echo `ps aux | grep ssh-agent -s | cut -d " " -f6 | head -n1`
#}
#sshpid
#if [[ ! -z "$(sshpid)" ]]; then
#    export SSH_AGENT_PID=$(sshpid)
#    ssh-add ~/.ssh/*_rsa 1&> /dev/null
#else
eval $(ssh-agent -s) &> /dev/null
#ssh-add ~/.ssh/*_rsa &> /dev/null

#fi
function killssh()
{
    kill -9 $SSH_AGENT_PID
}
trap killssh 0


#################################
# Theming
#################################
#
# SpaceDuck Theme (for zsh-syntax-highlighting)
# Code licensed under the MIT license
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

