## Ruby for Jekyll
if [[ -d /opt/homebrew/opt/chruby/ ]];
then
    # It seems that batcat can error this
    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    source /opt/homebrew/opt/chruby/share/chruby/auto.sh
    chruby ruby-3.1.3
    export JEKYLL_EDITOR=vim
fi
#
# Conda
export CONDA_ROOT="/opt/homebrew/anaconda3"

alias ctags="`brew --prefix`/bin/ctags"
export ZSH_ASK_API_KEY=`cat ${HOME}/.dotfiles/api_keys/openai.api`
export ZSH_ASK_MODEL="gpt-4-1106-preview"
#export ZSH_ASK_TOKENS=128000
source ${HOME}/.dotfiles/zsh-ask/zsh-ask.zsh
alias ask='ask -mi' # Add markdown and interactive
