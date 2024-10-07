-- ----------------------------------------------------------- 
-- Helper functions that may or may not be used by other 
-- configuration files
-- ----------------------------------------------------------- 
local wezterm = require 'wezterm'

local module = {}

function module.is_linux()
    return wezterm.target_triple:find("linux") ~= nil
end

function module.is_osx()
    return wezterm.target_triple:find("darwin") ~= nil
end

function module.get_os()
    if module.is_linux()
    then 
        return "linux"
    elseif module.is_osx()
    then
        return "darwin"
    else
        return "unknown"
    end
end

function module.get_distro_icon()
    _, distro, _ = wezterm.run_child_process('lsb_release', '-i')
    distro_dict = { Endeavour="",
                    Arch="󰣇",
                    Ubuntu="",
                    Raspbian="",
                    Manjaro="󱘊",
                    Pop=" ",
    }
    for k,v in pairs(distro_dict)
    do
        if distro:gsub("\n","") == k
        then
            return v
        end
    end
    -- Catchall
    return ''
end

function module.get_os_icon()
    -- Symbols can be found at https://www.nerdfonts.com/cheat-sheet
    if module.is_osx()
    then
        return ''
    elseif module.is_linux()
    then
        return module.get_distro_icon()
    else
        -- >_
        return nerdfonts.md_console_line
    end
end

function module.is_ssh_session()
    args = { "/usr/bin/env", "bash", "-c", "ps -o comm= $PPID" }
    _, rval, _ = wezterm.run_child_process( args )
    if rval:find('sshd') ~= nil
    then
        return true
    end
    return false
end

function module.make_ssh_icon()
    return ' '
    -- if module.is_ssh_session()
    -- then
    --     return ' 󰢩 '
    -- end
    -- return ' '
end


return module
