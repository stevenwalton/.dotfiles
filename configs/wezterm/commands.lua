-- ----------------------------------------------------------- 
-- User defined variables
-- ----------------------------------------------------------- 
local EDITOR = 'vim'
-- Key to load config in new tab
local config_key = ','
-- ----------------------------------------------------------- 
local wezterm = require 'wezterm'
local module = {}

-- Hotkey for loading config file in new tab
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

function module.load_commands(config)
    config = module.load_config_in_new_tab(config)
    return config
end

return module
