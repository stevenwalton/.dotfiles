#!/usr/bin/env bash
DOT_DIR="${DOT_DIR:-${HOME}/.dotfiles}"
VERBOSE=1

usage() {
    cat << EOF
dotfile install script

USAGE
    install [OPTIONS]

OPTIONS:
    -h, --help
        print help information

    -y, --yes
        Accept all options

    -v, --verbose
        Enable verbose output

    -d, --target
        Sets target directory, default home
EOF
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
get_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in 
            -h | --help)
                ;;
            -d | --target)
                shift
                DOT_DIR=$1
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
    get_args "$@"
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
        # Install zsh
        #if [[ -a
    else
        echo "Couldn't find ${BUILD_DIR}"
    fi
}

# 
main "$@" || exit 1
