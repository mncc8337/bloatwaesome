local lain = require("lain")
local markup = lain.util.markup

local cpuico = markup.fg.color(color_blue, "󰍛  ")
local lain_cpu = lain.widget.cpu {
    timeout = 3,
    settings = function()
        widget:set_markup(cpuico..cpu_now.usage..'%')
    end
}
lain_cpu.widget.align = "center"
lain_cpu.update()

local cpuwidget = wibox.widget {
    widget = wibox.container.margin,
    right = widget_spacing,
    wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        lain_cpu,
    }
}

return cpuwidget