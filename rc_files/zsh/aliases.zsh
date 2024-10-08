################################################################################
# This file holds aliases for zsh
# This should be called before basic_aliases, which should ideally contain
# aliases for core-utils. Since we might replace them with fancy-cli tools here,
# we'll want those to come second
################################################################################
# User modifiable variables should be up here
declare BAT_THEME="Dracula"
# Check what things we have because fd and bat are fucking annoying -___-
declare -i HAVE_BAT=0  # {bat=1, batcat=2}
declare -a BAT_TYPE=("bat" "batcat")
declare -i HAVE_FD=0   # {fd=1, fdfind=2}
declare -a FD_TYPE=("fd" "fdfind")
declare -i HAVE_TMUX=0 # {tmux = 1}
declare -i HAVE_LS=0   # {ls=0, lsd=1, exa=2}
declare -i HAVE_TOP=0  # {top=0, htop=1}
declare -i HAVE_FZF=0  # {fzf=1, fzf < version 0.48=2 }

check_versions() {
    # BAT
    if (_exists bat)
    then
        HAVE_BAT=1
    elif (_exists batcat)
    then
        HAVE_BAT=2
    fi

    # FD Find
    if (_exists fd) 
    then
        HAVE_FD=1
    elif (_exists fdfind)
    then
        HAVE_FD=2
    fi

    # FZF
    if (_exists fzf)
    then
        # fzf --version might appear like 0.55.0 (brew) or without the
        # subversison so split on . and only get major & minor
        if [[ $(fzf --version | cut -d "." -f-2) -ge 0.48 ]];
        then
            HAVE_FZF=1
        else
            HAVE_FZF=2
        fi
    fi

    # tmux
    if (_exists tmux)
    then
        HAVE_TMUX=1
    fi

    # LSD
    if (_exists lsd)
    then
        HAVE_LS=1
    elif (_exists exa)
    then
        HAVE_LS=2
    fi

    # HTOP
    if (_exists htop)
    then
        HAVE_TOP=1
    fi
}


################################################################################
#                                   tmux 
################################################################################
# Tmux doesn't like to recognize 256 colouring, so let's force it
# -u fixes backspace error thing
tmux_alias() {
    alias tmux='tmux -2 -u'
    alias ta='tmux attach'
}

################################################################################
#                                   top 
#                   https://github.com/htop-dev/htop
################################################################################
alias_top() {
    alias top='htop'
}

################################################################################
#                                   ls
#                      exa is deprecated. Prefer LSD
#                   lsd: https://github.com/lsd-rs/lsd
#                   exa: https://github.com/ogham/exa
#             !! ==> Make sure this is above ls aliases <== !!
#       If basic_aliases is loaded after aliases then this should be handled
################################################################################
alias_ls() {
    alias_lsd() {
        alias ls='lsd'
        alias la='lsd -A' # A drops . and ..
        alias ll='lsd -l' # h is automatic
    }
    alias_exa() {
        alias ls='exa'
        alias la='exa -a'
        alias ll='exa -lh' # h makes headers
    }
    alias_base_ls() {
        alias ls='ls -v --color=auto -h' # numerical sort, color, human readable
        alias la='ls -A' # ignore . and ..
        alias ll='ls -lh'
    }
    if [[ $HAVE_LS -eq 1 ]];
    then
        alias_lsd
    elif [[ $HAVE_LS -eq 2 ]];
    then
        alias_exa
    fi
    alias_base_ls
}
#
################################################################################
#                                   BatCat
#                   batcat https://github.com/sharkdp/bat
#           Unfortunately we have to handle a batcat or bat command
################################################################################
alias_bat() {
    # Function to replace help
    bathelp() {
        # don't do -h because many like du and ls don't support
        if ( "${BAT_TYPE[$HAVE_BAT]}" --list-languages | grep "help" &>/dev/null )
        then
            lang="help"
        else
            lang="less"
        fi
        "${BAT_TYPE[$HAVE_BAT]}" --language="${lang}" --style=plain 
    }
    # 
    # Git diff with bat
    batdiff() {
        git config --global alias 
        git diff --name-only --relative --diff-filter=d | xargs cat --diff
    }
    #
    batman() {
        export MANPAGER="sh -c 'col -bx | $1 -l man -p'"
        export MANROFFOPT="-c"
    }
    alias cat="${BAT_TYPE[$HAVE_BAT]}"
    alias -g -- --help="--help 2>&1 | bathelp ${BAT_TYPE[$HAVE_BAT]}"
    batman "${BAT_TYPE[$HAVE_BAT]}"
    export_fzf_defaults "${BAT_TYPE[$HAVE_BAT]}"
}

