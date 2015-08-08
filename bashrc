#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

alias pacman='pacman --color=auto'
alias la='ls -a'
alias vi='vim'
export PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]$\[\e[m\] \[\e[1;37m\]'


archey3
export SUDO_EDITOR=rvim
