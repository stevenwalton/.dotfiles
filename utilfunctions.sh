#!/bin/bash

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
