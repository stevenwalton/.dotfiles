#!/usr/bin/env bash
DOT_DIR="${DOT_DIR:-${HOME}/.dotfiles}"
BUILD_LOC="/tmp/micromamba.tar.bz2"
PREFIX="${HOME%/}/.local/bin"

usage() {
    cat << EOF
EOF
}

main() {
    if [[ $(uname) == "Darwin" ]];
    then
        if [[ $(uname -m) == "arm64" ]];
        then
            OS_TYPE="osx-arm64"
        else
            OS_TYPE="osx-64"
        fi
    elif [[ $(uname) == "Linux" ]];
    then
        if [[ $(uname -m) == "x86_64" ]];
        then
            OS_TYPE="linux-64"
        elif [[ $(uname -m) == "arm64" ]];
        then
            OS_TYPE="linux-aarch64"
        else
            echo "Don't know install for linux type $(uname -m)."
            exit 1
        fi
    else
        echo "We don't know how to build this type: $(uname)"
        exit 1
    fi
    curl -Ls "https://micro.mamba.pm/api/micromamba/${OS_TYPE}/latest" -o $BUILD_LOC
    tar xj $BUILD_LOC -C $PREFIX
}

main "$@" || exit 1
