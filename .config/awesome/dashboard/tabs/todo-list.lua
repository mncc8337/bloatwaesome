local wibox = require("wibox")

local td = wibox.widget.textbox("insert todo widget")
td.align = "center"

return wibox.widget {
    td,
    widget = wibox.container.background,
    bg = color_crust,
}