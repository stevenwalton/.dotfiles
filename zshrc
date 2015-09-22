# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/steven/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall
#[ -e "${HOME}/.zsh_aliases" ] && source "${HOME}/.zsh_aliases"
#[ -e "${HOME}/.zshrc_local" ] && source "${HOME}/.zshrc_local"

# Alieses
alias ls='ls --color=auto'

alias pacman='pacman --color=auto'
alias la='ls -a'
alias vi='vim'
alias top='htop'

archey3
# You have to use npm to install npm, and that will give you the
# # completion.sh file you need.
# source /usr/local/lib/node_modules/npm/lib/utils/completion.sh
#
. $HOME/.antigen/powerline/powerline/bindings/zsh/powerline.zsh
 source "$HOME/.antigen/antigen.zsh"
#
antigen use oh-my-zsh
#
# # bundles from oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle screen
antigen bundle colored-man
#antigen-theme jreese
antigen theme jdavis/zsh-files themes/jdavis
antigen-apply
