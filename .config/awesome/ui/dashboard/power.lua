local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local ui        = require("ui.ui_elements")

local power_menu = wibox.widget {
    {
        layout = wibox.layout.fixed.vertical,
        spacing = 5,
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            ui.create_button_bg("󰐥", beautiful.shutdown_button, function() awful.spawn("systemctl poweroff") end),
            ui.create_button_bg("󰜉", beautiful.reboot_button, function() awful.spawn("systemctl reboot") end),
        },
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            ui.create_button_bg("󰤄", beautiful.sleep_button, function() awful.spawn("systemctl suspend") end),
            ui.create_button_bg("󰍃", beautiful.logout_button, function() awesome.quit() end),
        },
    },
    widget = wibox.container.margin,
    margins = 5,
}

return ui.create_dashboard_panel(power_menu)