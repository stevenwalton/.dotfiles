#!/usr/bin/env bash
####################
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# LICENSE: MIT
# Install script for building sc-im from source. sc-im is a terminal based
# spreadsheet calculator that is based around vim
####################
VERSION=0.1
MIRROR="https://github.com/andmarti1424/sc-im/"
LOG="/tmp/dotfiles_install_scim.log"
INSTALLER_DIR="${INSTALLER_DIR:-${HOME%/}/.dotfiles/install_files}"

MIRROR="https://github.com/vim/vim"
DOWNLOAD_DIR="/tmp"
BUILD_DIR="${HOME%/}/.local/builds"
PREFIX="${HOME%/}/.local"
DL_METHOD="curl"
VERBOSE="${VERBOSE:-1}"

usage() {
    cat << EOF
Install sc-im from source (version: ${VERSION})
Script to automatically download and install sc-im
It will find the newest version and build that.

[USAGE]
    install_scim [OPTIONS]

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

_exists() {
    command -v "$1"
}

warn() {
    echo -e "\033[1;33m$1\033[0m"
    echo "${1} $(date '%D  %T %Z')" >> $LOG
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

scim_version () {
    SCIM_VERSION=$(curl -Ls -o /dev/null -w %{url_effective} "${MIRROR%/}/releases/latest/" | rev | cut -d "/" -f 1 | rev)
}

curl_install() {
    # Get the current sc-im version
    scim_version
    # Download
    curl -Ls "${MIRROR%/}/archive/refs/tags/${SCIM_VERSION}.tar.gz" -o "${DOWNLOAD_DIR%/}scim.tar.gz"
}

install_scim() {
    get_args "$@"
    if [[ -z $OS ]]; then
        _find_os 
    fi
}

install_vim "$@" || exit 1
