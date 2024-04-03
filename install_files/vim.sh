#!/usr/bin/env bash
####################
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# LICENSE: MIT
# Install script for building vim from source
####################
VERSION=0.1
LOG="/tmp/dotfiles_install_vim.log"
INSTALLER_DIR="${INSTALLER_DIR:-${HOME%/}/.dotfiles/install_files}"

MIRROR="https://github.com/vim/vim"
DOWNLOAD_DIR="/tmp"
BUILD_DIR="${HOME%/}/.builds"
PREFIX="${HOME%/}/.local"
DL_METHOD="git"
VERBOSE="${VERBOSE:-1}"

usage() {
    cat << EOF
Install vim from source (version: ${VERSION})
Script to automatically download and install vim.
It will find the newest version and build that.
Unlike instaling via apt or brew we'll make sure to install python support.

[USAGE]
    install_vim [OPTIONS]

[OPTIONS]
    -h, --help
        Print this message

    -b, --build-dir
        directory to build file (default: BUILD_DIR=${BUILD_DIR})

    -d, --download-dir  
        directory to download files (default: DOWNLOAD_DIR=${DOWNLOAD_DIR})

    -m, --mirror
        mirror of vim source (default: MIRROR=${MIRROR})

    -q, --quiet
        Sets verbosity to 0. All output redirected to /dev/null

    -t, --target, --prefix
        location to install vim (default: PREFIX=${PREFIX})

    --git
        download with git (default: DL_METHOD=${DL_METHOD})

    --curl
        (unsupported) download using curl. Maybe you don't have git? (default: DL_METHOD=${DL_METHOD})
    -v, --verbose
        You know what this does

EOF
}

_exists() {
    command -v "$1"
}

warn() {
    echo -e "\033[1;33m$1\033[0m"
    echo "${1} $(date '%D  %T %Z')" >> $LOG
}

_find_os() {
    if [[ $(uname) = "Linux" ]]; then
        OS="linux"
        if [[ $PREFIX = "${HOME%/}/Library" ]]; then
            warn "You're on Linux but using ${HOME%/}/Library?"
            warn "Are you sure you're not on a Mac?"
            sleep 2
        fi
    elif [[ $(uname) = "Darwin" ]]; then
        OS="osx"
        if [[ $PREFIX = "${HOME%/}/.local" ]]; then
            warn "You're on OSX but using ${HOME%/}/.local?"
            warn "Are you sure you're not on Linux?"
            sleep 2
        fi
    else
        echo "Can't detect OS. Using `uname` and expected either 'Linux' or
        'Darwin' but found $(uname)"
        exit 1
    fi
}

get_args() {
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
            -q | --quiet)
                VERBOSE=0
                ;;
            -t | --target | --prefix)
                shift
                BIN_DIR=$1
                ;;
            --git)
                DL_METHOD="git"
                ;;
            --curl)
                echo "Curl currently unsupported"
                exit 1
                DL_METHOD="curl"
                ;;
            -v | --verbose)
                VERBOSE=$(( $VERBOSE+1 ))
                ;;
            *)
                ;;
        esac
        shift
    done
}

install_vim() {
    get_args "$@"
    if [[ -z $OS ]]; then
        _find_os 
    fi
    # Common installer file
    source "${INSTALLER_DIR}/installer.sh"

    cd $BUILD_DIR || exit 1
    if [[ $(_exists $DL_METHOD) && $DL_METHOD == "git" ]]; then
        vbose git clone ${MIRROR}
        # Git name of directory assuming it is the name of the final point of the
        # mirror. This makes sense for git but consider other mirrors
        VIMDIR=$(echo $MIRROR | rev | cut -d / -f 1 | rev)
    else
        echo "Currently only git is supported for downloading. This is intended as a todo note"
    fi
    cd $VIMDIR || error "Can't find directory ${VIMDIR}"
    # This is line by line so it is easier to edit whenever I decide to
    # understand this better and hyper optimize vim
    # TODO: allow for array of compile flags
    config_command="./configure "
    # Why is normal and huge basically the same?
    # tiny : 1.8 MB
    # normal : 3.7 MB
    # huge : 3.8 MB
    config_command+=" --with-features=huge"
    config_command+=" --with-compiledby='Steven Walton'"
    config_command+=" --prefix=${PREFIX}"
    # Most of this is included in huge anyways
    config_command+=" --enable-multibyte"
    config_command+=" --enable-cscope"
    config_command+=" --enable-terminal"
    config_command+=" --with-python3interp=yes"
    # TODO
    config_command+=" --with-python3-command=/usr/bin/python3.11"
    if [[ $(which python | grep anaconda) ]]; then
        warn "Python has anaconda, you're probably going to have a bad time"
    fi
    vbose $config_command || error "Failed to make vim config"
    if [[ $VERBOSE -ge 2 ]]; then
        success "vim config"
    fi
    vbose make  || error "Failed vim make"
    if [[ $VERBOSE -ge 2 ]]; then
        success "vim make"
    fi
    vbose "make install" || error "Failed vim make install"
}

install_vim "$@" || exit 1
