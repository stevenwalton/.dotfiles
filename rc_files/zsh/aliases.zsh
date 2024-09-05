################################################################################
# This file holds aliases for zsh
# This should be called before basic_aliases, which should ideally contain
# aliases for core-utils. Since we might replace them with fancy-cli tools here,
# we'll want those to come second
################################################################################

################################################################################
#                                   tmux 
################################################################################
# Tmux doesn't like to recognize 256 colouring, so let's force it
# -u fixes backspace error thing
if (_exists tmux)
then
    alias tmux='tmux -2 -u'
fi

################################################################################
#                                   top 
#                   https://github.com/htop-dev/htop
################################################################################
if (_exists htop)
then
    alias top='htop'
fi

################################################################################
#                                   ls
#                      exa is deprecated. Prefer LSD
#                   lsd: https://github.com/lsd-rs/lsd
#                   exa: https://github.com/ogham/exa
#             !! ==> Make sure this is above ls aliases <== !!
#       If basic_aliases is loaded after aliases then this should be handled
################################################################################
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

################################################################################
#                                   fzf
#                   https://github.com/junegunn/fzf
#       We'll write functions for fdfind here. These will be called later
#                   !! ==> Needs to be above bat <== !!
################################################################################
function fzfalias() {
    if (_exists fzf)
    then
        alias fzf="$1 --no-ignore | fzf"
    fi
}
function export_fzf_defaults() {
    if (_exists fzf && (_exists bat || _exists batcat) && _exists chafa )
    then
        export FZF_DEFAULT_OPTS='--ansi --preview
        "if file --mime-type {} | grep -qF image/gif;
        then
            chafa --passthrough auto --size 40 --watch --animate on {};
        elif file --mime-type {} | grep -qF image/;
        then
            chafa --passthrough auto --size 40 --watch --animate off {};
        elif file --mime-type {} | grep -aF -e text -e json;
        then
            bat --color=always --theme=Dracula --style=numbers,grid --line-range :500 {};
        fi"'
    elif (_exists fzf && (_exists bat || _exists batcat) )
    then
        export FZF_DEFAULT_OPTS='--ansi --preview "bat --color=always --theme=Dracula --style=numbers,grid --line-range :500 {};"'
    fi
}

################################################################################
#                                   fd
#                      https://github.com/sharkdp/fd
#               System might either call it fd or fdfind -____-
################################################################################
if (_exists fd) || (_exists fdfind)
then
    if (_exists fd)
    then
        # Ignore the automatic .gitignore
        # See: https://github.com/sharkdp/fd/issues/612
        alias fd="fd --no-ignore"
        fzfalias fd
    else #fdfind
        alias fd="fdfind --no-ignore"
        fzfalias fdfind
    fi
fi

################################################################################
#                                   BatCat
#                   batcat https://github.com/sharkdp/bat
#           Unfortunately we have to handle a batcat or bat command
################################################################################
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
        export MANROFFOPT="-c"
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


# really clear the screen
# Uses VT100 escape code \033 == \x18 == 27 == ESC (so this is <ESC>c
alias cls='printf "\033c"'

################################################################################
#                                   Python 
################################################################################
# I might be using different conda environments so let's check and prefer mamba
# to micromamba
if (_exists mamba)
then
    alias conda='mamba'
elif (_exists micromamba)
then
    alias conda='micromamba'
fi

if (_exists conda )
then
    conda activate base
fi
