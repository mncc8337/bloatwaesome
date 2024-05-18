local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")

local separator = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    shape = gears.shape.rounded_rect,
    color = beautiful.separator,
    forced_height = 18,
    forced_width = 4,
}
separator = v_centered_widget(separator)

local thin_separator = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    shape = gears.shape.rounded_rect,
    color = beautiful.separator,
    forced_height = 18,
    forced_width = 2,
}
thin_separator = v_centered_widget(thin_separator)

local weather = require("widgets.weather")
local clock = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    spacing = 10,
    wibox.widget {
        widget = wibox.widget.textclock,
        format = "%B %d <b>%H:%M</b>",
        valign = "center",
        align = "center",
    },
    thin_separator,
    weather,
}
clock:add_button(awful.button({}, 1, function()
    awesome.emit_signal("timeweather::toggle")
end))

local alsa = require("widgets.alsa")

return {
    separator = separator,
    thin_separator = thin_separator,
    music = require("widgets.playerctl"),
    clock = clock,
    alsa = alsa.volumewidget,
    volumeslider = alsa.volume_slider,
    launcher = require("widgets.launcher"),
    --mykeyboardlayout = awful.widget.keyboardlayout()
}