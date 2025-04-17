################################################################################
# This file holds aliases for zsh
# This should be called before basic_aliases, which should ideally contain
# aliases for core-utils. Since we might replace them with fancy-cli tools here,
# we'll want those to come second
#
# Some tools have different names depending on the system.
# For example bat is `bat` on most linux versions but `batcat` on Ubuntu 20.04
# While you shouldn't use 20.04 sometimes you gotta ¯\_(ツ)_/¯
# To use the proper command within this script use the format
# ${PROGRAM_TYPE[${HAVE_PROGRAM}]}
# Replace PROGRAM with the relevant program (like bat)
################################################################################
# User modifiable variables should be up here
declare BAT_THEME="Dracula"
# Check what things we have because fd and bat are fucking annoying -___-
# Use ${BAT_TYPE[${HAVE_BAT}]} to access the correct bat command
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
        if [[ $(fzf --version | cut -d " " -f-1 | cut -d "." -f-2) -ge 0.48 ]];
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
    else
        alias_base_ls
    fi
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
    if [[ $HAVE_FZF -eq 1 && $HAVE_TMUX -ge 1 && $TERM_PROGRAM == "tmux" ]];
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
        if [[ $(env | grep tmux) && $TERM_PROGRAM == "tmux" ]];
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
            source ".venv/bin/activate"
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
        alias spy="source .venv/bin/activate"
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

alias_ytdlp() {
    if (_exists yt-dlp)
    then
        declare astring="alias ytdl='yt-dlp"
        # Lots of blocking may be by based on user agent. Be the masses
        if [[ ! $(yt-dlp --list-impersonate-targets | grep "not available") ]];
        then
            astring+=" --impersonate chrome:windows-10"
        fi
        # Parallel fragments
        astring+=" --continue --progress -N 4"
        # Don't download less than 250Kbps
        # Don't download faster than 10Mbps (don't stress server)
        astring+=" --throttled-rate 500K --limit-rate 100M"
        # Increase buffer size for faster downloads
        # See `sysctl net.ipv4.tcp_rmem`
        astring+=" --buffer-size 4096"
        # Sleep between retries, exponential growth for fragments (blocking)
        astring+=" --retry-sleep linear=1::2 --retry-sleep fragment:exp=1:20"
        # Sleep between requests and downloads
        astring+=" --sleep-requests 1 --sleep-interval 1 --max-sleep-interval 30"
        # include subtitles
        astring+=" --write-subs --no-write-auto-subs --sub-langs \"en.*\""
        if (_exists aria2c)
        then
            astring+=" --downloader=aria2c"
            astring+=" --downloader-args aria2c:--max-connection-per-server=4"
        fi
        astring+="'"
        eval "$astring"
    fi
}

alias_vim() {
    if (_exists nvim)
    then
        alias vi='nvim'
        alias vim='nvim'
    elif (_exists vim)
    then
        alias vi='vim'
    fi
}

# Check if diff-so-fancy is installed and if so set the git alias
load_diff_so_fancy() {
    if (_exists diff-so-fancy)
    then
        if [[ $HAVE_BAT -ge 1 ]];
        then
            git config --global core.pager "diff-so-fancy | ${BAT_TYPE[$HAVE_BAT]} --tabs=4 --plain --decorations=auto --paging=auto"
        else
            git config --global core.pager "diff-so-fancy | less --tabs=4 --RAW-CONTROL-CHARS --quit-if-one-screen --quiet --use-color"
        fi
        git config --global interactive.difffilter "diff-so-fancy --patc"
    else
        git config --global --unset core.pager
        git config --global --unset interactive.difffilter
    fi
}

# Extend uv command to include `pip install --upgrade --all` 
# Idea driven by discussion here: https://github.com/astral-sh/uv/issues/1419
# Thanks @rosmur! 
function uv() {
   # Check that the command `uv` exists
   if [[ $(command -v "uv") ]];
   then
      # We only want to extend the command when given this specific argument
      if [[ "${@}" == 'pip install --upgrade --all' ]];
      then
         uv pip list \
            | tail -n +3 \
            | cut -d ' ' -f1 \
            | xargs uv pip install --upgrade
      # Otherwise just take the arguments and pass them back to uv as normal
      else
         command uv "$@"
      fi
   else
      echo "Command 'uv' not found in PATH"
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
    load_function "$HAVE_TMUX" "tmux_alias" || echo "Tmux aliasing failed"
    load_function "$HAVE_TOP" "alias_top" || echo "top aliasing failed"
    alias_ls || echo "ls aliasing failed"
    load_function "$HAVE_BAT" "alias_bat" || echo "bat aliasing failed"
    load_function "$HAVE_FZF" "alias_fzf" || echo "fzf aliasing failed"
    load_function "$HAVE_FD" "alias_fd" || echo "fd aliasing failed"
    snek_wrangling || echo "Snek wrangling failed! Is this the cobra effect?!"
    alias_ytdlp || echo "yt-dlp aliasing failed"
    alias_vim || echo "vim aliasing vailed"
    load_diff_so_fancy
}

main
