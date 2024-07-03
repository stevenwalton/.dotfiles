# Don't have this working now so work with micromamba
#!/usr/bin/env bash
DOT_DIR="${DOT_DIR:-${HOME}/.dotfiles}"
BUILD_LOC="/tmp/miniforge.sh"
PREFIX="${HOME%/}/.local/share/conda"

usage() {
    cat << EOF
EOF
}

main() {
    echo "Miniforge install isn't working so try micromamba instead"
    exit 1
    #curl -Ls "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" -o $BUILD_LOC
    #sh $BUILD_LOC -b -p $PREFIX
}

main "$@" || exit 1
