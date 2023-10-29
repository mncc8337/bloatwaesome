local wibox = require("wibox")

local wt = wibox.widget.textbox("insert weather widget")
wt.align = "center"

return wibox.widget {
    wt,
    widget = wibox.container.background,
    bg = color_crust,
}