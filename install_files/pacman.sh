#!/usr/bin/env bash
DOT_DIR="${DOT_DIR:-${HOME}/.dotfiles}"
VERBOSE=1
INSTALL_LIST="${INSTALL_LIST:-${DOT_DIR%/}/install_files/pacman.txt}"

UpdateAndUpgrade() {
    sudo pacman -Syyu
}

InstallApps() {
    sudo pacman -S  --needed - < "$INSTALL_LIST"
}

main() {
    UpdateAndUpgrade || (echo "Couldn't Syyu!!" && exit 1)
    InstallApps || (echo "Couldn't install packages" && exit 1)
}

main "$@" || exit 1
