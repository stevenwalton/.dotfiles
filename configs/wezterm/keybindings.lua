-- ----------------------------------------------------------- 
-- User defined variables
-- Define keys and directions
-- Please define the movement keys in lower case.
--      Upper case will be used for moving panes
-- ----------------------------------------------------------- 
-- Vim keybindings
local left = 'h'
local right = 'l'
local down = 'j'
local up = 'k'
-- Panes 
local horizontal_split = '|'
local vertical_split = '-'
local full_screen_key = 'z'
-- ----------------------------------------------------------- 

-- local wezterm = require 'wezterm'
local module = {}


function module.make_pane_keybindings(wezterm, config)
    -- Leader is like my tmux leader (ctrl + s) but using apple's cmd. 
    -- I don't particularly like this but we'll see what happens
    config.leader = { 
        key = 's',
        mods = 'CMD',
        timeout_milliseconds = 1000,
    }
    -- Pane movement helper function
    local function move_pane(key, direction)
        return {
            key = key,
            mods = 'LEADER',
            action = wezterm.action.ActivatePaneDirection(direction),
        }
    end
    -- Adjust pane helper function
    local function adjust_pane(key, direction)
        return {
            key = key,
            mods = 'LEADER',
            action = wezterm.action.AdjustPaneSize { direction, 5 },
        }
    end
    -- Split pane helper function
    local function split_pane(key, direction)
        domain = 'CurrentPaneDomain'
        if direction == 'horizontal' 
        then
            action = wezterm.action.SplitHorizontal{domain=domain}
        elseif direction == 'vertical' 
        then
            action = wezterm.action.SplitVertical{domain=domain}
        else
            print('You need to choose "horizontal" or "vertical"')
        end
        return {
            key = key,
            mods = 'LEADER',
            action = action,
        }
    end
    -- Toggle pane to full screen
    local function full_screen(key)
        return {
            key = key,
            mods = 'LEADER',
            action = wezterm.action.TogglePaneZoomState,
        }
    end
    -- Define movements
    config.keys = {
        split_pane(horizontal_split, 'horizontal'),
        split_pane(vertical_split, 'vertical'),
        full_screen(full_screen_key),
        --
        move_pane(down, 'Down'),
        move_pane(up, 'Up'),
        move_pane(left, 'Left'),
        move_pane(right, 'Right'),
        adjust_pane(string.upper(left), 'Left'),
        adjust_pane(string.upper(down), 'Down'),
        adjust_pane(string.upper(up), 'Up'),
        adjust_pane(string.upper(right), 'Right'),
    }
    return config
end

function module.make_keybindings(wezterm, config)
    config = module.make_pane_keybindings(wezterm, config)
    return config
end

return module
