#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

alias pacman='pacman --color=auto'
alias la='ls -a'
alias vi='vim'
alias rm='echo -e "\n\n\033[33;31m Are you sure this is the directory you want?\n\n";pwd;echo -e "\033[0m\n\n";rm -i'
export PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]$\[\e[m\] \[\e[1;37m\]'
## Root's PS1
# export PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]#\[\e[m\] \[\e[0;32m\]'


archey3
export SUDO_EDITOR=rvim
