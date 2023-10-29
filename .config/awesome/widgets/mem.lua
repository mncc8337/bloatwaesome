-- signals
--[[
    widget::memory, mem in MiB
    widget::memory_percent, usage in percent
]]--

local beautiful = require("beautiful")
local wibox     = require("wibox")

local lain      = require("lain")
local markup    = lain.util.markup

local memico    = wibox.widget.textbox(markup.fg.color(color_yellow, " "))
memico.font     = beautiful.font_icon.." 16"

local lain_mem = lain.widget.mem {
    timeout = 3,
    settings = function()
        widget:set_markup(markup.bold(mem_now.perc.."%"))
        awesome.emit_signal("widget::memory", mem_now.used)
        awesome.emit_signal("widget::memory_percent", mem_now.perc)
    end
}
lain_mem.widget.align = "center"
lain_mem.update()

local memwidget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    memico,
    lain_mem,
}

return memwidget