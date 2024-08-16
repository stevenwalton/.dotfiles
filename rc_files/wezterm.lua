-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "Tokyo Night"
-- config.window_decorations = "RESIZE"
config.audible_bell="Disabled"
config.automatically_reload_config = true
local anti_alias_custom_block_glyphs = true


return config
