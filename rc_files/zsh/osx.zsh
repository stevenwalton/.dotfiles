# Did we install coreutils?
CORE_UTILS="${HOME%/}/.local/bin/coreutils"
RUBY_PATH="${HOMEMBREW_PREFIX%/}/opt/chruby"
ZSH_ASK_PATH="${DOTFILE_DIR%/}/zsh-ask"

function config_coreutils() {
    [[ -d "${CORE_UTILS}" ]] && export PATH="${CORE_UTILS%/}:${PATH}"
}

## Ruby for Jekyll
function config_jekyll() {
    if [[ -d "${RUBY_PATH%/}" ]];
    then
        # It seems that batcat can error this
        source "${RUBY_PATH%/}/share/chruby/chruby.sh"
        source "${RUBY_PATH%/}/share/chruby/auto.sh"
        chruby ruby-3.1.3
        export JEKYLL_EDITOR=vim
    fi
}

function config_brew() {
    if (_exists brew)
    then
        alias ctags="`brew --prefix`/bin/ctags"
    fi
}

function config_gpt() {
    if [[ -d "$ZSH_ASK_PATH" && -d "${DOTFILE_DIR%/}/.api_keys" ]];
    then
        export ZSH_ASK_API_KEY=`cat ${HOME}/.dotfiles/api_keys/openai.api`
        #export ZSH_ASK_MODEL="gpt-4-1106-preview"
        export ZSH_ASK_MODEL="gpt-4o"
        #export ZSH_ASK_TOKENS=128000
        source "${ZSH_ASK_PATH%/}/zsh-ask.zsh"
        alias ask='ask -mi' # Add markdown and interactive
    fi
}

main() {
    config_coreutils || echo "Failed to configure coreutils"
    config_jekyll || echo "Failed to config jekyll"
    config_brew || echo "Failed to configure brew"
    config_gpt || echo "Failed to configure GPT"
}

main || echo "Couldn't load osx configs"
