#!/usr/bin/env bash
################################################################################
# Simple bash script to help determine if git repos are out of sync
# Script will fetch the upstream path and mail the user if their branch is
# behind the specified one
#
# Set this to a cron job, systemd scheduler, git hook, LLM scheduler, or
# whatever you want
#
# Author: Steven Walton
# LICENSE: MIT
# Contact: scripts@walton.mozmail.com
################################################################################
set -eu -o pipefail
# Enable debugging
#set -x

# If you would like to mail other users then turn this into a list
MAIL_USER=${MAIL_USER:-$(whoami)}
# Use space separated
PROJECT_ROOT=
# Use format "upstream/main"
# We expect the "/"
UPSTREAM=${UPSTREAM:-orgin/main}
CURRENT_BRANCH=${CURRENT_BRANCH:-HEAD}

RED="\033[1;31m"
CLR="\033[0m"

err_msg() {
    echo -e "${RED}ERROR:${CLR} ${1}\n"
    usage
    exit 1
}

# Checks the upstream
CheckRepo() {
    upstream_name=$(echo ${UPSTREAM} | cut -d '/' -f1)
    upstream_branch=$(echo ${UPSTREAM} | cut -d '/' -f2)
    working_branch=$(git -C "${PROJECT_ROOT}" branch --show-current)
    project=$(basename "${PROJECT_ROOT}")
    #
    # Push to dev/null is like `--quiet` but also suppresses visual ssh fingerprints
    git fetch -C "${PROJECT_ROOT}" "${upstream_name}" "${upstream_branch}" &>/dev/null
    ahead=$(git -C "${PROJECT_ROOT}" rev-list --count "${CURRENT_BRANCH}"..upstream/main)
    if [ "$ahead" -gt 0 ];
    then
        SendMail "($project):${UPSTREAM}: ${ahead} ahead" \
                 "${UPSTREAM} is $ahead commits ahead of ${working_branch} (your current branch)."
    fi
}

# If you want to mail to multiple users then loop this
SendMail() {
    #for user in "${MAIL_USER[@]};
    #do
    echo -e "${2}" | mail -s "${1}" "${MAIL_USER}" || exit 1
    #          |                |          |____ User
    #          |                |_______________ Header
    #          |________________________________ Message
    #done
}

usage() {
    cat << HELP_EOF
This script mails the user if there are upstream changes on a git branch.
Useful for scheduling and letting users know when they need to rebase.

The last argument MUST be the repo's location

Usage: [ENV VARS] ./check_repo.sh [OPTIONS] [REPO DIRECTORY]

Arguments:
   [DIRECTORY]

Options:
    -b, --branch            Upstream branch to compare against [default: ${UPSTREAM}]
    -c, --current-branch    Current branch to check [default: ${CURRENT_BRANCH}]
    -h, --help              Print this message
    -m, --mail-to           Send mail to a specific user [default: ${MAIL_USER}]

ENV VARS:
    MAIL_USER           Sets the user to mail to [currently: \$(whoami)=$(whoami)]
    UPSTREAM            The upstream name/branch [currently: ${UPSTREAM}]
    CURRENT_BRANCH      The branch to compare with [currently: ${CURRENT_BRANCH}]

Example:
    ./check_repo.sh --branch "upstream/main" --mail-to "alice" "~/Work Programming/Fast moving project"
    UPSTREAM="upstream/main" MAIL_USER="alice" ./check_repo.sh "${HOME%/}/Work Programming/Fast moving project"
HELP_EOF
}

get_args() {
    if [[ "$#" -eq 1 ]];
    then
        if [[ "${1}" == "-h" || "${1}" == "--help" ]];
        then
            usage
            exit 0
        fi
    fi
    while [[ $# -gt 1 ]];
    do
        case $1 in
            -h | --help)
                usage
                exit 0
                ;;
            -b | --branch)
               shift
               UPSTREAM="${1}"
               ;;
            *)
                ;;
        esac
        shift
    done
    PROJECT_ROOT="${1}"
    # Allows ~ to be used in quoted directories
    PROJECT_ROOT="${PROJECT_ROOT/#\~/${HOME%/}}"
}


main() {
    [[ "$#" -eq 0 ]] && err_msg "You must define the project root"
    get_args "$@"
    if [ -z "${PROJECT_ROOT}" ];
    then
        err_msg "You must define the project root"
    fi
    CheckRepo
}

main "$@" || exit 1
