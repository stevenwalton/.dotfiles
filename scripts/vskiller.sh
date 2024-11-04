#!/usr/bin/env bash
# Author: Steven Walton
# Contact: scripts@walton.mozmailcom
#
# Script to kill hanging or long term VS Code sessions on servers
# They waste a lot of resources so fucking kick them
# This is meant to be a guideline and don't expect to work right away
#
# Btw, use /usr/bin/env {bash,zsh,python,pearl,...} when writing user scripts.
# This will load the user's environment.
#SESSION_LIFETIME=$((1*24*60*60))
#                    | |  |  |___ Seconds
#                    | |  |______ Minutes
#                    | |_________ Hours
#                    |___________ Days
# 5 days for using last --since
SESSION_LIFETIME=3

########################################
# Kill VS Code sessions if they've been
# alive longer than SESSION_LIFETIME
# This is more hacky and quick for an
# example. You should really check user
# history and create a database. Then 
# when users issue command update
# I think you should use inotifywait?
# https://man7.org/linux/man-pages/man1/inotifywait.1.html
# Could also use loginctl? 
########################################
VSCode_killer () {
    # Actual users that have been on machine in last N days
    current_users=$(last --since "-${SESSION_LIFETIME}days" | head -n -2 | tr -s "\t" | tr -s " " | cut -d " " -f1 | sort | uniq)
    #                               |                           |               |          |              |            |     |____ Unique users
    #                               |                           |               |          |              |            |__________ Have to sort before uniq
    #                               |                           |               |          |              |_______________________ Space separated first field
    #                               |                           |               |          |______________________________________ Multiple spaces to one space
    #                               |                           |               |_________________________________________________ Multiple tabs to one tab
    #                               |                           |_________________________________________________________________ Remove last 2 lines
    #                               |_____________________________________________________________________________________________ Users logged in since N days
    # First sed removes USER, second removes the first line blank space
    all_users=$(w | cut -d " " -f1 | sed "/USER/d" | sort | uniq | sed 1,1d
    # Disjoint set
    lazy_users=$(comm -23 <(echo $allusers) <(echo $current_users))
    IFS=$'\n'
    for lazy_u in $lazy_users;
    do
        lazy_id=$(id -u $lazy_u)
        # Figure out how to kill vs code with these UIDs.
        # using pgrep and pkill is probably the easiest?
    done
    unset IFS
}

VSCode_killer || exit 1

# run `crontab -e` as root and then add this
# Special characters
# # *     Every possible value
# # ?     No specific value
# # -     Range
# # ,     List
# # /     Increments (e.g. 1/3 in dom == every 3 days)
# # L     (dom and dow) last value (last day of week/month)
# # W     Weekday nearest value
# # #     Nth day (e.g. 6/3 in dow == every 3rd friday)
# # e.g. 0 15 10 ? * 6#3 => Every 3rd Friday at 10:15 am
# # |---------------------- Minute (0-59)
# # | |-------------------- Hour (0-23)
# # | |  |----------------- Day of Month (1-31)
# # | |  |   |------------- Month (1-12)
# # | |  |   |   |--------- Day of Week (0-6: Sun - Sat; 0==7==Su)
# # | |  |   |   |     |--- Command to run
# # m h dom mon dow command
#   0 3  *   *   *  bash vskiller.sh
