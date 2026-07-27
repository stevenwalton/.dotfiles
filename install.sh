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
# Attended by default. An attended run uses `ln -i`, which prompts before
# replacing anything that already exists, so nothing is clobbered silently.
# Passing --unattended swaps in `ln -f` and lets the run proceed without gates.
UNATTENDED=
LN_OPTS="-sin"

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

    -u, --unattended
        Never prompt. Symlinking overwrites existing files instead of asking
        first. Default is attended, where you are asked before each replace.

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

# Symlink every top-level entry of a directory into a destination directory.
#
#   link_tree <source_dir> <dest_dir> <prefix> [ignore_pattern ...]
#
# Each <ignore_pattern> is a find -name glob. They are OR'd together and negated
# as a single group -- `! \( -name a -o -name b \)` -- so adding an exclusion is
# just another argument rather than another stacked `!`.
#
#   link_tree "${DOTFILE_DIR}/rc_files" "${HOME}"       "." "*.md" "*root" "zsh"
#   link_tree "${DOTFILE_DIR}/configs"  "${CONFIG_DIR}" ""  "*.md"
#
# Three details that matter:
#
#   -mindepth 1   The start directory is itself at depth 0, so without this find
#                 returns it too and you get a ~/.rc_files symlink pointing at
#                 the whole tree. This replaces the old `! -name "rc_files"`.
#
#   ! -name '.*'  Skips repo metadata such as configs/.gitignore, which would
#                 otherwise be linked to ~/.config/.gitignore.
#
#   -exec ... +   Passes the entire batch to ONE bash as "$@" instead of forking
#                 a bash per file (which is what `\;` does), hence the `for`
#                 loop in the callback and the `_` standing in for $0.
#                 A parallel variant exists --
#                   find ... -print0 | xargs -0 -P 8 -n 16 bash -c '...' _
#                 -- but -P interleaves the `ln -i` prompts into nonsense and
#                 piping loses find's exit status, so it is not used here.
#
# ln flags come from $LN_OPTS: -sin when attended (prompt before replacing),
# -sfn when --unattended. The -n matters on macOS: BSD ln follows an existing
# symlink-to-directory and links inside it, where GNU ln replaces it. A real
# directory at the destination is a different problem that no flag portably
# solves, so the callback checks for it explicitly.
link_tree() {
    local src="${1%/}" dst="${2%/}" prefix="$3"
    shift 3

    local -a args=( "$src" -mindepth 1 -maxdepth 1 ! -name '.*' )

    # Fold the caller's ignore patterns into one negated -o group
    if [[ $# -gt 0 ]]; then
        local pat first=1
        args+=( '!' '(' )
        for pat in "$@"; do
            [[ $first -eq 1 ]] || args+=( -o )
            args+=( -name "$pat" )
            first=0
        done
        args+=( ')' )
    fi

    # A real directory at the destination is never replaced automatically.
    # ln would link *into* it (~/.vim/vim) instead of over it, and -n does
    # not change that -- -n only governs symlinks-to-directories. GNU has
    # -T, which refuses correctly, but BSD/macOS ln does not, so the check
    # lives here where it works on both.
    args+=( -exec bash -c '
        dst="$1" prefix="$2" opts="$3"
        shift 3
        for f; do
            target="${dst}/${prefix}${f##*/}"
            if [[ -d "$target" && ! -L "$target" ]]; then
                printf "SKIP %s (real directory in the way; move it aside)\n" \
                    "$target" >&2
                continue
            fi
            ln "$opts" "$f" "$target"
        done
    ' _ "$dst" "$prefix" "$LN_OPTS" '{}' + )

    find "${args[@]}"
}

link_rcfiles() {
    # rc_files/* -> ~/.*   (README.md, bashrc_root, and the zsh/ dir are handled
    # elsewhere; mozilla's *contents* go to a Library path on macOS)
    link_tree "${DOTFILE_DIR%/}/rc_files" "${HOME%/}" "." \
        '*.md' '*root' 'mozilla' 'zsh'
}

link_configs() {
    # configs/* -> ~/.config/*   (no dot prefix)
    link_tree "${DOTFILE_DIR%/}/configs" "${CONFIG_DIR%/}" "" \
        '*.md'
}

configure_brew() {
    # Installs and configures brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
            -u | --unattended)
                # Export so sub-scripts can also skip their own prompts
                export UNATTENDED=1
                LN_OPTS="-sfn"
                ;;
            *)
                ;;
        esac
        shift
    done
}

main() {
    echo "Not complete yet so don't use"
    exit 0

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
