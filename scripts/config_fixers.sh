#!/usr/bin/env bash
################################################################################
# Fix sheldon's environment variable issue for PATH
# By default Sheldon will greatly expand your PATH variable due to adding a path
# for each individual plugin. Instead we will softlink all executable files to a
# central location and then just add that single one to our PATH variable
#
# Usage:
# Source in your zshrc file and then call.
# This 
#
# Author: Steven Walton
# Contact: scripts@walton.mozmail.com
# LICENSE: MIT
################################################################################

fix_sheldon() {
    # Clean the path back to normal (Debian/Ubuntu should have this)
    # This will clear all user defined PATH variables!
    #if [[ -e /etc/environment ]]; then
    #    eval $(cat /etc/environment)
    #fi
    # I think OSX PATH looks like this before Sheldon?
    # /opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
    # Dirs will probably look like this
    # mkdir ${HOME}/.local/share/sheldon/bin
    # ln -s ${HOME}/.local/share/sheldon/repos/github.com/z-shell/zsh-diff-so-fancy/bin/* ${HOME}/.local/share/sheldon/bin
    mkdir -p -- "$1"/bin
    for d in $(find "$1" -type d -name "bin"); do
        for f in $(find "$d" -type f -executable); do
            ln -s -- "$f" "$1"/bin
        done
    done
}
