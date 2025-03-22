#!/usr/bin/env bash
################################################################################
# This file is mostly here for convenience purposes
# The meat of the installation scripts will be found in install_files
# There is a linux, osx, and common installer, we will try to detect this 
# automatically. Common calls for installs that are common on both systems, such
# as building from source.
#
# There are a few commands worth noting that you may want to incorporate into
# your own install script. See the note in the README for rc_files about the
# find command. This is a big reason for the organization in the first place!
#
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# License: MIT
################################################################################
DOTFILE_DIR="${DOTFILE_DIR:-${HOME%/}/.dotfiles}"
DOTFILE_DIR_NAME="${DOTFILE_DIR_NAME:-".dotfiles"}"
CONFIG_DIR="${CONFIG_DIR:-${HOME%}/.config}"
INSTALLERS_DIR="${INSTALLERS_DIR:-${DOTFILE_DIR}}"
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
    find "${DOTFILE_DIR%/}/rc_files" \
        -maxdepth 1 \
        ! -name "*.md" \
        ! -name "*root" \
        ! -name "mozilla" \
        ! -name "zsh" \
        -exec bash -c 'ln -Fis "${0}" "${HOME%/}/.${0##*/}"' {} \;
}

link_configs() {
    # TODO: Same fixes as above
    find "${DOTFILE_DIR%/}/configs/" \
        -maxdepth 1 \
        ! -name "*.md" \
        -exec bash -c 'ln -Fis "${0}" "${CONFIG_DIR%/}/${0##*/}"' {} \;
}

install_cargo() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rust_installer.sh
    sh /tmp/rust_installer.sh -y
}

# Install vim plug and then run the command PlugInstall to install the plugins
vim_plugins() {
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    [[ "$!" -eq 0 ]] && echo "Plug installed successfully"
    vim -c "PlugInstall" -c "qa"
    [[ "$!" -eq 0 ]] && echo "Plug Plugins installed successfully"
}

install_vim() {
    if [[ -a "${INSTALLERS_DIR%/}/vim.sh" ]];
    then
        # Make executable if not already
        [[ -x "${INSTALLERS_DIR%/}/vim.sh" ]] || chmod +x "${INSTALLERS_DIR%/}/vim.sh"
        echo "Installing Vim"
        install "${INSTALLERS_DIR%/}/vim.sh" 
        [[ "$!" -eq 0 ]] && echo "Vim installed successfully"
    else
        echo "Could not find vim installer"
    fi
    if [[ -d "${HOME%/}/.vim" \
          && -d "${HOME%/}/.vim/autoload/" \
          && ! -f "${HOME%/}/.vim/autoload/plug.vim"
         ]];
    then
        vim_plugins
    fi
}

install_zsh() {
    if [[ -a "${INSTALLERS_DIR%/}/zsh.sh" ]];
    then
        [[ -x "${INSTALLERS_DIR%/}/zsh.sh" ]] || chmod +x "${INSTALLERS_DIR%/}/zsh.sh"
        echo "Installing zsh"
        install "${INSTALLERS_DIR%/}/zsh.sh"
        [[ "$!" -eq 0 ]] && echo "zsh installed successfully"
    else
        echo "Could not find zsh installer"
    fi
}

install_uv() {
    curl -fLo /tmp/uv_src.sh https://astral.sh/uv/install.sh
    chmod +x /tmp/uv_src.sh
    # Don't touch my rc files!
    sh /tmp/uv_src.sh --no-modify-path
}

get_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in 
            -h | --help)
                ;;
            -d | --dotfiles)
                shift
                DOTFILE_DIR="$1"
                ;;
            -n | --name)
                shift
                DOTFILE_DIR_NAME="$1"
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

    get_args "$@"
    INSTALL_FILE_LOC=$(realpath "${0}")
    DF_PATH=${INSTALL_FILE_LOC%/*}
    # Check that we know where files are
    if [[ "${DF_PATH##/*}" != ".dotfiles" ]];
    then
        echo -e "\e[1;31m"
        echo -e "ERROR: We expect the install file to be located in our dotfiles path"
        echo -e "\e[0m"
        exit 1
    fi
    
    if [[ -d "${DOTFILE_DIR}/install_files" ]]; then
        export INSTALLER_DIR="${DOTFILE_DIR}/install_files"
        source ${INSTALLER_DIR}/installer.sh

        BUILD_DIR="${BUILD_DIR:-"/tmp/dotfile_builds"}"
        if [[ ! -d "${BUILD_DIR}" ]]; then
            warn "${BUILD_DIR} doesn't exist, creating..."
            mkdir ${BUILD_DIR}
        fi
        # Install vim
        install_vim
        # Install Plug
        # curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        echo "Couldn't find ${BUILD_DIR}"
    fi
}

# 
main "$@" || exit 1
