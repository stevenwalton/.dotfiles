#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

alias la='ls -a'
alias vi='vim'
export PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]$\[\e[m\] \[\e[1;37m\]'

export SUDO_EDITOR=rvim

source /home/steven/GEANT4/geant4.10.1-install/bin/geant4.sh
. /opt/openfoam221/etc/bashrc
