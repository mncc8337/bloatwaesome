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

local musicplayer = require("musicplayer")
local widgets    = require("widgets")
local ui         = require("ui_elements")
local rubato     = require("modules.rubato")

--[[ WIDGETS ]]--
local clock = wibox.widget {
    widget = wibox.widget.textclock,
    format = "%H:%M",
    font = beautiful.font_type.mono.." 60",
    align = "center",
    valign = "center",
    height = 80,
}

local profile_panel = require("dashboard.profile")
local quote_panel = require("dashboard.quote")
local music_panel = ui.create_dashboard_panel(musicplayer)
local volume_slider_panel = ui.create_dashboard_panel(widgets.volumeslider)

local fs_panel = require("dashboard.filesystem")
local mem_panel = require("dashboard.mem")
local cpu_panel = require("dashboard.cpu")

local arccharts = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    cpu_panel,
    cpu_panel,
    mem_panel,
    fs_panel,
}

local power_panel = require("dashboard.power")
local uptime_panel = require("dashboard.uptime")

--[[ BASE ]]--
local dashboard = wibox {
    ontop = true,
    visible = false,
    type = "dock",
    width = config.dashboard_width,
    --       title   profile-panel  power-menu  music-player  volume  arcchart            spacing
    height = 30    + 137          + 79        + 144         + 50    + ui.arc_size + 46  + 8 * 7,
    x = awful.screen.focused().geometry.width - config.dashboard_width,
    y = config.bar_size,
    bg = beautiful.dashboard_bg,
    screen = awful.screen.focused(),
    shape = rounded_rect(config.popup_roundness),
    border_width = beautiful.border_width,
    border_color = beautiful.border_focus,
}

dashboard:setup {
    {
        layout = wibox.layout.fixed.vertical,
        ui.create_dashboard_panel(wibox.widget {
            widget = wibox.widget.textbox(),
            markup = "<b>Dashboard</b>",
            align = "center",
            valign = "center",
            forced_height = 30,
        }),
        {
            layout = wibox.layout.align.horizontal,
            quote_panel,
            profile_panel,
        },
        {
            layout = wibox.layout.align.horizontal,
            expand = "inside",
            wibox.widget {},
            uptime_panel,
            power_panel,
            -- options_panel,
        },
        music_panel,
        volume_slider_panel,
        arccharts,
    },
    widget = wibox.container.margin,
    margins = 4,
}

-- the direction of the dashboard
local dashboard_opened = true

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
    dashboard.y = config.bar_size + (config.floating_bar and beautiful.border_width * 2 + config.screen_spacing or 0) + config.screen_spacing

    dashboard.visible = true

    dashboard_opened = true
    dashboard_timed.target = config.dashboard_width + (config.floating_bar and beautiful.useless_gap * 2 or config.screen_spacing)
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

return dashboard