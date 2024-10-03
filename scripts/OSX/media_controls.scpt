on is_running(appName)
    tell application "System Events" to (name of process) contains appName
end is_running
-- Override media keys to be spotify instead of Apple Music

-- Play button
on press_play(appName)
    if is_running(appName)
        tell application appName to playpause
    else
        tell application appName to activate
    end if
end press_play

on playpause_only(appName)
    if is_running(appName)
        tell application appName to playpause
    end if
end playpause_only

-- Next
on press_next(appName)
    if is_running(appName)
        tell application appName to next track
    end if
end press_next

on press_prev(appName)
    if is_running(appName)
        tell application appName to previous track
    end if
end press_prev
