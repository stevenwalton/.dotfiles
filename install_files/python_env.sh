#!/usr/bin/env bash
PKG_LIST="${ENV_LIST:-${HOME%/}/.dotfiles/install_files/python_env.txt}"

main() {
    {
        # Install these one at a time because pip or maintainers can be fucking 
        # dumb and we'll get errors because dependencies might not be set up
        # correctly.
        cat $PKG_LIST | xargs -L1 python -m pip install
}

main "$@" || exit 1
