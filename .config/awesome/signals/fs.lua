-- signals
--[[
    fs::update, get info
    fs::usage, usage in percent
    fs::used, used space in GB
    fs::available, free space in GB
]]--

local awful  = require("awful")
local gears  = require("gears")
local config = require("config")

local last_available = nil
local last_used = nil

local function get_info(stdout)
    stdout = stdout:sub(1, -2)
    local tokens = gears.string.split(stdout, "%s")

    local used  = tonumber(tokens[4] * 0.000001024)
    local usage = tonumber(tokens[6]:sub(1, -2))
    
    if last_available == nil then
        local available = tonumber(tokens[5] * 0.000001024)
        awesome.emit_signal("fs::available", available)
        -- available space never change, set to 0 instead to save memory
        last_available = 0
    end
    
    if last_used ~= used then
        awesome.emit_signal("fs::usage", usage)
        awesome.emit_signal("fs::used", used)
        
        last_used = used
    end
    
end

awesome.connect_signal("fs::update", function()
    -- idk a better way to find root mounted disk
    awful.spawn.easy_async_with_shell("df -T -B 1K | grep -E \"/dev/sd.*ext4\"", get_info)
end)

awesome.emit_signal("fs::update")
gears.timer {
    timeout = config.widget_interval.disk,
    single_shot = false, autostart = true,
    callback = function()
        awesome.emit_signal("fs::update")
    end
}