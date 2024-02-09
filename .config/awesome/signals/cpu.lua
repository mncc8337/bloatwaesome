-- signals
--[[
    cpu::update, get info
    cpu::usage, usage in percent
]]--

local awful  = require("awful")
local gears  = require("gears")
local config = require("config")

local coreid = config.core_id + 1

local last_active = 0
local last_total = 0
local usage = 0

-- check valid core id
awful.spawn.easy_async("nproc --all", function(corenum)
    if tonumber(corenum) < config.core_id then
        -- convert it to 0 if not valid
        config.core_id = 0
        coreid = 1
    end
end)

local function get_info(stdout)
    stdout = stdout:sub(1, -2)
    local tokens = gears.string.split(stdout, "%s")

    local idle   = 0
    local total  = 0

    for i = 2, #tokens do
        local val = tonumber(tokens[i])
        -- idle and iowait
        if  i == 5 or i == 6 then
            idle = idle + val
        end
        total = total + val
    end
    local active = total - idle

    if active ~= last_active or total ~= last_total then
        local dactive = active - last_active
        local dtotal  = total - last_total
        usage = math.ceil(math.abs((dactive / dtotal) * 100))
        awesome.emit_signal("cpu::usage", usage)

        last_active = active
        last_total = total
    end
end

awesome.connect_signal("cpu::update", function()
    awful.spawn.easy_async_with_shell("cat /proc/stat | head -n " .. coreid .. " | tail -n 1", get_info)
end)

awesome.emit_signal("cpu::update")
gears.timer {
    timeout = config.widget_interval.cpu,
    single_shot = false, autostart = true,
    callback = function()
        awesome.emit_signal("cpu::update")
    end
}