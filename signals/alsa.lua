-- signals
--[[
    alsa::update, get info
    alsa::avg, average volume in both speaker in %
    alsa::mute, muted or not, true or false
]]--

local awful  = require("awful")
local gears  = require("gears")
local config = require("config")

local last_avg = nil
local last_mute = nil

local function get_info(stdout)
    stdout = stdout:sub(1, -2)
    local lines = gears.string.split(stdout, "\n")
    
    local left_v = 0
    local left_m = false
    local right_v = 0
    local right_m = false
    
    for _, line in ipairs(lines) do
        local v, m = line:match("([%d]+)%%.*%[([%l]*)") -- [vol%] [on/off]
        if line:match("([%d]+)%%.*%[([%l]*)") then
            v = tonumber(v)
            m = (m ~= "on")

            if line:match("Left") then
                left_v = v
                left_m = m
            elseif line:match("Right") then
                right_v = v
                right_m = m
            end
        end
    end

    local muted = (right_m == left_m) and left_m
    local avg = math.floor((left_v + right_v) / 2)

    if muted ~= last_mute then
        awesome.emit_signal("alsa::mute", muted)
        last_mute = muted
    end
    if avg ~= last_avg then
        awesome.emit_signal("alsa::avg", avg)
        last_avg = avg
    end
end

awesome.connect_signal("alsa::update", function()
    awful.spawn.easy_async_with_shell("amixer get "..config.alsa_channel, get_info)
end)

awesome.emit_signal("alsa::update")
gears.timer {
    timeout = config.widget_interval.alsa,
    single_shot = false, autostart = true,
    callback = function()
        awesome.emit_signal("alsa::update")
    end
}