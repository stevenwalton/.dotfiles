-- ----------------------------------------------------------- 
-- User defined variables
-- You can use `wezterm ls-fonts` to see available fonts
--      There is a `--text` option if you want to test glyphs
-- ----------------------------------------------------------- 
-- Main
local main_font = 'Fira Code'
local font_size = 15.0
local font_weight = 'Normal'
local font_atts = {
    italic = false,
    weight = 'Regular',
    stretch = 'Normal',
    style = 'Normal',
}
-- Tab bar
local tab_bar_font = 'Fira Code'
local tab_bar_font_size = 11
local tab_bar_font_attrs = {
    family = 'Fira Code',
    weight = 'Bold',
}
-- ----------------------------------------------------------- 
local wezterm = require 'wezterm'
local module = {}

function module.make_tab_bar_fonts(config)
    config.window_frame = {
        font = wezterm.font( tab_bar_font_attrs ),
        font_size = tab_bar_font_size,
    }
    return config
end

function module.make_main_fonts(config)
    config.font = wezterm.font(
        main_font,
        font_attrs
    )
    return config
end

function module.make_fonts(config)
    config = module.make_tab_bar_fonts(config)
    config = module.make_main_fonts(config)
    return config
end

return module
