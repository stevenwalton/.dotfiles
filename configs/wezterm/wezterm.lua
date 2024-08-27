-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
local colorscheme = require 'colorscheme'
config = colorscheme.get_color_scheme(wezterm, config)

-- Main appearance finctionality 
local appearance = require 'appearance'
wezterm, config = appearance.make_appearance(wezterm, config)

-- Keybindings (panes)
local keybindings = require 'keybindings'
config = keybindings.make_keybindings(wezterm, config)

-- Fonts 
local fonts = require 'fonts'
config = fonts.make_fonts(config)

-- Custom commands
local commands = require 'commands'
config = commands.load_commands(config)

return config
