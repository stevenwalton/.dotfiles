#!/data/data/com.termux/files/usr/bin/env bash
############################################################
# Simple script to update and upgrade termux but to only
# do so when on wifi. 
# Will produce a log file that will let you know what was 
# updated.
#
# Suggested:
#   add to a cron job (`crontab -e`)
#
# Author: Steven Walton
# Contact: scripts@walton.mozmail.com
# License: MIT
############################################################

declare logfile="${HOME%/}/.logs/updateUpgrade.log"
declare MAX_LOG_SIZE="50K"

main() {
    check_on_wifi
    write_log "${GRN}Update started"
    declare update_msg=$(pkg update 2> /dev/null)
    if [[ "$?" -ne 0 ]];
    then
        write_log "${RED}update failed"
        write_log "${RED}update_msg"
        exit 1
    fi
    write_log "${GRN}Update successful"
    declare to_upgrade="$(apt list --upgradable 2> /dev/null)"
    if [[ "${to_upgrade}" == "Listing..." ]];
    then
        write_log "${CYN}Nothing To upgrade"
        exit 0
    fi
    write_log "${to_upgrade}"

    check_on_wifi
    declare upgrade_msg=$(yes | pkg upgrade 2> /dev/null)
    if [[ "$?" -ne 0 ]];
    then
        write_log "${RED}update failed"
        write_log "{RED}${upgrade_msg}"
        exit 1
    fi
    write_log "${GRN}Update and upgrade finished"
    trim_log
}

source "${HOME%/}/scripts/common.sh"
main || error_out
