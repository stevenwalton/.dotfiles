#!/bin/bash
TIMEOUT=4000
ICON=/usr/share/endeavouros/EndeavourOS-icon.png

CheckOrphans() {
    pacman -Qdtq
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
        "Orphan Packages" \
        "${1}"
}

Main() {
    local msg=$(CheckOrphans)
    if [ -n "msg" ];
    then
        return
    fi
    DesktopNotification "${msg}"
    echo -e "\033[1;31mSystem has Orphan packages:\033[0m"
    echo "${msg}"
}
