-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10
-- config.window_decorations = "RESIZE"
config.audible_bell="Disabled"
config.automatically_reload_config = true
local anti_alias_custom_block_glyphs = true

wezterm.on('update-status', function(window)
    -- get utf8 char for powerline <
    local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    local color_scheme = window:effective_config().resolved_palette
    local bg = color_scheme.background
    local fg = color_scheme.foreground

    window:set_right_status(wezterm.format({
                -- arrow!
                { Background = { Color = 'none' } },
                { Foreground = { Color = bg } },
                { Text = SOLID_LEFT_ARROW },
                -- Text
                { Background = { Color = bg } },
                { Foreground = { Color = g } },
                { Text = ' ' .. wezterm.hostname() .. ' ' },
    }))
end)

-- Pane splitting
config.leader = { key = 's', mods = 'CMD', timeout_milliseconds = 1000 }
local function move_pane(key, direction)
    return {
        key = key,
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection(direction),
    }
end
local function adjust_pane(key, direction)
    return {
        key = key,
        mods = 'LEADER',
        action = wezterm.action.AdjustPaneSize { direction, 5 },
    }
end
config.keys = {
    {
        key = '|',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },
    {
        key = '-',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
    },
    move_pane('j', 'Down'),
    move_pane('k', 'Up'),
    move_pane('h', 'Left'),
    move_pane('l', 'Right'),
    adjust_pane('H', 'Left'),
    adjust_pane('J', 'Down'),
    adjust_pane('K', 'Up'),
    adjust_pane('L', 'Right'),
}



return config
