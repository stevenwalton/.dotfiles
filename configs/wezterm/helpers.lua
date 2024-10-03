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

function module.get_os_icon()
    -- Symbols can be found at https://www.nerdfonts.com/cheat-sheet
    if module.is_osx()
    then
        return ''
    elseif module.is_linux()
    then
        return ''
    else
        -- >_
        return nerdfonts.md_console_line
    end
end


return module
