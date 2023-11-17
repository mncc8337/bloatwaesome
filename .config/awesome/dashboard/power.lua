local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local markup    = require("lain").util.markup
local ui        = require("dashboard.ui_elements")

local power_menu = wibox.widget {
    {
        layout = wibox.layout.fixed.vertical,
        spacing = 5,
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            ui.create_button("󰐥", color_red, function() awful.spawn("systemctl poweroff") end),
            ui.create_button("󰜉", color_green, function() awful.spawn("systemctl reboot") end),
        },
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            ui.create_button("󰤄", color_blue, function() awful.spawn("systemctl suspend") end),
            ui.create_button("󰍃", color_rosewater, function() awesome.quit() end),
        },
    },
    widget = wibox.container.margin,
    margins = 5,
}

return ui.create_dashboard_panel(power_menu)