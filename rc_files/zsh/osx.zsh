# Did we install coreutils?
if [[ -d ${HOME%/}/.local/bin/coreutils ]];
then
    export PATH="${HOME%}/.local/bin/coreutils/:${PATH}"
fi
## Ruby for Jekyll
if [[ -d /opt/homebrew/opt/chruby/ ]];
then
    # It seems that batcat can error this
    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    source /opt/homebrew/opt/chruby/share/chruby/auto.sh
    chruby ruby-3.1.3
    export JEKYLL_EDITOR=vim
fi

if (_exists brew)
then
    alias ctags="`brew --prefix`/bin/ctags"
fi
if [[ -d ${HOME}/.dotfiles/zsh-ask ]];
then
    export ZSH_ASK_API_KEY=`cat ${HOME}/.dotfiles/api_keys/openai.api`
    #export ZSH_ASK_MODEL="gpt-4-1106-preview"
    export ZSH_ASK_MODEL="gpt-4o"
    #export ZSH_ASK_TOKENS=128000
    source ${HOME}/.dotfiles/zsh-ask/zsh-ask.zsh
    alias ask='ask -mi' # Add markdown and interactive
fi

#if [[ -x "${HOME%/}"/.local/bin/micromamba ]];
#then
#    # >>> mamba initialize >>>
#    # !! Contents within this block are managed by 'mamba init' !!
#    export MAMBA_EXE='/Users/steven/.local/bin/micromamba';
#    export MAMBA_ROOT_PREFIX='/Users/steven/.mamba';
#    __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
#    if [ $? -eq 0 ]; then
#        eval "$__mamba_setup"
#    else
#        alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
#    fi
#    unset __mamba_setup
#    # <<< mamba initialize <<<
#elif [[ -d /opt/homebrew/anaconda3 ]];
#then
#    export CONDA_ROOT="/opt/homebrew/anaconda3"
#fi
