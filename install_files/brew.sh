#!/usr/bin/env bash
################################################################################
# Helper file for installing brew and brew programs
# Will install brew if not installed and then install a list of packages.
# Good idea to specify what packages are and do.
# 
# Use the cat <<- style to create sane listing and easy editing
################################################################################
DOT_DIR="${DOT_DIR:-${HOME}/.dotfiles}"
VERBOSE=1

########################################
#           Helper Functions
########################################
recho() {
    echo -e "\033[1;31m${1}\033[0m"
}

gecho() {
    echo -e "\033[1;32m${1}\033[0m"
}

yecho() {
    echo -e "\033[1;33m${1}\033[0m"
}
########################################

GetBrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

########################################
#            Package Lists
########################################
BrewList() {
    # What are these programs?
    # bat: better cat
    # btop: graphical top replacement
    # caffeine: keep awake (wrapper for caffinate)
    # chafa: CLI image viewer (sixel)
    # fd: fast find (note: respects .gitignore by default)
    # ffmpeg-full: all ffmpeg (yazi wants)
    # fzf: fuzzy search
    # git-lfs: git large file storage
    # glow: markdown rendering in cli
    # htop: different top replacement
    # imagemagick-full: image editor (yazi wants for full)
    # jq: Json parser
    # mactex: LaTeX
    # lsd: better ls
    # poppler: PDF rendering
    # resvg: SVG renderer (yazi wants)
    # ripgrep: better grep (note: respects .gitignore by default)
    # sevenzip: 7-zip (yazi wants)
    # sheldon: zsh plugin management
    # stats: show computer stats on toolbar
    # tmux: Multiplexer
    # tre: regex library
    # yazi: TUI filebrowser (similar to ranger)
    # zoxide: better cd (yazi wants)
    brew install $(\
        cat <<- PACKAGELIST
            bat
            btop
            caffeine
            chafa
            fd
            ffmegp-full
            fzf
            git-lfs
            glow
            htop
            imagemagick-full
            jq
            mactex-no-gui
            lsd
            poppler
            resvg
            ripgrep
            sevenzip
            sheldon
            stats
            tmux
            tre
            yazi
            zoxide
PACKAGELIST
)
}

CaskList() {
    # Just this for now
    # ghostty: The best term emulator
    brew install --cask $(\
        cat <<- CASKLIST
            ghostty
CASKLIST
)
}

BrewFontList() {
    # Nerd fonts for better symbols and ligatures
    #gecho "Tapping cask fonts"
    #brew tap homebrew/cask-fonts
    gecho "Installing Fira Fonts"
    brew install --cask $(\
        cat <<- FIRAFONTS
            font-fira-code
            font-fira-code-nerd-font
            font-fira-mono-nerd-font
            font-powerline-symbols
FIRAFONTS
)
}
########################################

# Main install function
BrewInstall() {
    gecho "Installing main brew packages"
    #BrewList || recho "Failed to install general brew list"
    gecho "Installing Powerline fonts"
    BrewFontList || recho "Failed to install fonts"
    gecho "Installing cask based packages"
    CaskList || recho "Failed to install Cask List"
}

main() {
    if [[ $(command -v brew &> /dev/null) ]];
    then
        yecho "Need to install brew first!"
        GetBrew || recho "Failed to install brew" && exit 1
    fi
    gecho "Installing brew packages"
    BrewInstall
}

main || recho "Failed to install :(" && exit 1
