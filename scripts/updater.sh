#!/usr/bin/env bash
################################################################################
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# LICENSE: MIT
# Basic functions I find useful. Generally when scripting
################################################################################

# Update git and optionally run make
# You can add sudo make install for things like curl scripts but I suggest not
function gitUpdater () {
    current_dir=${PWD}
    # Look for arguments 
    while [[ $# -gt 0 ]]; do
        echo -e "Looking at var ${1}"
        case $1 in
            -d | --directory)
                # Shift to get next value
                shift
                target_dir=$1
                ;;
            -m | --make)
                make_flag=true
                ;;
            *) ;;
        esac
        shift
    done

    cd $target_dir
    git pull
    if [[ -n $make_flag && $make_flag == true ]]; then
        make
    fi
    # Move back to original location
    cd $current_dir
}

# TODO: script to tell us what packages have been updated and we will need to
# run make install on
function updateReporter () {
}
# TODO: script to do make install
function gitUpgrader () {
}
