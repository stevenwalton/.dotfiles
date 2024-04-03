#!/usr/bin/env bash
DOT_DIR="${DOT_DIR:-${HOME}/.dotfiles}"
VERBOSE=1

UpdateAndUpgrade() {
    sudo apt update
    sudo apt upgrade
}

InstallList() {
    list="\
build-essentials \
pkg-config \
openssl \
libssl-dev \
universal-ctags \
cmake \
unzip \
zsh \
htop \
tmux \
fzf \
fd-find \
git-lfs \
ranger \
fonts-powerline \
fonts-firacode \
"
    # These only work with Ubuntu 22.04 (assuming 'or later')
    if [[ $(lsb_release --description | cut -d ' ' -f2) -ge 22 ]]; then
        list+="\
lsd \
tre \
cargo \
btop \
"
    fi
    echo "$list"
}

AptInstall() {
    sudo apt install "$InstallList"
}

main() {
    if [[ command -v apt &> /dev/null ]]; then
        UpdateAndUpgrade
        AptInstall
    else
        echo -e "\033[1;31m[ERROR]:\033[0m can't find command 'apt'" 
        exit 1
    fi
}

main "$@" || exit 1
