local wibox = require("wibox")

local musicplayer = require("ui.musicplayer")
local widgets     = require("widgets")
local ui          = require("ui.ui_elements")

--[[ WIDGETS ]]--
local profile_panel = require("ui.dashboard.control_center.profile")
local quote_panel = require("ui.dashboard.control_center.quote")
local music_panel = ui.create_dashboard_panel(musicplayer)
local volume_slider_panel = ui.create_dashboard_panel(widgets.volumeslider)

local fs_panel = require("ui.dashboard.control_center.filesystem")
local mem_panel = require("ui.dashboard.control_center.mem")
local cpu_panel = require("ui.dashboard.control_center.cpu")
local temp_panel = require("ui.dashboard.control_center.temp")

local sysres = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    cpu_panel,
    mem_panel,
    fs_panel,
    temp_panel,
}

local power_panel = require("ui.dashboard.control_center.power")
local uptime_panel = require("ui.dashboard.control_center.uptime")

return wibox.widget {
    layout = wibox.layout.fixed.vertical,
    {
        layout = wibox.layout.align.horizontal,
        quote_panel,
        profile_panel,
    },
    {
        layout = wibox.layout.align.horizontal,
        expand = "inside",
        nil,
        uptime_panel,
        power_panel,
    },
    music_panel,
    volume_slider_panel,
    sysres,
}