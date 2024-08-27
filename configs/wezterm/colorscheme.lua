-- ----------------------------------------------------------- 
-- User defined variables
-- Define light and dark color scheme here
-- ----------------------------------------------------------- 
local dark_color_scheme = "Tokyo Night (Gogh)"
local light_color_scheme = "Tokyo Night Day"
-- ----------------------------------------------------------- 

-- local wezterm = require 'wezterm'
-- Define lua table to hold our modules functions
local module = {}


-- Helper function to determine if we.re in dark mode
function module.is_dark(wezterm)
    if wezterm.gui then
        return wezterm.gui.get_appearance():find("Dark")
    end
    return true
end

function module.get_color_scheme(wezterm, config)
    if module.is_dark(wezterm) then
        config.color_scheme = dark_color_scheme
    else
        config.color_scheme = light_color_scheme
    end
    return config
end

return module
