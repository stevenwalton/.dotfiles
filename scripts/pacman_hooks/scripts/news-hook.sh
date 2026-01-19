#!/bin/bash

MAIL_USERS=(root steven)
# Toast timeout in ms
TIMEOUT=4000
ICON=/usr/share/endeavouros/EndeavourOS-icon.png

# Checks news and writes to file descriptor 3
CheckNews() {
    # Downgrade privileges
    sudo -u "$SUDO_USER" /usr/bin/yay -Pw 2>&1 /dev/null
    # Use this for debugging 
    #echo "This is fake news"
}

# Send mail to a specific user
SendMail() {
    echo -e "${2}" | mail -s "AUR News" "${1}" 
}

DesktopNotification() {
    # Get user from seat0 graphical session
    local session=$(loginctl list-sessions | awk '/seat0/ {print $1; exit}')
    # Return if no one is looking at a screen
    if [ -z "$session" ]; then
        return
    fi
    # Should grab your name and 1000
    local uid=$(loginctl show-session "$session" -p User --value)
    local user=$(id -un "$uid")
    
    # Since we're root let's login as the user and write the message
    sudo -u "$user" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus \
    /usr/bin/notify-send \
        -t $TIMEOUT \
        -i "$ICON" \
        "AUR News" \
        "${1}"
}

Main() {
    # Debug like this
    #DesktopNotification "This is a test"
    #SendMail steven "This is a test"

    echo -e "\033[1;31mRunning Pacman Pretransaction Hooks\033[0m"
    echo -e "\033[1;33mChecking AUR News...\033[0m"
    #CheckNews
    local news=$(CheckNews)
    # Return if there's no news
    if [ -z "news" ];
    then
        echo -e "\033[1;31mThere is no AUR News\033[0m"
        return 0
    fi
    echo -e "\033[1;31mHere is the news\033[0m"
    echo -e "\033[1;33m${news}\033[0m"
    echo -e "\033[0m"
    for user in "${MAIL_USERS[@]}";
    do
    	echo "Sending mail to user ${user}"
        SendMail "${user}" "${news}"
    done
    DesktopNotification "${news}"
}

Main || exit 1
