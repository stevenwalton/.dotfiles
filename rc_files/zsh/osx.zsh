# Did we install coreutils?
CORE_UTILS="${HOME%/}/.local/bin/coreutils"
[[ -d "${CORE_UTILS}" ]] && export PATH="${CORE_UTILS%/}/:${PATH}"

## Ruby for Jekyll
RUBY_PATH="${HOMEMBREW_PREFIX%/}/opt/chruby"
if [[ -d "${RUBY_PATH%/}" ]];
then
    # It seems that batcat can error this
    source "${RUBY_PATH%/}/share/chruby/chruby.sh"
    source "${RUBY_PATH%/}/share/chruby/auto.sh"
    chruby ruby-3.1.3
    export JEKYLL_EDITOR=vim
fi

if (_exists brew)
then
    alias ctags="`brew --prefix`/bin/ctags"
fi

ZSH_ASK_PATH="${DOTFILE_DIR%/}/zsh-ask"
if [[ -d "$ZSH_ASK_PATH" ]];
then
    export ZSH_ASK_API_KEY=`cat ${HOME}/.dotfiles/api_keys/openai.api`
    #export ZSH_ASK_MODEL="gpt-4-1106-preview"
    export ZSH_ASK_MODEL="gpt-4o"
    #export ZSH_ASK_TOKENS=128000
    source "${ZSH_ASK_PATH%/}/zsh-ask.zsh"
    alias ask='ask -mi' # Add markdown and interactive
fi

