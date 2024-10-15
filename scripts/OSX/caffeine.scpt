#!/usr/bin/osascript

tell application "Caffeine"
    if active then
        turn off
    else
        turn on
    end if
end tell

