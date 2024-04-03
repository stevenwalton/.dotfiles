#!/usr/bin/env bash
DOT_DIR="${DOT_DIR:-${HOME}/.dotfiles}"
VERBOSE=1

GetBrew() {
}

BrewList() {
    list="\
htop \
btop \
tmux \
mactex-no-gui \
lsd \
tre \
stats \
git-lfs \
curl \
glow \
ranger \
fd \
fzf \
sheldon \
"
    echo $list
}

BrewFontList() {
    list="\
font-fira-code \
font-fira-code-nerd-font \
font-fira-mono-for-powerline \
font-fira-mono-for-nerd-font \
font-powerline-symbold \
"
    echo $list
}

BrewInstall() {
    brew install "$BrewList"
    if [[ $FONTS ]]; then
        brew tap homebrew/cask-fonts
        brew install --cask "$BrewFontList"
    fi
}

main() {
    if [[ command -v brew &> /dev/null ]]; then

    fi
}
