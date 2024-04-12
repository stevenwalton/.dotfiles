#!/usr/bin/env bash
################################################################################
# Installs files using package managers
# Files in common_list.txt are packages that can be installed both by apt and
# brew
#
# If a package has a unique name or we only want it on a specific system then...
# Files in ubuntu_list.txt are packages that can be installed with apt on Ubuntu
# 22.04
# Files in brew_list.txt are files that can be installed on brew
################################################################################
DOT_DIR=${DOT_DIR:-"${HOME%/}.dotfiles"}
VERBOSE=1
INSTALLER_DIR=${INSTALLER_DIR:-"${DOT_DIR%/}/install_files/"}
HOMEBREW_DIR=${HOMEBREW_DIR:-"/opt"}
PKG_MANAGER=
FULL_UPGRADE=

install_brew() {
    # https://docs.brew.sh/Installation
    git clone https://github.com/Homebrew/brew "${HOMEBREW_DIR}"homebrew
}

main() {
    source "${INSTALLER_DIR%/}/installer.sh"

    TO_INSTALL=$(<"${INSTALLER_DIR%/}/common.txt")
    if [[ $(uname) == "Linux" ]]; then
        if [[ -z "$PKG_MANAGER" ]]; then
            PKG_MANAGER="apt"
        fi
        if [[ "$PKG_MANAGER" -eq "apt" ]]; then
            eval_cmd "sudo $PKG_MANAGER update"
            if [[ -z "$FULL_UPGRADE" ]]; then
                eval_cmd "sudo $PKG_MANAGER -y upgrade"
            else
                eval_cmd "sudo $PKG_MANAGER -y full-upgrade"
            fi
        fi
        TO_INSTALL+=$(<"${INSTALLER_DIR%/}/ubuntu_list.txt")
    elif [[ $(uname) == "Darwin" ]];
        if [[ -z "$PKG_MANAGER" ]]; then
            PKG_MANAGER="brew"
        fi
        if [[ "$PKG_MANAGER" -eq "brew" && ! cmd_exist brew ]]; then
            install_brew
        fi
        eval_cmd "$PKG_MANAGER update"
        eval_cmd "$PKG_MANAGER upgrade"
        TO_INSTALL+=$(<"${INSTALLER_DIR%/}/brew_list.txt")
    fi
    eval_cmd "$PKG_MANAGER install $TO_INSTALL"
}

main || exit 1
