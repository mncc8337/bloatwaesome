local lain = require("lain")
local markup = lain.util.markup

local mem_used = ""
local memico = markup.fg.color(color_yellow, "󰘚  ")
local lain_mem = lain.widget.mem {
    timeout = 3,
    settings = function()
        widget:set_markup(memico..mem_now.perc.."%") -- mem_now.used.."MiB, "..
        mem_used = mem_now.used.."MiB used"
    end
}
lain_mem.widget.align = "center"
lain_mem.update()

local memwidget = wibox.widget {
    widget = wibox.container.margin,
    right = widget_spacing,
    wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        lain_mem,
    }
}

local tooltip = awful.tooltip {
    objects        = {memwidget},
    timer_function = function()
        return mem_used
    end,
}

return memwidget