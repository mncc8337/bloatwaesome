-- signals
--[[
    dashboard::show
    dashboard::hide
    dashboard::toggle
]]--

local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local widgets   = require("widgets")
local lain      = require("lain")
local markup    = lain.util.markup
local ui        = require("dashboard.ui_elements")
local rubato    = require("rubato")

--[[ WIDGETS ]]--
local clock = wibox.widget.textbox()
clock.align = "center"
clock.valign = "center"
clock.forced_height = 80
local clock_update_timer = gears.timer {
    autostart = true,
    timeout = 1,
    callback = function()
        clock.markup = os.date("<span font = '"..beautiful.font_type.mono.." 60'>%H:%M</span>")
    end
}

local profile_panel = require("dashboard.profile")
local quote_panel = require("dashboard.quote")
local music_panel = ui.create_dashboard_panel(widgets.musicplayer)
local volume_slider_panel = ui.create_dashboard_panel(widgets.volumeslider)

local fs_panel = require("dashboard.filesystem")
local mem_panel = require("dashboard.mem")
local cpu = require("dashboard.cpu")

local arccharts = wibox.widget {
    layout = wibox.layout.align.horizontal,
    cpu.arcchart,
    mem_panel,
    fs_panel,
}

-- local sys_resource_panel = wibox.widget {
--     layout = wibox.layout.stack,
--     cpu.graph, arccharts,
-- }
-- local arccharts_current_action = "opened"
-- local arccharts_timed = rubato.timed {
--     duration = 0.3,
--     intro = 0.1,
--     override_dt = true,
--     easing = rubato.easing.quadratic,
--     subscribed = function(pos)
--         arccharts.opacity = pos
--         if pos == 1 and arccharts_current_action == "opening" then
--             arccharts_current_action = "opened"
--             cpu.graph.visible = false
--         elseif pos == 0 and arccharts_current_action == "closing" then
--             arccharts_current_action = "closed"
--         end
--     end
-- }

-- hide arccharts on click
-- arccharts:connect_signal("button::press", function()
--     if arccharts_current_action == "opening" or arccharts_current_action == "opened" then
--         cpu.graph.visible = true
--         arccharts_current_action = "closing"
--         arccharts_timed.target = 0
--     elseif arccharts_current_action == "closing" or arccharts_current_action == "closed" then
--         arccharts_current_action = "opening"
--         arccharts_timed.target = 1
--     end
-- end)
-- arccharts_timed.target = 1

local power_panel = require("dashboard.power")
local uptime_panel = require("dashboard.uptime")
local options_panel = require("dashboard.options")
local tabs_panel = require("dashboard.tabs")

--[[ BASE ]]--
local dashboard = wibox {
    ontop = true,
    visible = false,
    type = "dock",
    width = dashboard_width,
    height = awful.screen.focused().geometry.height,
    x = awful.screen.focused().geometry.width - dashboard_width,
    bg = beautiful.dashboard_bg,
    screen = awful.screen.focused(),
}
dashboard:setup {
    {
        layout = wibox.layout.fixed.vertical,
        id = "widgets",
        clock,
        {
            layout = wibox.layout.align.horizontal,
            quote_panel,
            profile_panel,
        },
        music_panel,
        volume_slider_panel,
        {
            layout = wibox.layout.align.horizontal,
            power_panel,
            uptime_panel,
            options_panel,
        },
        -- sys_resource_panel,
        arccharts,
        tabs_panel,
    },
    widget = wibox.container.margin,
    margins = 4,
}

-- a variable to track what the panel is doing
local dashboard_current_action = "closed"

local dashboard_timed = rubato.timed {
    duration = 0.3,
    intro = 0.1,
    override_dt = true,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        dashboard.x = awful.screen.focused().geometry.width - pos
        if pos == 0 and dashboard_current_action == "closing" then
            dashboard.visible = false
            dashboard_current_action = "closed"
        elseif pos == dashboard_width and dashboard_current_action == "opening" then
            dashboard_current_action = "opened"
        end
    end
}

function dashboard_visible()
    return dashboard.visible
end
local function hide_dashboard()
    dashboard_current_action = "closing"
    dashboard_timed.target = 0
    if mouse.current_widget == widgets.music then
        awesome.emit_signal("music::show_player", true)
    elseif mouse.current_widget == widgets.alsa then
        awesome.emit_signal("widget::show_volume_control", "top_right", 0.1)
    end
end
local function show_dashboard()
    dashboard.screen = awful.screen.focused()
    dashboard.visible = true

    dashboard_current_action = "opening"
    dashboard_timed.target = dashboard_width
end
local function toggle_dashboard()
    if dashboard_current_action == "closing" then
        dashboard_current_action = "opening"
        dashboard_timed.target = dashboard_width
    elseif dashboard_current_action == "opening" then
        dashboard_current_action = "closing"
        dashboard_timed.target = 0
    elseif dashboard_current_action == "closed" then
        awesome.emit_signal("dashboard::show")
    elseif dashboard_current_action == "opened" then
        awesome.emit_signal("dashboard::hide")
    end
end

-- hide on click
local function hide_dashboard_on_click()
    if dashboard_visible() and not prompt_running then
        awesome.emit_signal("dashboard::hide")
    end
end
awful.mouse.append_global_mousebinding(awful.button({}, 1, hide_dashboard_on_click))
client.connect_signal("button::press", hide_dashboard_on_click)

awesome.connect_signal("dashboard::show", show_dashboard)
awesome.connect_signal("dashboard::hide", hide_dashboard)
awesome.connect_signal("dashboard::toggle", toggle_dashboard)