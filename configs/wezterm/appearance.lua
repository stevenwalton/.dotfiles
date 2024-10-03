-- Required for user defined vars
local wezterm = require 'wezterm'
local helpers = require 'helpers'
-- ----------------------------------------------------------- 
-- User defined variables
-- There are more variables here than usual so pay close attention
-- ----------------------------------------------------------- 
-- Main
local opacity = 0.95
local background_blur = 10

-- powerline left arrow.
-- local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
-- Right tab bar gradient percentage
local gradient_delta = 0.25
-- Battery Options
local charge_icon = '🔌'
local discharge_icon = '⚡️'
local full_battery_icon =  '🔋'
local empty_battery_icon = '🪫'
local bat_unknown_icon = '⁉️'
-- -- Thresholds for displaying time to charge or till empty
-- -- -- While charging
-- -- -- -- If below this: display charging icon and time till full 
local near_full_thresh = 0.9 
-- -- -- While discharging
local mostly_charged_thresh = 0.8 -- Display full bat icon if above this %
-- -- -- -- If below this: display empty bat icon and time till empty
local near_empty_thresh = 0.4 

-- Right status bar
local deliminator = SOLID_LEFT_ARROW 
-- -- Time formats
local cal_date_icon = wezterm.nerdfonts.cod_calendar  
local time_date_icon = wezterm.nerdfonts.md_clock_outline

-- -- Hostname format >_ $HOSTNAME
local hostname_format = helpers.get_os_icon() .. ' ' ..  wezterm.hostname() 
    
-- Misc
local automatic_reload = true
local anti_alias_glyphs = true
-- ----------------------------------------------------------- 

local color_scheme = ''
local bg = ''
local fg = ''
local module = {}
wezterm.action.EmitEvent 'update-status'
local current_time
local current_date

function module.set_time()
    local current_datetime = wezterm.time.now()
    --current_time = current_datetime:format("%H:%M:%S")
    current_time = current_datetime:format("%H:%M")
    current_date = current_datetime:format("%a %b %-d")
    return current_time, current_date
end


function set_battery_status()
    local percent, _, _, _, till_full, till_dead, state = wezterm.battery_info()
    --local binfo_str = string.format('%0.f%%', percent * 100)
    local bat = ''
    local bicon = ''
    local time_till = ''
    local b = wezterm.battery_info()[1]

    -- Function to turn seconds into hrs and mins
    local function bat_time_calc(time_til)
        local time_remain = ''
        local hrs = math.floor(time_til / 3600)
        if hrs > 30
        then
            wezterm.action.EmitEvent 'update-status'
        end
        local mins = (time_til - (hrs * 3600)) / 60
        time_remain = string.format('%.0fhr %.0fmin', hrs, mins)
        -- time_remain = string.format('%.0fs', time_til)
        return time_remain
    end
    --
    bat = string.format('%.0f%%', b.state_of_charge * 100 ) .. ' ' 
    if b.state == 'Charging'
    then
        bicon =  charge_icon
        if b.state_of_charge < near_full_thresh
        then
            time_till = bat_time_calc(b.time_to_full)
        end
    elseif b.state == 'Discharging' 
    then
        if b.state_of_charge < near_empty_thresh
        then
            bicon = empty_battery_icon
            time_till = bat_time_calc(b.time_to_empty)
        elseif b.state_of_charge > mostly_charged_thresh
        then
            bicon =  full_battery_icon
        else
            bicon = discharge_icon
        end
    elseif b.state == 'Unknown'
    then
        bicon = bat_unknown_icon
    end
    
    return bat .. bicon .. time_till
end
-- ----------------------------------------------------------- 
-- User May want to modify this
-- ----------------------------------------------------------- 
function module.right_tab_segments(window)
    current_time, current_date = module.set_time()
    return {
        -- window:active_workspace(),
        cal_date_icon .. ' ' .. current_date,
        time_date_icon .. ' ' .. current_time,
        hostname_format,
        set_battery_status(),
    }
end
-- ----------------------------------------------------------- 

function module.make_general_window_config(config)
    -- Set a small opacity and blur to make 'softer'
    config.window_background_opacity = opacity
    config.macos_window_background_blur = background_blur
    -- config.window_decorations = "RESIZE"
    config.automatically_reload_config = automatic_reload
    local anti_alias_custom_block_glyphs = anti_alias_glyphs

    -- Be a madman and remove top bar for x - <>
    -- config.window_decorations = 'RESIZE'
    return config
