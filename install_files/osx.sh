#!/usr/bin/env bash


main() {
    # Install the linker
    xcode-select --install
}

main "$@" || exit 1
