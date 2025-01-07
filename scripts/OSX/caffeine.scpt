#!/usr/bin/osascript

########################################
# Small script to toggle Caffeine 
# (keep computer awake)
# 
# Requires Caffeine
# https://www.caffeine-app.net/
# https://github.com/IntelliScape/caffeine/
# 
# Author: Steven Walton
########################################

tell application "Caffeine"
    if active then
        turn off
    else
        turn on
    end if
end tell

