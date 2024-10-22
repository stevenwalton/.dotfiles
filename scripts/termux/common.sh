#!/data/data/com.termux/files/usr/bin/env bash
############################################################
# This is a helper script for other scripts written for 
# termux (https://termux.dev/en/)
# The bottom (likely last 2 lines) of your script should 
# look something like this
# ```bash
# source path/to/common.sh
# main "$@" || error_out
# ```
# Notice that `error_out` is from this file
#
# Contains things making log messages, checking wifi
# conditions, and other things
#
# Author: Steven Walton
# Contact: scripts@walton.mozmail.com
# License: MIT
############################################################

declare logfile="${logfile:-${HOME%/}/.logs/generic_log.log}"

# Colors that can be used by a short name
declare GRN='\e[1;32m'
declare RED='\e[1;31m'
declare YLW='\e[1;33m'
declare CYN='\e[1;36m'

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
    #echo -e "[$( date +'%c' )] : ${1}\e[0m" >> $logfile
    echo -e "[$( date +'%c' )] : ${1}\e[0m" | tee -a $logfile
}

# For scripts where you only want to run them if you're on a specific SSID
# Useful for running backups to machines only on a local network
# e.g.
# ```bash
# enforce_ssid "MyHomeNetworkName"
# ```
enforce_ssid() {
    declare current_ssid=$( termux-wifi-connectioninfo | jq -r ".ssid" )
    if [[ "$current_ssid" != "$1" ]]
    then
        write_log "${YLW}Not connected to home network: on ${current_ssid} not ${allowed_ssid}"
        exit 1
    fi
}

# Just makes sure that we're on WiFi.
# Maybe you don't care what network you're on, but just that you're on WiFi
# e.g.
# ```bash
# check_on_wifi
# ```
check_on_wifi() {
    declare wifi_status=$( termux-wifi-connectioninfo )
    if [[ "$(echo "${wifi_status}" | jq -r ".bssid")" == "null"
        || "$(echo "${wifi_status}" | jq -r ".frequency_mhz")" -eq "-1"
        || "$(echo "${wifi_status}" | jq -r ".network_id")" -eq "-1"
        || "$(echo "${wifi_status}" | jq -r ".supplicant_state")" == "UNINITIALIZED"
        ]];
    then
        write_log "${RED}No WiFi Connection"
        write_log "$(echo "${wifi_status}" | jq)"
        exit 1
    fi
    declare current_ssid="$(echo "${wifi_status}" | jq -r ".ssid")"
    write_log "${YLW}On WiFi\tSSID: ${current_ssid}"
}


# Let's not let our logfiles explode
# Requires:
#   $MAX_LOG_SIZE
#
# Must define the maximum size you want
# e.g.
# ```bash
# declare MAX_LOG_SIZE=1M
# ...
# main() {
#   ...
#   trim_log
# }
# source path/to/common.sh
# main "$@" || error_out
# ```
trim_log() {
    EXTN="${logfile##*.}"
    #echo "EXTN IS ${EXTN}"
    tmp_logfile="${logfile%%.${EXTN}}_tmp.${EXTN}"
    #echo "Main logfile is ${logfile} and tmp is ${tmp_logfile}"
    tail -c $MAX_LOG_SIZE "${logfile}" > "${tmp_logfile}"
    mv "${tmp_logfile}" "${logfile}"
}

# Writes `$NAME_OF_SCRIPT failed` to the log and exits with status 1
error_out() {
    write_log "${RED}${0##*/} failed"
    exit 1
}
