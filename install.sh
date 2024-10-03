#!/usr/bin/env bash
################################################################################
# This file is mostly here for convenience purposes
# The meat of the installation scripts will be found in install_files
# There is a linux, osx, and common installer, we will try to detect this 
# automatically. Common calls for installs that are common on both systems, such
# as building from source.
#
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# License: MIT
################################################################################
DOT_DIR_NAME="${DOT_DIR_NAME:-.dotfiles}"
DOT_DIR="${DOT_DIR:-${HOME%/}/${DOT_DIR_NAME%/}}"
CONFIG_DIR="${CONFIG_DIR:-${HOME%}/.config}"
VERBOSE=1
USE_DEFAULTS=

usage() {
    cat << EOF
Dotfile Install Script

Install script will try to install a new system setup.
Intended for usage on Linux and OSX. We will try to detech
which system you have and do the appropriate install. 
We expect that you have cloned the install directory and 
haven't deleted or moved any install files.

USAGE
    install [OPTIONS]

OPTIONS:
    -h, --help
        print this message

    -y, --yes
        Accept all options

    -v, --verbose
        Increase verbosity

    -d, --dotfiles
        Sets dotfiles directory. Default: ${DOT_DIR}

    -n, --name
        Sets the name of the dotfiles directory. Default: ${DOT_DIR_NAME}
EOF
}

set_git_config() {
    # Set git to merge when pulling
    git config --global pull.rebase false
}


install() {
    if [[ -a "${_DINSTALL}/${1}" ]]; then
        source "${_DINSTALL}/${1}" "${@:2}" \
            && success "${1} built" \
            || error "${1} failed to build"
    else
        error "Couldn't find ${_DINSTALL}/${1}"
    fi
}

link_rcfiles() {
    # TODO: Fix so ${0} replicated ${HOME%/}/${0}" but anywhere 
    # TODO: Fix for mac which uses -depth and at the post -name position
    find "${DOT_DIR%/}/rc_files" \
        -maxdepth 1 \
        ! -name "*.md" \
        ! -name "*root" \
        ! -name "mozilla" \
        ! -name "zsh" \
        -exec bash -c 'ln -s "${0}" "${HOME%/}/.${0##*/"' {} \;
}

link_configs() {
    # TODO: Same fixes as above
    find "${DOT_DIR%/}/configs/" \
        -maxdepth 1 \
        ! -name "*.md" \
        -exec bash -c 'ln -s "${0}" "${CONFIG_DIR%/}/${0##*/}"' {} \;
}

install_cargo() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rust_installer.sh
    sh /tmp/rust_installer.sh -y
}

get_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in 
            -h | --help)
                ;;
            -d | --dotfiles)
                shift
                DOT_DIR="$1"
                ;;
            -n | --name)
                shift
                DOT_DIR_NAME="$1"
                ;;
            -v | --verbose)
                # Export so all scripts get value
                export VERBOSE=$(( $VERBOSE+1 ))
                ;;
            -q | --quiet)
                export VERBOSE=0
                ;;
            *)
                ;;
        esac
        shift
    done
}

main() {
    echo "Not complete yet"
    exit 1

    get_args "$@"
    INSTALL_FILE_LOC=$(realpath ${0})
    DF_PATH=${INSTALL_FILE_LOC%/*}
    # Check that we know where files are
    if [[ "${DF_PATH##/*}" != ".dotfiles" ]];
    then
        echo -e "\e[1;31m"
        echo -e "ERROR: We expect the install file to be located in our dotfiles path"
        echo -e "\e[0m"
        exit 1
    fi
    
    if [[ -d "${DOT_DIR}/install_files" ]]; then
        export INSTALLER_DIR="${DOT_DIR}/install_files"
        source ${INSTALLER_DIR}/installer.sh

        BUILD_DIR="${BUILD_DIR:-"/tmp/dotfile_builds"}"
        if [[ ! -d "${BUILD_DIR}" ]]; then
            warn "${BUILD_DIR} doesn't exist, creating..."
            mkdir ${BUILD_DIR}
        fi
        # Install vim
        if [[ -a "${INSTALLER_DIR}/vim.sh" ]]; then
            #source "${_DINSTALL}/vim.sh" -b ${BUILD_DIR} -t \
            #    && success "vim built successfully" \
            #    || error "vim failed to install"
            install "${INSTALLER_DIR}/vim.sh" -b ${BUILD_DIR} -t
        fi
        # Make sure to install vundle into the right directory
        # git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        # Install zsh
        #if [[ -a
    else
        echo "Couldn't find ${BUILD_DIR}"
    fi
}

# 
main "$@" || exit 1
