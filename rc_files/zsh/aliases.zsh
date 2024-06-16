################################################################################
# This file holds aliases for zsh
################################################################################
################################################################################
# Fancy CLI Commands
################################################################################
# 
# top 
# htop https://github.com/htop-dev/htop
#
if (_exists htop)
then
    alias top='htop'
fi

#
# ls
# Make sure this is above ls aliases 
# exa is deprecated. Prefer LSD
# lsd: https://github.com/lsd-rs/lsd
# exa:https://github.com/ogham/exa
#
if (_exists lsd)
then
    alias ls='lsd'
    alias la='lsd -A' # A drops . and ..
    alias ll='lsd -l' # h is automatic
elif (_exists exa)
then
    alias ls='exa'
    alias la='exa -a'
    alias ll='exa -lh' # h makes headers
else
    alias ls='ls -v --color=auto -h' # numerical sort, color, human readable
    alias la='ls -a'
    alias ll='ls -lh'
fi
# fzf
# https://github.com/junegunn/fzf
# We'll write functions for fdfind here. These will be called later
# Needs to be above bat
function fzfalias() {
    if (_exists fzf)
    then
        alias fzf="$1 --no-ignore | fzf"
    fi
}
function export_fzf_defaults() {
    if (_exists fzf)
    then
        export FZF_DEFAULT_OPTS="--ansi --preview '$1 --color=always --style=numbers {}'"
    fi
}

#
# cat
# batcat https://github.com/sharkdp/bat
# Unfortunately we have to handle a batcat or bat command
#
if (_exists bat) || (_exists batcat)
then
    # Function to replace help
    function bathelp() {
        # don't do -h because many like du and ls don't support
        if ( $1 --list-languages | grep "help" &>/dev/null )
        then
            lang="help"
        else
            lang="less"
        fi
        "$1" --language="${lang}" --style=plain 
    }
    # 
    # Git diff with bat
    function batdiff() {
        git diff --name-only --relative --diff-filter=d | xargs cat --diff
    }
    #
    function batman() {
        export MANPAGER="sh -c 'col -bx | $1 -l man -p'"
    }

    if (_exists batcat)
    then
        alias cat='batcat'
        alias -g -- --help='--help 2>&1 | bathelp batcat'
        batman batcat
        export_fzf_defaults batcat
    else
        alias cat='bat'
        alias -g -- --help='--help 2>&1 | bathelp bat'
        batman bat
        export_fzf_defaults bat
    fi
fi


# fdfind
# https://github.com/sharkdp/fd
# Similar issue with fd and fdfind
if (_exists fd) || (_exists fdfind)
then
    if (_exists fd)
    then
        # Ignore the automatic .gitignore
        # https://github.com/sharkdp/fd/issues/612
        alias fd="fd --no-ignore"
        fzfalias fd
    else
        alias fd="fdfind --no-ignore"
        fzfalias fdfind
    fi
fi

# really clear the screen
# Uses VT100 escape code \033 == \x18 == 27 == ESC (so this is <ESC>c
alias cls='printf "\033c"'
