-- signals
--[[
    widget::memory, mem in MiB
    widget::memory_percent, usage in percent
]]--

local beautiful = require("beautiful")
local lain      = require("lain")

local lain_mem = lain.widget.mem {
    timeout = 3,
    settings = function()
        awesome.emit_signal("widget::memory", mem_now.used)
        awesome.emit_signal("widget::memory_percent", mem_now.perc)
    end
}