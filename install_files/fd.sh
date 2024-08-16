#!/usr/bin/env bash
####################
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# LICENSE: MIT
# Install script for building fd from source
####################
VERSION=0.1
LOG="/tmp/dotfiles_install_fd.log"
INSTALLER_DIR="${INSTALLER_DIR:-${HOME%/}/.dotfiles/install_files}"

MIRROR="https://github.com/sharkdp/fd"
DOWNLOAD_DIR="/tmp"
BUILD_DIR="${HOME%/}/.local/builds"
DL_METHOD="git"
VERBOSE="${VERBOSE:-1}"

usage() {
    cat << EOF
Install fd from source (version: ${VERSION})
It will find the newest version and build that.

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
        download using curl. Maybe you don't have git? (default: DL_METHOD=${DL_METHOD})
    -v, --verbose
        You know what this does

EOF
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
            -d | --download-dir)
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

git_get () {
    git -C "$BUILD_DIR" clone "$MIRROR" 
    # cd into the git repo
    cd "${BUILD_DIR%/}/${MIRROR##*/}"
}

curl_get() {
    FD_VERSION=$(curl -Ls -o /dev/null -w %{url_effective} "${MIRROR%/}/releases/latest/" | rev | cut -d "/" -f 1 | rev)
    curl -Ls "${MIRROR%/}/archive/refs/tags/${FD_VERSION}.tar.gz" -o "${DOWNLOAD_DIR%/}/fd.tar.gz"
    tar xzf "${DOWNLOAD_DIR%/}/fd.tar.gz" -C "${BUILD_DIR%/}"
}

install_fd () {
    get_args "$@"
    #
    if [[ "$DL_METHOD" == "git" ]];
    then
        git_get
    elif [[ "$DL_METHOD" == "curl" ]];
    then
        curl_get
    else
        echo "I don't know DL_METHOD $DL_METHOD"
        exit 1
    fi
    cd "${BUILD_DIR%/}/${MIRROR##*/}"
    cargo build
    cargo test
    cargo install --path "${BUILD_DIR%/}/${MIRROR##*/}"
}

install_fd "$@" || exit 1
