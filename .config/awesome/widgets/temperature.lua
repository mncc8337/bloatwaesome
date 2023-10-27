local lain = require("lain")
local markup = lain.util.markup

local tempico = markup.fg.color(color_red, "󰔏  ")
local lain_temp = lain.widget.temp {
    timeout = 3,
    -- run `find /sys/devices -type f -name *temp*`
    tempfile = "/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input",
    settings = function()
        widget:set_markup(tempico..coretemp_now.."°C")
    end
}
lain_temp.widget.align = "center"
lain_temp.update()

local tempwidget = wibox.widget {
    widget = wibox.container.margin,
    right = widget_spacing,
    wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        lain_temp,
    }
}

return tempwidget