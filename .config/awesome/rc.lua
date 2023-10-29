local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local naughty   = require("naughty")
require("awful.autofocus")
require("remember-geometry")

awesome_dir = debug.getinfo(1, 'S').source:match[[^@(.*/).*$]]
beautiful.init(awesome_dir.."/config/theme.lua")
local bling = require("bling")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- debug only
function notify(message, title)
    naughty.notify({title = title, message = message})
end

-- number of tags
tag_num = 4

taskbar_size = 32
dashboard_width = 500
profile_picture = "/home/mncc/avt.png"

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"

alsa_device = 0

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"

--[[ layouts ]]--
local machi = require("layout-machi")

local centered = bling.layout.centered
local equal = bling.layout.equalarea
local desk = bling.layout.desk
-- local mstab = bling.layout.mstab
machi.editor.nested_layouts = {
    ["0"] = desk,
    ["1"] = awful.layout.suit.spiral,
    ["2"] = awful.layout.suit.fair,
    ["3"] = awful.layout.suit.fair.horizontal,
}

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.spiral.dwindle,
    -- mstab,
    centered,
    equal,
    machi.default_layout,
    awful.layout.suit.floating,
}

require("misc")

require("config.taskbar")
require("config.bindings")
require("config.rules")

require("dashboard")

--[[
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
]]--

-- change border color when (un)focus
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
client.connect_signal("below", function(c)
    c:geometry(c:gemometry())
end)

-- Run garbage collector regularly to prevent memory leaks
gears.timer {
    timeout = 30,
    autostart = true,
    callback = function() collectgarbage() end
}

-- hide drop-down clients on start
awful.spawn.easy_async("sleep 0.0001", function()
    local drop_term = find_client_with_name("drop-down-terminal")
    if drop_term then
        drop_term.hidden = true
    end
end)
