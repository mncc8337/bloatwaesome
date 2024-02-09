-- signals
--[[
    therm::update, get info
    therm::temperature, temp in °C
]]--

local awful  = require("awful")
local gears  = require("gears")
local config = require("config")

local cmd = "find /sys/devices -type f -name \"*temp*\" | grep -E \"coretemp.*temp1_input\""
local tempfile = nil

-- get tempfile
if config.tempfile == nil then
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        tempfile = stdout:sub(1, -2)
    end)
else tempfile = config.tempfile end

local function get_info(stdout)
    stdout = stdout:sub(1, -2)

    local temp = tonumber(stdout) / 1000
    awesome.emit_signal("therm::temperature", temp)
end

awesome.connect_signal("therm::update", function()
    if tempfile == nil then return end
    awful.spawn.easy_async("cat "..tempfile, get_info)
end)

awesome.emit_signal("therm::update")
gears.timer {
    timeout = config.widget_interval.therm,
    single_shot = false, autostart = true,
    callback = function()
        awesome.emit_signal("therm::update")
    end
}