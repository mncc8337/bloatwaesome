local wibox     = require("wibox")
local beautiful = require("beautiful")

local wt = wibox.widget.textbox("insert weather widget")
wt.align = "center"

return wibox.widget {
    wt,
    widget = wibox.container.background,
    bg = beautiful.dashboard_bg,
}