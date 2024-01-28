-- signals
--[[
    widget::cpu_usage, usage in percent
]]--

local beautiful = require("beautiful")
local lain      = require("lain")

local lain_cpu = lain.widget.cpu {
    timeout = 2,
    settings = function()
        awesome.emit_signal("widget::cpu_usage", cpu_now.usage)
    end
}