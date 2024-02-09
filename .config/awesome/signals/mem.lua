-- signals
--[[
    mem::update, get info
    mem::used, mem in MB
    mem::swap, swap in MB
    mem::percent, usage in percent
]]--

local awful  = require("awful")
local gears  = require("gears")
local config = require("config")

local total    = 0
local free     = 0
local buf      = 0
local cache    = 0
local swap     = 0
local swapf    = 0
local srec     = 0
local used     = 0
local swapused = 0
local perc     = 0

local function get_info(stdout)
    stdout = stdout:sub(1, -2)
    local lines = gears.string.split(stdout, "\n")

    for _, line in ipairs(lines) do
        local tokens = gears.string.split(line, "%s")
        local field = tokens[1]:sub(1, -2)
        local val = tonumber(tokens[2])

        -- val unit is kB or 1024 bytes

        -- convert to MB
        if     field == "MemTotal"     then total = math.floor(val * 0.001024 + 0.5)
        elseif field == "MemFree"      then free  = math.floor(val * 0.001024 + 0.5)
        elseif field == "Buffers"      then buf   = math.floor(val * 0.001024 + 0.5)
        elseif field == "Cached"       then cache = math.floor(val * 0.001024 + 0.5)
        elseif field == "SwapTotal"    then swap  = math.floor(val * 0.001024 + 0.5)
        elseif field == "SwapFree"     then swapf = math.floor(val * 0.001024 + 0.5)
        elseif field == "SReclaimable" then srec  = math.floor(val * 0.001024 + 0.5)
        end
    end

    used = total - free - buf - cache - srec
    swapused = swap - swapf
    perc = math.floor(used / total * 100)

    awesome.emit_signal("mem::used", used)
    awesome.emit_signal("mem::swap", swapused)
    awesome.emit_signal("mem::percent", perc)
end

awesome.connect_signal("mem::update", function()
    awful.spawn.easy_async("cat /proc/meminfo", get_info)
end)

awesome.emit_signal("mem::update")
gears.timer {
    timeout = config.widget_interval.mem,
    single_shot = false, autostart = true,
    callback = function()
        awesome.emit_signal("mem::update")
    end
}