end

function module.make_status_bar_right(wezterm, config)
    wezterm.on('update-status', function(window, _)
        local segments = module.right_tab_segments(window)
        -- Temporarily cache colors
        -- local color_scheme = window:effective_config().resolved_palette
        color_scheme = window:effective_config().resolved_palette
        bg = wezterm.color.parse(color_scheme.background)
        --local bg = color_scheme.background
        fg = color_scheme.foreground
        -- Let's make a gradient for our separate segments
        local gradient_to, gradient_from = bg
        --
        -- Let's get the is_dark function from color_scheme
        local colorscheme = require 'colorscheme'
        if colorscheme.is_dark(wezterm)
        then
            gradient_from = gradient_to:lighten(gradient_delta)
        else
            gradient_from = gradient_to:darken(gradient_delta)
        end

        local gradient = wezterm.color.gradient(
            {
                orientation = 'Horizontal',
                colors = { gradient_from, gradient_to },
            },
            -- Evenly distribute by number of segments
            #segments
        )

        local elements = {}
        for i, seg in ipairs(segments)
        do
            local is_first = i == 1
            if is_first
            then
                table.insert(elements,
                    { Background = { Color = 'none' } }
                )
            end
            table.insert(elements,
                { Foreground = { Color = gradient[i] } }
            )
            table.insert(elements,
                { Text = deliminator }
            )
            table.insert(elements,
                { Foreground = { Color = fg } }
            )
            table.insert(elements,
                { Background = { Color = gradient[i] } }
            )
            table.insert(elements,
                { Text = ' ' .. seg .. ' ' }
            )
        end

        window:set_right_status(wezterm.format(elements))
    end)

    return wezterm, config
end

function module.make_tab_bar(wezterm, config)
    -- Cache Colors
    -- local color_scheme = window:effective_config().resolved_palette
    -- local bg = wezterm.color.parse(color_scheme.background)
    -- --local bg = color_scheme.background
    -- local fg = color_scheme.foreground
    --
    local function tab_title(tab_info)
        local title = tab_info.tab_title
        if title and #title > 0
        then
            return title
        end
        return tab_info.active_pane.title
    end

    -- Returns to old type so we can do these nesting tabs
    config.use_fancy_tab_bar = false
    -- config.show_close_tab_button_in_tabs = false
    wezterm.on('format-tab-title',
               function(tab, tabs, panes, config, hover, max_width)
        local gradient_to, gradient_from = bg
        local colorscheme = require 'colorscheme'
        --if colorscheme.is_dark(wezterm)
        --then
        --    gradient_from = gradient_to:lighten(gradient_delta)
        --else
        --    gradient_from = gradient_to:darken(gradient_delta)
        --end
        --local gradient = wezterm.color.gradient(
        --    {
        --        orientation = 'Horizontal',
        --        colors = { gradient_from, gradient_to },
        --    },
        --    -- Evenly distribute by number of segments
        --    #segments
        --)

        local background = bg
        local foreground = fg
        local edge_background = bg
        local left_text = ' '
        if tab.is_active
        then
            background = bg
            foreground = fg
        elseif hover
        then
            background = fg --gradient[2]
            foreground = 'none'
            left_text = SOLID_RIGHT_ARROW .. ' ' 
        end
        local edge_foreground = background

        local title = tab_title(tab)

        title = wezterm.truncate_right(title, max_width - 2)

        return {
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = left_text },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = title .. ' ' },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_RIGHT_ARROW },
        }
    end)
    return wezterm, config
end

function module.make_tab_format(wezterm, config)
    return wezterm, config
end

function module.make_notifications(config)
    config.audible_bell = "Disabled"
    -- Visual bell makes the screen flash briefly with a ease in and out
    config.visual_bell = {
      fade_in_function = 'EaseIn',
      fade_in_duration_ms = 150,
      fade_out_function = 'EaseOut',
      fade_out_duration_ms = 150,
    }
    config.colors = {
      visual_bell = '#202020',
    }
    return config
end

function module.make_appearance(wezterm, config)
    config = module.make_general_window_config(config)
    config = module.make_notifications(config)
    wezterm, config = module.make_status_bar_right(wezterm, config)
    wezterm, config = module.make_tab_format(wezterm, config)
    --wezterm, config = module.make_tab_bar(wezterm, config)
    return wezterm, config
end

return module
