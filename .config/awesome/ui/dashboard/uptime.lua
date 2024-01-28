local beautiful = require("beautiful")
local wibox     = require("wibox")
local ui        = require("ui.ui_elements")

local uptime = wibox.widget {
    widget = wibox.widget.textbox(),
    markup = "",
    align = "center",
}

awesome.connect_signal("dashboard::show", function()
    local time = io.popen("uptime -p"):read("*all")
    time = string.gsub(time, '\n', '')
    uptime.markup = time
end)

return ui.create_dashboard_panel(wibox.widget {
    uptime,
    widget = wibox.container.margin,
    margins = 5,
})