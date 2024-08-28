-- ----------------------------------------------------------- 
-- User defined variables
-- ----------------------------------------------------------- 
local EDITOR = 'vim'
-- Wezterm config hotkeying
local config_key = ','
-- Research Notes hotkeying
local notes_key = 'n'
local research_notes_path = '${HOME}/Documents/Research/ResearchNotes/'
local research_notes_file = 'README.md'
-- ----------------------------------------------------------- 
local wezterm = require 'wezterm'
local module = {}

-- Hotkey to open wezterm config
function module.load_config_in_new_tab(config)
    table.insert(config.keys,
        {
            key = config_key,
            mods = 'SUPER',
            action = wezterm.action.SpawnCommandInNewTab {
                cwd = wezterm.home_dir,
                args = { EDITOR, wezterm.config_file },
            },
        }
    )
    return config
end

-- Hotkey to open research notes
function module.load_notes(config)
    table.insert(config.keys,
        {
            key = notes_key,
            mods = 'SUPER',
            action = wezterm.action.SpawnCommandInNewTab {
                cwd = research_notes_path,
                args = { EDITOR, research_notes_file },
            },
        }
        )
    return config
end

function module.load_commands(config)
    config = module.load_config_in_new_tab(config)
    config = module.load_notes(config)
    return config
end

return module
