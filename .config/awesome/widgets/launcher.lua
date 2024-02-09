local awful    = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local launcher = wibox.widget {
    {
        widget = wibox.widget.textbox,
        markup = "",
        forced_width = 50,
        align = "center",
        valign = "center",
        font = beautiful.font_type.icon,
    },
    widget = wibox.container.background,
    fg = beautiful.launcher_fg,
    bg = beautiful.launcher_bg,
    shape = rounded_rect(beautiful.popup_roundness),
}
launcher:buttons(awful.button({}, 1, function()
    awful.spawn("rofi -show drun")
end))

return wibox.widget {
    launcher,
    widget = wibox.container.margin,
    margins = 3,
}