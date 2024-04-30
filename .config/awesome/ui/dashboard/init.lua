-- signals
--[[
    dashboard::show
    dashboard::hide
    dashboard::toggle
]]--

local config    = require("config")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local ui         = require("ui.ui_elements")
local rubato     = require("modules.rubato")


--[[ BASE ]]--
--                       title   profile-panel  power-menu  music-player  volume  arcchart            spacing
local dashboard_height = 30    + 137          + 79        + 144         + 50    + ui.arc_size + 46  + 8 * 7
local dashboard = wibox {
    ontop = true,
    visible = false,
    type = "dock",
    width = beautiful.dashboard_width,
    height = dashboard_height,
    y = config.bar_size,
    bg = beautiful.panel_bg,
    screen = awful.screen.focused(),
    shape = rounded_rect(beautiful.popup_roundness),
    -- border_width = beautiful.border_width,
    -- border_color = beautiful.panel_border,
}

local prev_button = ui.create_button_fg("", beautiful.calendar_button_bg, beautiful.calendar_button_fg, function(_) end, 32, 23, 16)
local next_button = ui.create_button_fg("", beautiful.calendar_button_bg, beautiful.calendar_button_fg, function(_) end, 32, 23, 16)

local control_center = require("ui.dashboard.control_center")
local notifys_center = require("ui.dashboard.notification_center")
notifys_center.forced_height = dashboard_height - 8 * 2 - 30

local tabs = {
    wibox.widget {
        layout = wibox.layout.fixed.vertical,
        ui.create_dashboard_panel(wibox.widget {
            layout = wibox.layout.align.horizontal,
            prev_button,
            wibox.widget {
                widget = wibox.widget.textbox(),
                markup = "<b>Controls</b>",
                align = "center",
                valign = "center",
                forced_height = 30,
            },
            next_button,
        }),
        control_center,
    },
    wibox.widget {
        layout = wibox.layout.fixed.vertical,
        ui.create_dashboard_panel(wibox.widget {
            layout = wibox.layout.align.horizontal,
            prev_button,
            wibox.widget {
                widget = wibox.widget.textbox(),
                markup = "<b>Notifications</b>",
                align = "center",
                valign = "center",
                forced_height = 30,
            },
            next_button,
        }),
        notifys_center,
    },
}

local scroller = ui.h_scrollable(tabs, beautiful.dashboard_width, dashboard_height - 4 * 2, {top = 0, bottom = 0, left = 0, right = 0})
prev_button:buttons(awful.button({}, 1, function() scroller.scroll(-1) end))
next_button:buttons(awful.button({}, 1, function() scroller.scroll( 1) end))

dashboard:setup {
    scroller,
    widget = wibox.container.margin,
    margins = 4,
}

local dashboard_opened = false

local dashboard_timed = rubato.timed {
    duration = 0.3,
    intro = 0.1,
    override_dt = true,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        dashboard.x = dashboard.screen.geometry.width - pos
        if pos == 0 and not dashboard_opened then
            dashboard.visible = false
        end
    end
}

local function hide_dashboard()
    dashboard_opened = false
    dashboard_timed.target = 0
end
local function show_dashboard()
    dashboard.screen = awful.screen.focused()
    local h = dashboard.screen.geometry.height
    dashboard.y = config.bar_size + (config.floating_bar and config.screen_spacing or 0) + config.screen_spacing

    dashboard.visible = true

    dashboard_opened = true
    dashboard_timed.target = beautiful.dashboard_width
                           + (config.floating_bar and beautiful.useless_gap * 2 or config.screen_spacing)
end
local function toggle_dashboard()
    if not dashboard_opened then
        awesome.emit_signal("dashboard::show")
    else
        awesome.emit_signal("dashboard::hide")
    end
end

-- hide on click
local function hide_dashboard_on_click()
    if dashboard.visible and not prompt_running then
        awesome.emit_signal("dashboard::hide")
    end
end
awful.mouse.append_global_mousebinding(awful.button({}, 1, hide_dashboard_on_click))
client.connect_signal("button::press", hide_dashboard_on_click)

awesome.connect_signal("dashboard::show", show_dashboard)
awesome.connect_signal("dashboard::hide", hide_dashboard)
awesome.connect_signal("dashboard::toggle", toggle_dashboard)
awesome.connect_signal("dashboard::toggle_tag", function(tag_id)
    toggle_dashboard()
    scroller.scroll_to(tag_id)
end)