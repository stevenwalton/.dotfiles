#!/usr/bin/env bash
# This is a useful template to use when you need to install something from
# source and it is located on GitHub.
# We'll assume that there are releases, as that's the potentially hard part
# It also works as a good general purpose template/reference
#
# While I don't exactly follow Google's shell guide I think it is mostly good
# https://google.github.io/styleguide/shellguide.html
################################################################################
# <Program Name>
# <Description>
#
# License:
# Author:
# Contact:
################################################################################
VERSION=x.x.x   # Version of __YOUR__ program
LOGFILE=/tmp/my_script.log
FOO="${FOO:-"I'm a default value"}"
declare -i VERBOSE="${$VERBOSE:2}"

# A read only log level array
# FATAL, CRITICAL, and SUCCESS are given for expansion on the messages you can
# give users.
declare -Ar DEBUG_LEVEL=(
    [FATAL]="1"
    [CRITICAL]="1"
    [ERROR]="1"
    [WARN]="2"
    [INFO]="3"
    [DEBUG]="4"
    [SUCCESS]="4"
)
# Some color codes for messages
declare -Ar COLOR=(
    [FATAL]="\e[7;31m"
    [CRITICAL]="\e[4;31m"
    [ERROR]="\e[1;31m"
    [WARN]="\e[1;33m"
    [INFO]="\e[1;36m"
    [DEBUG]="\e[1;35m"
    [SUCCESS]="\e[1;32m"
    [NORMAL]="\e[0m"
)
# Good here to define your exit codes
# These are some common error codes but you can define them how you want
# Codes should be in [0,255]. 
# https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html
# 1 is a generic error
# 2 is an improper usage of command
declare -Ar EXIT_CODES=(
    [SUCCESS]="0"
    [ERROR]="1"
    [IMPROPER]="2"
)
# Hack to get log level name based on verbosity
declare -r LOG_LEVEL=$(IFS=" "; declare -a LL=( $( echo "${!DEBUG_LEVEL[@]}" ) ); echo "${LL[$VERBOSE]}")

# Make a link to an official repo
OFFICIAL_REPO="https://github.com/foo/bar"
# Default to the official URL but let users override
DL_URL="${DL_URL:-${OFFICIAL_REPO}}"


# Find the latest version number
find_latest_version() {
    APP_VERSION="$(curl -Ls -o /dev/null -w %{url_effective} "${DL_URL%/}/releases/latest/" | rev | cut -d "/" -f1 | rev)"
    echo $APP_VERSION
}
APP_VERSION="${APP_VERSION:-$(find_latest_version)}"
PACKAGE_DL_URL="${PACKAGE_DL_URL:-${DL_URL%/}/releases/download/${APP_VERSION}}"
# Array to hold the possible extensions we'll look for.
# We just need to modify this line
declare -a EXTENSIONS=("tar.gz" "zip")

################################################################################
# These are variables we will fill in later
################################################################################
declare regex # We'll use to parse
declare -a package_list # array of possible packages
declare package # Dummy for our desired package

# Now we'll create a regex that will parse our HTML that we'll grab from curl
# This will only return packages if they have the correct extension
# This way we can get the download link
make_regex() {
    IFS='|' # We want the extensions to be printed as "ext1|...|extn" for regex
    regex="(.*${PACKAGE_DL_URL}.*>)(.*($(echo "${EXTENSIONS[*]}")))(</a>.*$)"
    unset IFS
}

# It is best to modify the regex and we can parse much more easily
# This returns the __names__ of packages on the release page
get_package_list() {
    # Git Release URLs are in the form: https://github.com/foo/bar/releases/1.2.3
    #   So we remove the "download"
    package_list=( $(curl -s "${PACKAGE_DL_URL//download\///}" | grep -E "${regex}" | sed -E "s@${regex}@\2@p" | uniq) )
}

# Parse the packages for a term
# This replaces $package_list but you can do this in many ways
from_package_list() {
    IFS=$'\n'
    package_list=$(echo "${package_list[*]}" | grep "$1") 
    unset IFS
}

download_package() {
    curl -SsJLO --no-clober "${PACKAGE_DL_URL%/}/${package}"
    #     |||||      |_____ Avoids overwriting exiting files, appends dot and number
    #     |||||____________ (--remote-name): Write to local file named like remote file 
    #     ||||_____________ (--location): If server reports another location it'll redirect
    #     |||______________ (--remote-header-name): use server's filename (be careful with Windows!!!)
    #     ||_______________ (--silent): Be quiet. Great for scripts
    #     |________________ (--show-error): If fails, show error. Even when using silent
    # Also helpful
    # --output-dir: writes to a different directory
    # -Z / --parallel: Allows concurrent downloads
    # -# / --progress-bar: display a progress bar
    # --remove-on-error: if error, delete file instead of saving
    # -R / --remote-time: Attempt to preserve remote timestamp
    # --retry N: If error, will attempt to retry N times
    # --retry-delay S: delays S seconds before retrying
    # --ssl-reqd: require SSL/TLS connection
    # --tcp-fastopen: If server connected with before we can open faster
    # -A / --user-agent: Pretends to be a user agent. See
    #   https://explore.whatismybrowser.com/useragents/explore/
    #   # Safari 17
    #   Mozilla/5.0 (Macintosh; Intel Mac OS X 10) AppleWebKit/618.9 (KHTML, like Gecko) Version/17.0.20 Safari/618.9
}

usage() {
    cat << EOF
<
    <program name> (version: ${VERSION})
    ...short description...
    Place a shirt descripiton here with what the program does.
    Remember this follows indenting exactly as you provide.
    Do not cross 80 char width!!!!!
>

[USAGE] 
    <program> [OPTION...] 

[OPTIONS]
    -h, --help
        Print this message

    -o, --other-option
        Short description of option

    -a, --option-with-arg=ARGUMENT
        Short description of option and allowed arguments 
        (default: ARG_OPT=${ARG_OPT})

    ...
EOF
}

# Parse the arguments and assign appropriate variables
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h | --help)
                usage
                exit 0
                ;;
            --log-level {ERROR,WARN,INFO,DEBUG}
                Specify verbosity by keyword (DEFAULT: ${LOG_LEVEL})
            -o | --other-option)
                FOO="bar"
                ;;
            -a | --option-with-arg)
                shift # Move to next argument
                # Double quotes evaluates, so allows vars and $(command)
                # Single quotes is verbatim, so prevents users from passing vars
                ARG_OPT="$1" 
                ;;
            *) # Catch all
                ;;
        esac
        shift # Moves $1 -> $2
    done
}

# Let's run a command and capture its output
# Pass in your command to this ($1)
# This is generic and more illustrative. Probably won't find it very useful by
# copy pasting.
run_command() {
    response=$( "$1" 2>&1 )
    if [[ "$?" -ne 0 ]];
    then
        if [[ "$VERBOSE" -ge "${DEBUG_LEVEL[ERROR]}" ]];
        then
            command_response "ERROR" "$response" && exit "${EXIT_CODES[ERROR]}"
        fi
    elif [[ "$VERBOSE" -ge "${DEBUG_LEVEL[INFO]}" ]];
    then
        command_response "INFO" "$response"
    fi
}

# Pass in the error type. (This is why we used the associate array)
# We'll print the output to a logfile with a timestamp.
# We'll add a color and a [LOGLEVEL] to make this easy to grep.
command_response() {
    echo -e "${COLOR[$1][$1]: $(date + '%D %T %Z'): ${COLOR[NORMAL]} $2}" >> $LOGFILE
}


main "$@" || exit 1
#     |______ Anything passed to command. So be careful
