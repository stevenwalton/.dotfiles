#!/usr/bin/env bash
DOT_DIR="${DOT_DIR:-${HOME}/.dotfiles}"
VERBOSE=1
URL="${URL:-'https://sh.rustup.rs'}"
DOWNLOAD_DIR="${DOWNLOAD_DIR:-/tmp}"
INSTALLER_NAME="${INSTALLER_NAME:-rust_install.sh}"

usage() {
    cat << EOF
Installs rust and cargo

USAGE
    install [OPTIONS]

OPTIONS:
    -h,  --help
        print this message
    -d, --target
        Set directory installer will download to (default: "/tmp")
    -f, --file-name
        Set name of installer file (default: 'rust_installer.sh')
EOF
}

get_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in 
            -h | --help)
                ;;
            -d | --target)
                shift
                DOWNLOAD_DIR=$1
                ;;
            -f | --file-name)
                shift
                INSTALLER_NAME=$1
                ;;
            *)
                ;;
        esac
        shift
    done
}

# Better version of installing rust
# Friends don't let friends pipe into bash, even if scripts are wrapped in
# functions. We also ensure https and try to use better tls
install_rust() {
    get_args "$@"
    curl --proto '=https' --tls1.2 -sSf $URL > "${DOWNLOAD_DIR}/${INSTALLER_NAME}" && sh "${DOWNLOAD_DIR}/${INSTALLER_NAME}"
}

main "@" || exit 1
