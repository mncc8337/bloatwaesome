local config    = require("config")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local widgets    = require("widgets")
local ui         = require("ui.ui_elements")
local rubato     = require("modules.rubato")

local time = require("ui.timeweather.time")

--[[ BASE ]]--
--                         title  time      spacing
local timeweather_height = 30   + 22*7+68 + 8*3
local timeweather = wibox {
    ontop = true,
    visible = false,
    type = "dock",
    width = beautiful.timeweather_width,
    height = timeweather_height,
    x = (awful.screen.focused().geometry.width - beautiful.timeweather_width)/2,
    bg = beautiful.panel_bg,
    screen = awful.screen.focused(),
    shape = rounded_rect(beautiful.popup_roundness),
    -- border_width = beautiful.border_width,
    -- border_color = beautiful.panel_border,
}

local prev_button = ui.create_button_fg("", beautiful.calendar_button_bg, beautiful.calendar_button_fg, function(_) end, 32, 23, 16)
local next_button = ui.create_button_fg("", beautiful.calendar_button_bg, beautiful.calendar_button_fg, function(_) end, 32, 23, 16)

local tabs = {
    wibox.widget {
        layout = wibox.layout.fixed.vertical,
        ui.create_dashboard_panel(wibox.widget {
            layout = wibox.layout.align.horizontal,
            prev_button,
            wibox.widget {
                widget = wibox.widget.textbox(),
                markup = "<b>Calendar</b>",
                align = "center",
                valign = "center",
                forced_height = 30,
            },
            next_button,
        }),
        time
    },
    wibox.widget {
        layout = wibox.layout.fixed.vertical,
        ui.create_dashboard_panel(wibox.widget {
            layout = wibox.layout.align.horizontal,
            prev_button,
            wibox.widget {
                widget = wibox.widget.textbox(),
                markup = "<b>Weather</b>",
                align = "center",
                valign = "center",
                forced_height = 30,
            },
            next_button,
        })
    },
}

local scroller = ui.h_scrollable(tabs, beautiful.timeweather_width, timeweather_height - 4 * 2, {top = 0, bottom = 0, left = 0, right = 0})
prev_button:buttons(awful.button({}, 1, function() scroller.scroll(-1) end))
next_button:buttons(awful.button({}, 1, function() scroller.scroll( 1) end))

timeweather:setup {
    scroller,
    widget = wibox.container.margin,
    margins = 4,
}

local timeweather_opened = false

local timeweather_timed = rubato.timed {
    duration = 0.3,
    intro = 0.1,
    override_dt = true,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        timeweather.y = pos
        if pos == -timeweather.height and not timeweather_opened then
            timeweather.visible = false
        end
    end
}

function timeweather_visible()
    return timeweather.visible
end
local function hide_timeweather()
    timeweather_opened = false
    timeweather_timed.target = -timeweather.height
end
local function show_timeweather()
    timeweather.screen = awful.screen.focused()
    local h = timeweather.screen.geometry.height
    
    timeweather.visible = true
    
    timeweather_opened = true
    timeweather_timed.target = config.bar_size + (config.floating_bar and config.screen_spacing or 0) + config.screen_spacing
end
local function toggle_timeweather()
    if not timeweather_opened then
        awesome.emit_signal("timeweather::show")
    else
        awesome.emit_signal("timeweather::hide")
    end
end

-- hide on click
local function hide_timeweather_on_click()
    if timeweather_visible() and not prompt_running then
        awesome.emit_signal("timeweather::hide")
    end
end
awful.mouse.append_global_mousebinding(awful.button({}, 1, hide_timeweather_on_click))
client.connect_signal("button::press", hide_timeweather_on_click)

awesome.connect_signal("timeweather::show", show_timeweather)
awesome.connect_signal("timeweather::hide", hide_timeweather)
awesome.connect_signal("timeweather::toggle", toggle_timeweather)