################################################################################
#                                   fzf
#                   https://github.com/junegunn/fzf
#       We'll write functions for fdfind here. These will be called later
#                   !! ==> Needs to be above bat <== !!
################################################################################

# fzf default options
# This function is to help create the correct FZF_DEFAULT_OPTIONS so that we can
# get much higher utility out of it.
#################################
# This should be called after bat
#################################
export_fzf_defaults() {
    FZF_DEFAULT_OPTS=''
    if [[ $HAVE_FZF -eq 1 && $HAVE_TMUX -ge 1 ]];
    then
        FZF_DEFAULT_OPTS+='--tmux 75% '
    fi
    FZF_DEFAULT_OPTS+='--ansi --preview '
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
        if [[ $HAVE_BAT -ge 1 ]];
        then
            FZF_DEFAULT_OPTS+="${BAT_TYPE[$HAVE_BAT]} --color always "
            FZF_DEFAULT_OPTS+="--theme=${BAT_THEME} --language c; "
        else
            FZF_DEFAULT_OPTS+="less; "
        fi
    fi
    # If it is a text or json file we'll read it with bat
    # We could probably fizzbuzz this and just check that it isn't a bin
    FZF_DEFAULT_OPTS+='elif file --mime-type {} | grep -aF -e text -e json -e '
    FZF_DEFAULT_OPTS+='empty; then '
    # Support batcat with older Ubuntu
    if [[ $HAVE_BAT -ge 1 ]];
    then
        FZF_DEFAULT_OPTS+="${BAT_TYPE[$HAVE_BAT]} --color always --theme=${BAT_THEME} "
        FZF_DEFAULT_OPTS+='--style=numbers,grid --line-range :500 {}; '
    else
        FZF_DEFAULT_OPTS+='less '
    fi
    FZF_DEFAULT_OPTS+='fi"'
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}"
}

alias_fzf() {
    # With zsh press <C-t> to enter fzf mode 
    # Option only available after version 0.48
    if [[ $HAVE_FZF -eq 1 ]];
    then
        eval "$(fzf --zsh)"
    fi

    if [[ $HAVE_FD -ge 1 ]];
    then
        alias fzf="${FD_TYPE[$HAVE_FD]} --no-ignore | fzf"
    fi
    export_fzf_defaults
}


################################################################################
#                                   fd
#                      https://github.com/sharkdp/fd
#               System might either call it fd or fdfind -____-
################################################################################
alias_fd() {
    alias fd="${FD_TYPE[$HAVE_FD]} --no-ignore"
}

################################################################################
#                                   Python 
# Deprecated!
# Switching to use ruff more so we'll lose this
################################################################################
# I might be using different conda environments so let's check and prefer mamba
# to micromamba
snek_wrangling() {

    if (_exists uv)
    then
        if [[ -d ".venv" ]];
        then
            source "${HOME%/}/.venv/bin/activate"
            if [[ "$PWD" != "${HOME%/}" ]];
            then
                echo "\tYou are not at home BUT we found virtual environment and loaded it."
            fi
        elif [[ -d "${HOME%/}/.venv" ]];
        then
            source "${HOME%/}/.venv/bin/activate"
        else
            echo "No default python in use"
            echo "\tPlease run \`uv venv --python \$MAJOR.\$MINOR\` in ${HOME}"
        fi
    elif (_exists mamba) || (_exists mamba) || (_exists micromamba)
    then
        declare -i SNEK=
        declare -a KINDA_SNEK=("mamba" "micromamba" "conda")
        if (_exists mamba)
        then
            SNEK=1
            alias conda='mamba'
        elif (_exists micromamba)
        then
            SNEK=2
            alias conda='micromamba'
        elif (_exists conda )
        then
            SNEK=3
            conda activate base
        fi
        echo -e "\033[1;35mNOTE:\033[0m system is using ${KINDA_SNEK[$SNEK]}"
        echo -e "\tPlease switch to UV"
        echo -e '    $ curl -LsSf https://astral.sh/uv/install.sh | sh'
    else
        echo -e "\tPlease install UV"
        echo -e '    $ curl -LsSf https://astral.sh/uv/install.sh | sh'
    fi
}

load_function() {
    if [[ "$1" -ge 1 ]];
    then
        eval "$2"
    fi
}

main() {
    check_versions
    load_function "$HAVE_TMUX" "tmux_alias"
    load_function "$HAVE_TOP" "alias_top"
    alias_ls
    load_function "$HAVE_BAT" "alias_bat"
    load_function "$HAVE_FZF" "alias_fzf"
    load_function "$HAVE_FD" "alias_fd"
    snek_wrangling
}

main
