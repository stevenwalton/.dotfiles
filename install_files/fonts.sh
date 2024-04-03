#!/usr/bin/env bash
################################################################################
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# LICENSE: MIT
# Install script for building fonts from source
################################################################################
VERSION=0.1

MIRROR="https://github.com/ryanoasis/nerd-fonts/releases/download/"
DOWNLOAD_DIR="/tmp"
LINUX_FONT_DIR="${HOME%/}/.local/share/fonts"
OSX_FONT_DIR="${HOME%/}/Library/Fonts"

usage() {
    cat << EOF
Install fonts from source (version: ${VERSION})
Script will automatically download and install a font from source.
Default mirror is to the nerd-fonts github but others can be used.

Options can be set either with flags or environment variables (shown).
Help optins show the variables and associated default locations (expanded)

[USAGE]
    install_fonts [OPTIONS]

[OPTIONS]
    -h, --help
        Print this message

    -b, --build-dir
        directory to build file (default: BUILD_DIR=${BUILD_DIR})

    -d, --download-dir
        directory to download file (default: DOWNLOAD_DIR=${DOWNLOAD_DIR})

    -f, --font
        font to download (default: FONT=${FONT})

    -m, --mirror
        mirror to download zsh from (default: MIRROR=${MIRROR})

    -t, --target
        location to build fonts into

EOF
}

_which_os() { 
    if [[ $(uname) -eq "Linux" ]]; then
        OS="linux"
        if [[ ${PREFIX} -eq "${HOME%/}/Library" ]]; then
            warn "You're on Linux but using ${HOME%/}/Library?"
            warn "Are you sure you're not on a Mac?"
            sleep 2
        fi
        FONT_DIR=$LINUX_FONT_DIR
    elif [[ $(uname) -eq "Darwin" ]]; then
        OS="osx"
        if [[ ${PREFIX} = "${HOME%/}/.local" ]]; then
            warn "You're on OSX but using ${HOME%/}/.local?"
            warn "Are you sure you're not on Linux?"
            sleep 2
        fi
        FONT_DIR=$OSX_FONT_DIR
    else
        echo "Can't detect OS. Using `uname` and expected either 'Linux' or
        'Darwin' but found $(uname)"
        exit 1
    fi
}

install_zsh() {
    while [[ $# -gt 0 ]]; do
        case $1 in 
            -h | --help)
                usage
                exit 0
                ;;
            -b | --build-dir)
                shift
                BUILD_DIR=$1
                ;;
            -m | --mirror)
                shift
                MIRROR=$1
                ;;
            -f | --download-dir)
                shift
                DOWNLOAD_DIR=$1
                ;;
            -t | --target)
                shift
                BIN_DIR=$1
                ;;
            *)
                ;;
        esac
        shift
    done
    _which_os
    curl -sSL

    
}

install_zsh "$@" || exit 1
