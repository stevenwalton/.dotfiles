#!/usr/bin/env bash

############################################################
# Are you annoyed when you are listing to music on your
# phone and press the pause button on your computer
# expecting Spotify to pause but instead Apple Music opens?
#
# Are you tired of pressing play expecting Spotify to
# respond and then Apple Music opens?
#
# Well have no fear! We can fix that!
# Since Apple won't let us disable Apple Music and we can't
# rebind media keys, we'll just tell the program to fuck 
# off instead ^__^
# Because if we can't do things the right way, we can 
# instead be resource inefficient and do things the wrong
# way.
#
# This script is intended to be run as a daemon.
# That is, a process that is continually running in the 
# background.
# To do this we will need to use launchd, Apple's version
# of systemd (think different ;)
############################################################

# We might as well make it so we can tell other
# apps to fuck off ^__^
APP_TO_KILL="${APP_TO_KILL:-Music}"
# If pgrep fails, try kill -9 with PID
declare -i USE_PID_FALLBACK=${USE_PID_FALLBACK:-0}
########################################
# Probably don't use this 
declare -i APP_PID=${APP_PID:-}
# Don't modify
declare -i KILL_RESPONSE
declare -i EXIT_AFTER=0
########################################

# Check if our target application is running
# If it is then return 1 to the process (${?})
is_app_running() {
    echo "pregp Music $(pgrep Music) vs $(pgrep "${APP_TO_KILL}")" >> /Users/steven/FuckOff.log
    echo "Prior APP_PID ${APP_PID}" >> /Users/steven/FuckOff.log
    APP_PID="$(pgrep "${APP_TO_KILL}")"
    RVAL="$?"
    echo "Got APP_PID ${APP_PID}" >> /Users/steven/FuckOff.log
    if [[ ${RVAL} -eq 0 && -n "${APP_PID}" ]];
    then
        echo "Found process ${APP_TO_KILL} running with ${APP_PID}" >> /Users/steven/FuckOff.log
        return 1
    else
        echo "No process ${APP_TO_KILL} found" >> /Users/steven/FuckOff.log
        return 0
    fi
}

# Kill the app using pkill
kill_app_pkill() {
    pkill "${APP_TO_KILL}"
    KILL_RESPONSE="$?"
    if [[ $KILL_RESPONSE -ne 0 ]];
    then
        echo "Something went wrong and we couldn't kill ${APP_TO_KILL}" >> /Users/steven/FuckOff.log
        return 1
    fi
    APP_PID=
}

# If for some reason pkill didn't work
# then let's try with the PID
kill_app_pid() {
    kill -9 ${APP_PID}
    KILL_RESPONSE="$?"
    if [[ $KILL_RESPONSE -ne 0 ]];
    then
        echo "Something went wrong and we couldn't kill ${APP_TO_KILL} by PID (${APP_PID})" >> /Users/steven/FuckOff.log
        exit 1
    fi
    APP_PID=
}

# Our main kill loop
# WARNING: this is an infinite loop!
# This is intentionally meant to constantly run
# and kill the process IMMEDITATELY
kill_loop() {
    while true;
    do
        kill_once
        RVAL="$?"
        if [[ $RVAL -ne 0 ]];
        then
            echo "Something went wrong and this is unexpected!" >> /Users/steven/FuckOff.log
            exit 1
        fi
    done
}

# Check if app is running
# If so, kill it
# If not, then continue on
kill_once() {
    is_app_running
    IS_RUNNING="$?"
    if [[ ${IS_RUNNING} -eq 1 ]];
    then
        # If app is running, kill it!
        kill_app_pkill
        KILL_RESPONSE="$?"
        if [[ $KILL_RESPONSE -ne 0 && $USE_PID_FALLBACK -eq 1 ]];
        then
            # Try killing it harder!
            kill_app_pid
            KILL_RESPONSE="$?"
            if [[ $KILL_RESPONSE -ne 0 ]];
            then
                exit 1
            fi
        elif [[ $KILL_RESPONSE -eq 0 ]];
        then
            exit 1
        fi
        echo "Successfully killed ${APP_TO_KILL} which had PID ${APP_PID}" >> /Users/steven/FuckOff.log
        return 0
    fi
    echo "App ${APP_TO_KILL} is not currently running" >> /Users/steven/FuckOff.log
    return 0
}

usage() {
    cat << USAGE_EOF
Tell an application to fuck off!
Find it (by name) and kill it with fire

[USAGE]
    fuck_off_apple.sh [OPTIONS]

[OPTIONS]
    -h, --help
        Print this message
    -a, --application, --kill
        Application to fuck off (Default ${APP_TO_KILL})
    -f, --fire, --pid-fallback
        Use the process PID as a fallback (DEFAULT ${USE_PID_FALLBACK})
    -o, --once
        Tell app to fuck off and then exit (this is pgrep and pkill)

USAGE_EOF
}

# Print an error message telling the user the
# command and then print usage
# Push both to stderr
error_msg() {
    cat << ERR_EOF 1>&2
I'm sorry, we do not understand this command
    "${0} ${@}"

ERR_EOF
usage 1>&2
}

args() {
    while [[ $# -gt 0 ]];
    do
        case $1 in
            -h | --help)
                usage
                exit 0
                ;;
            -a | --application | --kill)
                shift
                APP_TO_KILL="$1"
                ;;
            -f | --fire | --pid-fallback)
                USE_PID_FALLBACK=1
                ;;
            -o | --once)
                EXIT_AFTER=1
                ;;
            *)
                error_msg "$@"
                exit 1
                ;;
        esac
        shift
    done
}

main() {
    date >> /Users/steven/FuckOff.log
    args "$@"
    if [[ $EXIT_AFTER -eq 1 ]];
    then
        kill_once
    else
        kill_loop
    fi
}

main "$@" || exit 1 
