# Wezterm Configurations
This folder holds configurations for my wezterm interface.
Try to make [wezterm.lua](wezterm.lua) sparse and a loader for other configs.
The easiest way I know of how to do this is to have distinct files that handle
different processes.
The files should use this template
```lua
-- ----------------------------------------------------------- 
-- Description of file and user defined variables
-- ----------------------------------------------------------- 
local user_defined_variable_1 = "foo"
local user_defined_variable_2 = "bar"
-- ----------------------------------------------------------- 
-- This may or may not be needed
-- local wezterm = require 'wezterm'
-- In some cases you should pass the wezterm variable into the function!
local module = {}

function module.make_sub_attribute(config)
    ...
    return config
end

function module.make_other_sub_attr_1(wezterm, config)
    ...
    return config
end

function module.make_other_sub_attr_2(wezterm, config)
    ...
    return wezterm, config
end

function module.make_attributes(wezterm, config)
    config = module.make_sub_attribute(config)
    config = module.make_other_sub_attr_1(wezterm, config)
    wezterm, config = module.make_other_sub_attr_2(wezterm, config)
    ...
    return wezterm, config
end

return module
```
so that the main wezterm file can then just
```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Import an attribute
local myattribute = require 'myattribute'
wezterm, config = myattribute.make_attributes(wezterm, config)
...
```
All files can be placed in `${HOME%/}/.config/wezterm` which should be part of `$XDG_CONFIG_HOME`.
Name of files should be autological.

# Organization
```bash
| $XDG_CONFIG_HOME/wezterm
| |- wezterm.lua
| |- colorscheme.lua
| |- appearance.lua
| |- keybindings.lua
| |- fonts.lua
```
- [wezterm.lua](wezterm.lua): main wez configuration file. Should be about
importing other files and contain comments
- [colorscheme.lua](colorscheme.lua): sets the colorscheme. Two userdefined
variables at the top that define a light and dark color scheme
- [appearance.lua](appearance.lua): File contains general appearance, such as
how tabs look and other such things. (May be broken up in the future)
- [keybindings.lua](keybindings.lua): Contains keybinding functions. Including
how to split panes and such
- [fonts.lua](fonts.lua): Fonts

# Resources
- [Main Docs](https://wezfurlong.org/wezterm)
- [Alex Plescan's Blogpost](https://alexplescan.com/posts/2024/08/10/wezterm/)
