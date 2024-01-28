-- signals
--[[
    widget::temperature, temp in °C
]]--

local beautiful = require("beautiful")
local lain      = require("lain")

local lain_temp = lain.widget.temp {
    timeout = 15,
    -- run `find /sys/devices -type f -name *temp*`
    tempfile = "/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input",
    settings = function()
        awesome.emit_signal("widget::temperature", coretemp_now)
    end
}