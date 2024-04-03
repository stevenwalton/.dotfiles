####################
################################################################################
# Author: Steven Walton
# Contact: shell_scripts@walton.mozmail.com
# LICENSE: MIT
# Install script for building zsh from source
################################################################################
VERSION=0.1

MIRROR="https://www.zsh.org/pub/"
DOWNLOAD_DIR="/tmp"
BUILD_DIR="${HOME%/}/.builds"
PREFIX="${HOME%/}/.local"

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
install_zsh() {
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
            *)
                ;;
        esac
        shift
    done
    file=$(curl -sL $MIRROR \
           | cut -d ">" -f 2 \
           | cut -d "<" -f 1 \
           | grep "^zsh-[[:digit:]].[[:digit:]].tar.xz$" \
    )
    curl -sL "${MIRROR}/${file}" -o "${DOWNLOAD_DIR}/${file}"
    ZSH_DIR=$(echo "${file}" | cut -d "." -f 1-2)
    tar xf "${DOWNLOAD_DIR}/${file}" -C "${BUILD_DIR}/"
    cd "${BUILD_DIR}/${ZSH_DIR}"
    ./configure --prefix=${PREFIX}
    make
    make install
}

install_zsh "$@" || exit 1
