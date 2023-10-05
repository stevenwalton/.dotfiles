export PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:$PATH"
######################
## General Exports ##
######################
export EDITOR="vim"
# Lines for autocompletion
autoload -Uz compinit # For compdef
compinit
# Completion notes
# - More *'s means 'more precise' (higher precidence)
# - %F{<color>} %f change foreground color
# - %K{<color>} %k change background color
# Some autocompletion
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ''
# case insensitive, partial word, and substring
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Enable approximate completion
zstyle ':completion:*' completer _complete _approximate
# Make "options" in green
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}==> %d <==%f'
# Set yellow color for approximate completions
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}==> %d (errors: %e) <==%f'
# Set messages in purple
zstyle ':completion:*:messages' format '%F{purple} ==> %d <==%f'
# Set warnings in red
zstyle ':completion:*:warnings' format '%F{red} ==> no matches found <==%f'
# Grouping
zstyle ':completion:*' group-name ''
# We want colors! All commands call the --color=auto 
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# Enable tab completion when flag has an equal sign
setopt magic_equal_subst


# Sheldon uses TOML files.
# Soft linked: ~/.dotfiles/sheldon_plugins.toml ~/.config/sheldon/plugins.toml
eval "$(sheldon source)"
# Bind keys for history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down\

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

#####################
# User configuration
#####################
# Starship theme
export STARSHIP_CONFIG="${HOME}/.dotfiles/starship.toml"
eval "$(starship init zsh)"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd
#bindkey -v
# Enable history search with up/down keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

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

# htop
if (command -v htop &> /dev/null)
then
    alias top='htop'
fi

# batcat
if (command -v bat &> /dev/null) || (command -v batcat &> /dev/null)
then
    _BAT=bat
    if (command -v batcat &> /dev/null)
    then
        # Ubuntu
        alias bat='batcat'
        _BAT=batcat
    fi
    alias cat='${_BAT}'
    # Helpful bat commands
    # Git diff with bat
    batdiff() {
        git diff --name-only --relative --diff-filter=d | xargs ${_BAT} --diff
    }
    # Help with bat
    ## Help gets overwritten by tao!
    #help() {
    #    "$@" --help 2>&1 | bat --plain --language=less
    #}
    # Aliases for help
    # don't do -h because many like du and ls don't support
    #alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
    if ( ${_BAT} --list-languages | grep "help" &>/dev/null )
    then
        _LANG=help
    else
        _LANG=less
    fi
    alias -g -- --help='--help 2>&1 | ${_BAT} --language=${_LANG} --style=plain'
    # make the manpager
    export MANPAGER="sh -c 'col -bx | ${_BAT} -l man -p'"
fi
# Ruby stuff for jekyll
#source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
#source /opt/homebrew/opt/chruby/share/chruby/auto.sh

# Make sure this is above ls aliases 
if (command -v lsd &> /dev/null)
then
    alias ls='lsd'
    alias la='lsd -A' # A drops . and ..
    alias ll='lsd -l' # h is automatic
elif (command -v exa &> /dev/null)
then
    alias ls='exa'
    alias la='exa -a'
    alias ll='exa -lh' # h makes headers
else
    alias ls='ls -v --color=auto -h' # numerical sort, color, human readable
    alias la='ls -a'
    alias ll='ls -lh'
fi

####################
# Normal Aliases
####################

alias rm='rm -I' # prompt when >3 files being deleted
alias vi='vim'
alias ssh='ssh -YC'
# Tree replacement if don't have tree
if ! (command -v tree &> /dev/null)
then
    alias tree='find . | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"'
fi
# Grep to have color, give line number, don't tell me it can't access restricted files (sudo), and don't process binary files (garbage output ):
alias grep='grep --color=always --no-messages --binary-files=without-match'

# Tmux doesn't like to recognize 256 colouring, so let's force it
# -u fixes backspace error thing
alias tmux='tmux -2 -u'
alias df='df -h'
alias log='git log --graph --oneline --decorate'

# File management
_FD=fd
if ( command -v fdfind &> /dev/null )
then
    # Some systems name this differently...
    alias fd="fdfind"
fi
if ( command -v fzf &> /dev/null && command -v fd &> /dev/null )
then
    # Fucking default command...
    if ( hash fd &> /dev/null )
    then
        _FD=fd
    elif ( hash fdfind &> /dev/null )
    then
        _FD=fdfind
    fi
    # In vim use <C-T> to open fzf and search through fd results
    #export FZF_DEFAULT_COMMAND='fd --type file'
    #export FZF_CTRL_T_COMMAND="${_FD} --type file"
    # Add color to fzf
    #export FZF_DEFAULT_COMMAND="${_FD} --type file --color=always --preview '${_BAT} --color=always --style=numbers {}'"
    alias fzf='${_FD} | fzf '
    export FZF_DEFAULT_OPTS="--ansi --preview '${_BAT} --color=always --style=numbers {}'"
fi

#if ( ( command -v fzf &> /dev/null ) && (command -v bat &> /dev/null) )
#then
#    # Add batcat for a previewer for fzf
#    alias fzf="fzf --preview '${_BAT} --color=always --style=numbers --line-range=:500 {}'"
#fi

# Linux only commands. This is kinda hacky
if [[ `command -v lsb_release` ]]
then
    alias open='xdg-open' 
fi
if [[ $(uname) == "Darwin" ]]; then
    alias ctags="`brew --prefix`/bin/ctags"
fi

#################################
# Machine Specific Configurations
#################################
if [[ $(uname) == "Darwin" ]]; then
    # Conda
    export CONDA_ROOT="/opt/homebrew/anaconda3"

    if (command -v kitty &> /dev/null)
    then
        alias ssh='kitty +kitten ssh'
    fi
    export ZSH_ASK_API_KEY=`cat ${HOME}/.dotfiles/api_keys/openai.api`
    source ${HOME}/.dotfiles/zsh-ask/zsh-ask.zsh
    alias ask='ask -mi' # Add markdown and interactive
elif [[ $(uname) == "Linux" ]]; then
    export CONDA_ROOT="${HOME}/.anaconda3"
else
    echo "I don't know the conda path for a machine of type `uname`"
fi
export CONDA_BIN=$CONDA_ROOT/bin
export PATH=$CONDA_BIN:$PATH
source $CONDA_BIN/activate

#################################
# Custom Functions
#################################
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('${CONDA_ROOT}/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    export PATH="${CONDA_ROOT}/bin:$PATH"
#fi
#unset __conda_setup
#export PATH="${CONDA_ROOT}/bin:$PATH"
#conda () {
#	\local cmd="${1-__missing__}"
#	case "$cmd" in
#		(activate | deactivate) __conda_activate "$@" ;;
#		(install | update | upgrade | remove | uninstall) __conda_exe "$@" || \return
#			__conda_reactivate ;;
#		(*) __conda_exe "$@" ;;
#	esac
#}

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

# Just because
eval "$(ssh-agent -s)" &>/dev/null
ssh-add ~/.ssh/`ls -I "*.pub" -I "*hosts*" ~/.ssh/` &>/dev/null


# For Nvidia
if [[ $(whoami) == "local-swalton" ]];
then
    conda activate py39
    source ~/Programming/tlt-pytorch/scripts/envsetup.sh
    alias tao="tao_pt --gpus all --env PYTHONPATH=/tao-pt --"
fi
