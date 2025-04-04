#!/usr/bin/env bash
############################################################
# Dumb script to update a git repo.
# Intended for cron jobs in repos that are for things like 
# notes, where we do not necessarily need good git logs and
# we're likely to forget continual pushes. 
#
# Author: Steven Walton
# LICENSE: MIT
# Contact: scripts@walton.mozmail.com
############################################################

LOG_FILE="${LOG_FILE:-"${HOME%/}/git_autoupdate.log"}"
REPO="${REPO:-$(pwd)}"
# Debug Variable
declare -i DEBUG=1

# Colors that can be used by a short name
declare GRN="\033[1;32m"
declare RED="\033[1;31m"
declare YLW="\033[1;33m"
declare CYN="\033[1;36m"

# Writes a log by passing a string to the function and we'll add date
# e.g.
# ```bash
# declare my_message="$(echo "Hello World")"
# write_log "${GRN}${list_of_files}"
# ```
# Outputs:
# [Day Month Date time year] : Hello World
# Where only "Hello World" is green
write_log() {
    # Use me if you don't want messages to also go to stdout
    #echo -e "[$( date +'%c' )] : ${1}\e[0m" >> $LOG_FILE
    # OSX doesn't need -e?
    echo "[$( date +'%c' )] : ${1}\033[0m" | tee -a $LOG_FILE
}


main() {
    # Take default repo parameters or allow it to be passed by an argument
    write_log "${CYN}Starting git autoupdate with input ${@}"
    if [[ "$#" -gt 0 ]];
    then
        if [[ "$#" -gt 1 ]];
        then
            write_log "${RED}Too many arguments passed"
            exit 1
        fi
        REPO="$1"
    fi

    cd "$REPO"
    [[ $DEBUG -eq 1 ]] && write_log "${CYN}Moved to ${REPO} (PWD=$(pwd))"
    
    # Check if we even need to update. If nothing done, quit
    needUpdate=$(git status | tail -n1)
    if [[ ${needUpdate} == *"nothing to commit"* ]];
    then
        [[ $DEBUG -eq 1 ]] && write_log "${CYN}Nothing to push"
        exit 0
    fi
    if [[ $(git status | grep ".gitignore") ]];
    then
        # Find the ignore file if for some reason it isn't in the right place
        # Not sure if this works with multiple but do we need to consider?
        # This already seems excessive
        ignore_file="$(git status \
            | grep .gitignore \
            | sed -e "s/.*\s*\(.*\.gitignore.*\)\s*.*$/\1/g" \
            )"
        git add "$ignore_file"
        [[ $DEBUG -eq 1 ]] && write_log "${CYN}Added files ${ignore_file}"
    fi
    # This is why you shouldn't use this in general
    git add -A 
    git commit -m "cron based auto update"
    # If there is a `make_readme` file that creates a directory structure then
    # run it and add the appropriate files
    if [[ -f "make_readme.md" ]];
    then
        sh make_readme.sh
        [[ $DEBUG -eq 1 ]] && write_log "${CYN}Ran make_readme.sh"
        git add -A
        git commit --amend --no-edit
        [[ $DEBUG -eq 1 ]] && write_log "${CYN}Added and committed"
    fi

    push_response="$(git push)"
    push_return_code="$?"
    if [[ $push_return_code -ne 0 ]];
    then
        write_log "${RED}Autoupdate failed to push! (currently in PWD=$(pwd))" 
        write_log "${RED}Return code ${push_return_code}"
        write_log "${push_response}" 
    fi
    [[ $DEBUG -eq 1 ]] && write_log "${CYN}Push return code ${push_return_code}"

}

main "$@" || write_log "${RED}Autoupdate failed (PWD=$(pwd) :: REPO=${REPO})"
