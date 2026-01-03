#!/bin/bash

MAIL_USERS=(root steven)
# Toast timeout in ms
TIMEOUT=4000
ICON=/usr/share/endeavouros/EndeavourOS-icon.png

# Checks news and writes to file descriptor 3
CheckNews() {
    /usr/bin/yay -Pw 2>&1
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

    local news=$(CheckNews)
    # Return if there's no news
    if [ -n "news" ];
    then
        return
    fi
    for user in "${MAIL_USERS}";
    do
        SendMail "${user}" "${news}"
    done
    DesktopNotification "${news}"
}

Main || exit 1
