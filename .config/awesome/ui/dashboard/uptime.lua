local beautiful = require("beautiful")
local wibox     = require("wibox")
local awful     = require("awful")
local ui        = require("ui.ui_elements")

local uptime = wibox.widget {
    widget = wibox.widget.textbox(),
    markup = "",
    align = "center",
}

awesome.connect_signal("dashboard::show", function()
    awful.spawn.easy_async("uptime -p", function(time)
        time = string.gsub(time, '\n', '')
        uptime.markup = time
    end)
end)

return ui.create_dashboard_panel(wibox.widget {
    uptime,
    widget = wibox.container.margin,
    margins = 5,
})