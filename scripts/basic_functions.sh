#!/usr/bin/env bash
################################################################################
# Author: Steven Walton
# Contact: dotfiles@walton.mozmail.com
# LICENSE: MIT
# Basic functions I find useful. Generally when scripting
################################################################################
VERSION=0.1
LOG=/tmp/function_log.log

################################################################################
################################################################################
################################################################################
# Check if a command exists
# [[ -n $(_exists() command) ]]; then
_exists() {
    command -v "$1" &> /dev/null
}

################################################################################
################ Logging functions and colored text ###########################
################################################################################

yellow() {
    echo -e "\033[1;33m$1\033[0m"
}

red() {
    echo -e "\033[1;31m$1\033[0m"
}

green() {
    echo -e "\033[1;32m$1\033[0m"
}

colorme() {
    if [[ ${1} -gt 0 && ${1} -lt 9 ]]; then
        echo -e "\033[1;3${1}m$2\033[0m"
    else
        echo "Colorme must be given a number >=0 (black) and <9 (white)"
    fi
}

# Will write messages to a $LOG file as well
warn() {
    yellow $1
    echo "WARNING [ $(date '%D  %T %Z') ]: ${1}" >> $LOG
}

error() {
    red $1
    echo "ERROR [ $(date '%D  %T %Z') ]: ${1}" >> $LOG
}

################################################################################
################################################################################
################################################################################
_which_os() { 
    if [[ $(uname) -eq "Linux" ]]; then
        OS="linux"
    elif [[ $(uname) -eq "Darwin" ]]; then
        OS="osx"
    else
        echo "Can't detect OS. Using `uname` and expected either 'Linux' or
        'Darwin' but found $(uname)"
        exit 1
    fi
    echo "${OS}"
}

# Get the directory that the script is being run in
getScriptDir () {
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null &&
        pwd )
}
################################################################################
################ Random Tools and Other Stuff ##################################
################################################################################
# Tar into an xz with max compression and multithreading
# xz is better than gzip or bzip
# Use this if you will stream large files or archive
# Usage: heavyCompress FolderIWannaZip
# Output: FolderIWannaZip.tar.xz
# https://www.rootusers.com/gzip-vs-bzip2-vs-xz-performance-comparison/
heavy_compress() {
    THREADS=${THREADS:-1}
    tar cf - "$1" | xz -9 --threads $THREADS --verbose > "$2"
}

kill_steam() {
    pkill steam-runtime-s 
    pkill steam-runtime-l 
    pkill steam 
    pkill steamwebhelper
}

alias_pip() {
    if ( _exists uv)
    then
        PIP_LOC="$(dirname "$(which python)")"
        # If you want to only run from the root directory (which .venv) exists
        # in then check with this conditional (allows arbitrary name for .venv)
        if [[ "${PIP_LOC}" == "${PWD%/}/"*"/bin" ]]
        then
            echo -e "#!/usr/bin/env bash\n\npip() {\n\tuv pip \"\$@\"\n}\n\npip \"\$@\"" > "${PIP_LOC%/}/pip"
            chmod +x "${PIP_LOC%/}/pip"
        else
            echo "Not in virtual environment root directory."\
                 "Please try again in ${PIP_LOC%/*/*}/"
        fi
    fi
}
