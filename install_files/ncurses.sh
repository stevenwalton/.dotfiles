#!/usr/bin/env bash
####################
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# LICENSE: MIT
# Install script for building ncurses from source
####################
VERSION=0.1
LOG="/tmp/dotfiles_install_ncurses.log"
INSTALLER_DIR="${INSTALLER_DIR:-${HOME%/}/.dotfiles/install_files}"

# Alt mirror at https://invisible-mirror.net/archives/ncurses/
# GNU version located at https://ftp.gnu.org/gnu/ncurses/
MIRROR="https://invisible-island.net/archives/ncurses/"
DOWNLOAD_DIR="/tmp"
BUILD_DIR="${HOME%/}/.local/builds"
PREFIX="${HOME%/}/.local"
VERBOSE="${VERBOSE:-1}"
OPTIONS=

usage() {
    cat << EOF
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
            -v | --verbose)
                VERBOSE=$(( VERBOSE+1 ))
                ;;
            *)
                ;;
        esac
        shift
    done
}

get_versions() {
    VERSIONS=$(curl -Ls "$MIRROR" | grep -Eo "$1-([0-9]+\.)+tar.gz" | uniq | sort -Vr)
    LATEST=$(echo -e "$VERSIONS" | head -n1)
    #VERSIONS=$(echo -e "$VERSIONS" |grep -Eo "([0-9]+\.[0-9]+)")
}

download_tar() {
    curl -sL "${MIRROR}/${LATEST}" -o "${DOWNLOAD_DIR}/${LATEST}"
}

extract_tar() {
    tar xzf "${DOWNLOAD_DIR}/${LATEST}" -C "${BUILD_DIR}/"
    BUILD_DIR=${BUILD_DIR}/$( echo "$LATEST" | sed -e "s/\.tar\.gz//g")
}

configure_ncurses() {
    # Compile-in feature to detect screensize for terminals which do not advertise their screensize, e.g., serial terminals.
    OPTIONS+="--enable-check-size"
    # Support wide characters
    OPTIONS+="--enable-widec"
    # Support pthreads
    OPTIONS+="--enable-pthread"
    # Support >16 colors
    OPTIONS+="--enable-ext-colors"
    ## Enable Mouse suppoort (FreeBSD)
    #OPTIONS+="--with-sysmouse"
    # Support mice with wheels (5th button)
    OPTIONS+="--enable-ext-mouse"
    # Compile in optimizations that use hard tabs.
    # Note: might not be accurate with terminfo entry
    OPTIONS+="--enable-hard-tabs"
    # Enables mixed case (normal for UNIX)
    OPTIONS+="--enable-mixed-case"
    # Generate .pc files for pkg-config
    OPTIONS+="--enable-pc-files"
    # Enable symbolic links
    OPTIONS+="--enable-symlinks"
    # ENable term caps
    OPTIONS+="--enable-termcap"
    OPTIONS+="--enable-getcap"
    # Check if compiler supports weak-symbols and if so reduce the number of
    # library files
    OPTIONS+="--enable-weak-symbols"
    # Shared library
    OPTIONS+="--with-shared"
    # Build lubcurses++ as shared
    OPTIONS+="--with-cxx-shared"
    OPTIONS+="--with-cxx-bindings"
    # Create entries in man-directory for alieases to manpages and symlinks
    OPTIONS+="--with-manpage-aliases"
    OPTIONS+="--with-manpage-symlinks"
    # Enable PCRE2 (pearl compatible RegEx) if user requests
    OPTIONS+="--with-pcre2"
    # Restrict root use of ncurses variables
    OPTIONS+="--disable-root-environ"
    OPTIONS+="--disable-root-access"
    # Restrict setuid use of ncurses env vars
    OPTIONS+="--disable-setuid-environ"
}

install_ncurses() {
    get_versions "ncurses"
    download_tar
    extract_tar
    cd "${BUILD_DIR}"
    ./configure --prefix "$PREFIX" "${OPTIONS[@]}"
    make -j12
    make install
}

install_ncurses "$@" || exit 1
