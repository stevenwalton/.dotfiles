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
    alias ta='tmux attach'
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
    alias la='ls -A' # ignore . and ..
    alias ll='ls -lh'
fi
#
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
        alias bat='batcat'
        alias -g -- --help='--help 2>&1 | bathelp batcat'
        batman batcat
    else
        alias cat='bat'
        alias -g -- --help='--help 2>&1 | bathelp bat'
        batman bat
    fi
fi

################################################################################
#                                   fzf
#                   https://github.com/junegunn/fzf
#       We'll write functions for fdfind here. These will be called later
#                   !! ==> Needs to be above bat <== !!
################################################################################
# With zsh press <C-t> to enter fzf mode 
if (_exists fzf)
then
    eval "$(fzf --zsh)"
fi

# Will be called by fd
function fzfalias() {
    if (_exists fzf)
    then
        alias fzf="$1 --no-ignore | fzf"
    fi
}

# fzf default options
# This function is to help create the correct FZF_DEFAULT_OPTIONS so that we can
# get much higher utility out of it.
#################################
# This should be called after bat
#################################
function export_fzf_defaults() {
    FZF_DEFAULT_OPTS='--ansi --preview '
    # If we have chafa installed then let's display pictures
    # For this to work properly we need chafa to be >= 1.14.4
    # https://github.com/hpjansson/chafa/issues/217
    if ( _exists chafa );
    then
        FZF_DEFAULT_OPTS+='"if file --mime-type {} | grep -qF image; then chafa '
        FZF_DEFAULT_OPTS+='--passthrough none -f sixels --size '
        # tmux can't display as large of images so we'll need to reduce them to
        # 30 as this is the max (determined by testing)
        if [[ $(env | grep tmux) ]];
        then
            FZF_DEFAULT_OPTS+='30 '
        else
            FZF_DEFAULT_OPTS+='${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES} '
        fi
        # Note the 'elif' for the bat lines
        FZF_DEFAULT_OPTS+='{}; elif '
    else
        FZF_DEFAULT_OPTS+='"if '
    fi
    FZF_DEFAULT_OPTS+='file --mime-type {} | grep -aF -e directory; then '
    if (_exists lsd);
    then
        FZF_DEFAULT_OPTS+='lsd --color always --icon always --almost-all '
        FZF_DEFAULT_OPTS+='--oneline --classify --long {}; '
    else
        FZF_DEFAULT_OPTS+='ls --color=always -Al {}; '
    fi
    if (_exists strings);
    then
        FZF_DEFAULT_OPTS+='elif file --mime-type {} | grep -aF -e binary; then '
        FZF_DEFAULT_OPTS+='strings {} | '
        if ( _exists bat );
        then
            FZF_DEFAULT_OPTS+='bat '
        else
            FZF_DEFAULT_OPTS+='batcat '
        fi
        FZF_DEFAULT_OPTS+='--color always --language c; '
    fi
    # If it is a text or json file we'll read it with bat
    # We could probably fizzbuzz this and just check that it isn't a bin
    FZF_DEFAULT_OPTS+='elif file --mime-type {} | grep -aF -e text -e json -e '
    FZF_DEFAULT_OPTS+='empty; then '
    # Support batcat with older Ubuntu
    if ( _exists bat );
    then
        FZF_DEFAULT_OPTS+='bat '
    else
        FZF_DEFAULT_OPTS+='batcat '
    fi
    FZF_DEFAULT_OPTS+='--color=always --theme=Dracula --style=numbers,grid '
    FZF_DEFAULT_OPTS+='--line-range :500 {}; fi"'
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}"
}
export_fzf_defaults

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
#                                   Python 
# Deprecated!
# Switching to use ruff more so we'll lose this
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
