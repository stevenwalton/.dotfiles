#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'
alias ls='ls -G' # for macs because we have to be different -_____-

alias la='ls -a'
alias vi='vim'
export PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]$\[\e[m\] \[\e[1;37m\]'

export SUDO_EDITOR=rvim

## Legacy
#source /home/steven/GEANT4/geant4.10.1-install/bin/geant4.sh
#. /opt/openfoam221/etc/bashrc

# added by Anaconda2 2.4.0 installer
#export PATH="/home/steven/anaconda2/bin:$PATH"
#source /usr/local/bin/thisroot.sh
#export LD_LIBRARY_PATH=/home/steven/Tools/geant4.10.01.p02-install/lib/:$LD_LIBRARY_PATH
#source ~/Tools/geant4.10.01.p02-install/bin/geant4.sh
#
#export DISPLAY=0.0
