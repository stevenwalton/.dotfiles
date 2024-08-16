# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export SUDO_EDITOR=rvim

# Make these interactive
alias cp='cp -i'
alias rm='rm -i'

if [[ -r "${HOME%/}/.cargo/env" ]];
then
    . "${HOME%/}/.cargo/env"
fi
