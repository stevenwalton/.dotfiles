####################
################################################################################
# Author: Steven Walton
# Contact: shell_scripts@walton.mozmail.com
# LICENSE: MIT
# Install script for building zsh from source
################################################################################
VERSION=0.1

MIRROR="https://www.zsh.org/pub"
DOWNLOAD_DIR="/tmp"
BUILD_DIR="${HOME%/}/.local/builds"
PREFIX="${HOME%/}/.local"
ETC_DIR="${HOME%/}/.local/etc"
VERBOSE=0
OPTIONS=

set -x

usage() {
    cat << EOF
Install zsh from source (version: ${VERSION})
Script will automatically download and build zsh. Who needs apt when you got
curl?

Options can be set either with flags or environment variables (shown).
Help optins show the variables and associated default locations (expanded)

[USAGE]
    install_zsh [OPTIONS]

[OPTIONS]
    -h, --help
        Print this message

    -b, --build-dir
        directory to build file (default: BUILD_DIR=${BUILD_DIR})

    -d, --download-dir
        directory to download file (default: DOWNLOAD_DIR=${DOWNLOAD_DIR})

    -m, --mirror
        mirror to download zsh from (default: MIRROR=${MIRROR})

    -t, --target, --prefix
        location to install zsh to (default: PREFIX=${PREFIX})

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
            -f | --download-dir)
                shift
                DOWNLOAD_DIR=$1
                ;;
            -t | --target | --prefix)
                shift
                BIN_DIR=$1
                ;;
             -v | --verbose)
                VERBOSE=1
                ;;
            *)
                ;;
        esac
        shift
    done
}

get_version() {
    # Get latest version
    SOURCE_FILE=$(curl -sL $MIRROR | grep -Eo "zsh-([0-9]+\.)+tar\.xz" | uniq | sort -rV)
}

download() {
    #if [[ $VERBOSE -gt 0 ]]; then
    #    echo -e "\033[1;33mDownloading ${MIRROR}/${SOURCE_FILE} to ${DOWNLOAD_DIR}/\033[0m"
    #fi
    #curl -sL "${MIRROR}/${SOURCE_FILE}" -o "${DOWNLOAD_DIR}/${SOURCE_FILE}"
    #ZSH_INSTALL_DIR=$(echo "${SOURCE_FILE}" | cut -d "." -f 1-2)
    ZSH_INSTALL_DIR=$(echo "${SOURCE_FILE}" | sed -e "s/\.tar\.xz//g")
    if [[ $VERBOSE -gt 0 ]]; then
        echo -e "\033[1;33mGot ZSH_INSTALL_DIR=${ZSH_INSTALL_DIR}\033[0m"
    fi
}

extract_tar() {
    tar xf "${DOWNLOAD_DIR}/${SOURCE_FILE}" -C "${BUILD_DIR}/"

    if [[ $VERBOSE -gt 0 ]]; then
        echo "\033[1;33mExtracted ${DOWNLOAD_DIR}/${SOURCE_FILE} to ${BUILD_DIR}\033[0m"
    fi
}

configure_zsh() {
    cd "${BUILD_DIR}/${ZSH_INSTALL_DIR}"
    if [[ $VERBOSE -gt 0 ]]; then
        echo -e "\033[1;33mIn $( pwd )\033[0m"
        echo -e "\033[1;33mShould be in ${BUILD_DIR}/${ZSH_INSTALL_DIR}\033[0m"
    fi
    if [[ $VERBOSE -gt 0 ]]; then
        echo -e "\033[1;33mRunning ./configure ..\033[0m."
        echo -e "\033[1;33mPrefix is ${PREFIX}\033[0m"
    fi
    # Help with this can be found in configure.ac
    #OPTIONS+=" --enable-multibyte"  # supports multibyte characters
    #OPTIONS+=" --enable-unicode9" # unicode9 character widths
    #OPTIONS+=" --enable-maildir-support" # Enables maildir with MAIL & MAILPATH
    #OPTIONS+=" --enable-function-subdirs" # Installs functions in subdirectories
    #OPTIONS+=" --enable-pcre" # Enable search for pcre2 Pearl Compatible Regular Expressions library
    #OPTIONS+=" --enable-gdbm" # Enables support for GDBM GNU dbm: database functions
    #OPTIONS+=" --enable-cap" # Enables search for POSIX capabilities
    #OPTIONS+=" --enable-zsh-mem-warnings" # print warnings when errors in memory allocation
    #OPTIONS+=" --enable-zsh-secure-free" # turn on error checking for free
    #OPTIONS+=" --enable-stack-allocation" # Dynamically allocate memory on stack when possible
    #OPTIONS+=" --docdir=$HOME/.local/share/doc/zsh"
    #OPTIONS+=" --htmldir=$HOME/.local/share/doc/zsh/html"
    #OPTIONS+=" --enable-etcdir=$ETC_DIR/zsh" # location for global zsh scripts
    #OPTIONS+=" --enable-scriptdir=$HOME/.local/zsh/scripts" # Path to install scripts to
    #OPTIONS+=" --enable-zshenv=$ETC_DIR/zshenv"
    #OPTIONS+=" --enable-zlogin=$ETC_DIR/zlogin" 
    #OPTIONS+=" --enable-zlogout=$ETC_DIR/zlogout" 
    #OPTIONS+=" --enable-zprofile=$ETC_DIR/zprofile"
    #OPTIONS+=" --enable-zshrc=$ETC_DIR/zshrc"
    OPTIONS+=" --with-term-lib='ncursesw termcap ncurses'"
    #OPTIONS+=" --with-tcsetpgrp"
    #OPTIONS+=" --enable-fndir=$HOME/.local/share/zsh/functions"
    ./configure \
        --prefix=${PREFIX} \
        "${OPTIONS[@]}"
    # Maybe want these?
    # --enable-readnullcmd=PAGER # Pager used when READNULLCMD is not set? BAT?
}

install_zsh() {
    get_args $@
    get_version
    download
    extract_tar
    configure_zsh

    if [[ $VERBOSE -gt 0 ]]; then
        echo -e "\033[1;33mRunning make\033[0m"
    fi
    cd "${BUILD_DIR}/${ZSH_INSTALL_DIR}"
    make -j12
    if [[ $VERBOSE -gt 0 ]]; then
        echo -e "\033[1;33mRunning make install (in $( pwd ) )\033[0m"
    fi
    #make install
    #make -C Doc zsh.pdf
}

install_zsh "$@" || exit 1
