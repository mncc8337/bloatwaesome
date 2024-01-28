local wibox     = require("wibox")
local beautiful = require("beautiful")

local td = wibox.widget.textbox("insert todo widget")
td.align = "center"

return wibox.widget {
    td,
    widget = wibox.container.background,
    bg = beautiful.dashboard_bg,
}