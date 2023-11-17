-- signals
--[[
    widget::temperature, temp in °C
]]--

local beautiful = require("beautiful")
local wibox     = require("wibox")

local lain      = require("lain")
local markup    = lain.util.markup

local tempico = wibox.widget.textbox(markup.fg.color(color_red, " "))
tempico.font  = beautiful.font_icon.." 16"

local lain_temp = lain.widget.temp {
    timeout = 15,
    -- run `find /sys/devices -type f -name *temp*`
    tempfile = "/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input",
    settings = function()
        widget:set_markup(markup.bold(coretemp_now.."°C"))
        awesome.emit_signal("widget::temperature", coretemp_now)
    end
}
lain_temp.widget.align = "center"
lain_temp.update()

local tempwidget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    tempico,
    lain_temp,
}

return tempwidget