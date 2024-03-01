local config    = require("config")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local awesome_dir = require("gears").filesystem.get_configuration_dir()

local text = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
}
local icon = wibox.widget.imagebox(awesome_dir.."icon/openweathermap/na.png")

awesome.connect_signal("weather::current", function(dat)
    text.markup = "<b>"..math.floor(dat["main"]["temp"] + 0.5).."°C</b>"
    icon.image = dat["icon_image"]
end)

local weatherwidget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    {
        icon,
        widget = wibox.container.margin,
        right = -3,
        left = -5
    },
    text,
    widget = wibox.container
}

return weatherwidget
