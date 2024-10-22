#!/data/data/com.termux/files/usr/bin/env bash
############################################################
# Script to perform regular backups of files, but only on
# your home network.
# Useful if you want to backup photos or other things to
# a local NAS or something
#
# Requires:
#   rsync
#   having run: termux-setup-storage
#   dest must also have rsync
#
# If you're using tailscale you can replace `enforce_ssid`
# with `check_on_wifi` and make sure you use the appropriate
# $dest_dir
# vim users: :12,$s/enforce_ssid/check_on_wifi/g
#
# Suggested:
#   add to cron as a job (`crontab -e`)
#   Why not run every hour?
#   0 * * * * /path/to/update.sh &>> ${HOME%/}/.logs/backup_errors.log
#
# We could be smarter about the WiFi checking or check for
# new files, but it is fast to just run this every hour and
# then only upload if we're at home. Even if you took a lot
# of pictures that day you're likely not gonna take an hour
# to upload.
#
# Author: Steven Walton
# Contact: scripts@walton.mozmail.com
# License: MIT
############################################################

# Don't let the log file get bigger than this
declare MAX_LOG_SIZE="50K"
declare source_dir="${HOME%/}/storage/"
# Location of remote machine and directory
# e.g. foo:/path/to/backup/
declare dest_dir=
# Enter name of the SSID you're allowed to perform the backup on
declare allowed_ssid=
declare logfile="${HOME%/}/.logs/backup.log"

# Variable pairs that are in the format "Android" "remote machine"
# The Android's side is relative to $source_dir
# The remote machine side is relative to $dest_dir
declare -a backup_pairs=('pictures' 'Pictures' 
                         'dcim' 'Pictures/DCIM' 
                         'music' 'Music' 
                         'movies' 'Movies' 
                         'shared/Android/media/com.whatsapp/Whatsapp' 'Apps/WhatsApp' 
                         'shared/Slack' 'Apps/Slack')

# Single rsync with logs
# Edit rsync flags here if you want something different
# Using:
#   -a : archive
#   -z : compress
#   -h : human readable format
# Possible Wants:
#   -c : skip based on checksums (slower)
#   --remove-source-files : removes files (not dirs) from source after they have
#   been successfully uploaded
rsync_run() {
    enforce_ssid "${allowed_ssid}"
    write_log "\t${CYN}Backing up: ${1} -> ${2}"
    runerr=$(rsync -azh "${1}" "${2}")
    if [[ "$?" -ne 0 ]];
    then
        write_log "${RED}rsync failed in progress"
        write_log "${RED}${runerr}"
    fi
}

# Loop through the backup pairs and then rsync those dirs
rsync_all() {
    declare -i i=0
    while [[ $i -lt ${#backup_pairs[@]} ]]
    do
        rsync_run \
            "${source_dir%/}/${backup_pairs[${i}]}/" \
            "${dest_dir%/}/${backup_pairs[$(( $i+1 ))]}/"
	let i+=2
    done
}


main() {
    enforce_ssid "${allowed_ssid}"
    write_log "${GRN}Backup started"
    rsync_all
    write_log "${GRN}Backup finished"

    trim_log
}

source "${HOME%/}/scripts/common.sh"
main "$@" || error_out
