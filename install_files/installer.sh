#!/usr/bin/env bash
VERSION=0.1
LOG="/tmp/dotfiles_installer.log"
VERBOSE="${VERBOSE:-1}"

# https://gist.github.com/viniciusdaniel/53a98cbb1d8cac1bb473da23f5708836
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

error() {
    echo -e "\033[1;31m[ERROR]:\033[0m $1" && exit 1
}

success() {
    echo -e "\033[1;32m[SUCCESS]:\033[0m $1"
}

warn() {
    echo -e "\033[1;33m[WARNING]:\033[0m $1"
}

notice() {
    echo -e "\033[1;34m[NOTICE]:\033[0m $1"
}

file_exist() {
    if [[ ! -a $1 ]]; then
        error "Couldn't find file ${1}" && exit 1
    fi
}

cmd_exist() {
    command -v "$1" &> /dev/nul
}

# TODO: Make better
vbose() {
    if [[ $VERBOSE -ge 2 ]]; then
        eval $1 ${@:2}
    elif [[ $VERBOSE -eq 1 ]]; then
        # Suppress stdin
        eval $1 ${@:2} > /dev/null
    else # quiet
        eval $1 ${@:2} 1&> /dev/null
    fi
}

install() {
    FILE=$1
    file_exist "$@" || exit 1
    vbose eval $1 "${@:2}" \
        && success "Successfully installed ${FILE}" \
        || error "Failed to install ${FILE}"
}

eval_cmd() {
    vbose eval "$1" \
        && success "Successfully ran ${1}" \
        || error "Failed to run ${1}"
}

