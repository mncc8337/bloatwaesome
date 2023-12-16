-- TODO: make misc.lua optional
require("misc")

local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local naughty   = require("naughty")
require("awful.autofocus")
require("remember-geometry")

awesome_dir = debug.getinfo(1, 'S').source:match[[^@(.*/).*$]]
beautiful.init(awesome_dir.."config/theme.lua")
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

-- TODO: move these into a config file
--{{

-- taskbar
tag_num = 4
taskbar_size = 32
taskbar_default_opacity = 0.85
taskbar_focus_opacity = 1.0

popup_roundness = 5

dashboard_width = 500
profile_picture = awesome_dir.."avt.png"

terminal = "alacritty"
editor = "code"

-- alsa device to control in widgets/alsa.lua
alsa_device = 0

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"
-- }}

--[[ bling things ]]--
bling.module.flash_focus.enable()

--[[ layouts ]]--
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.spiral.dwindle,
    bling.layout.mstab,
    bling.layout.centered,
    awful.layout.suit.floating,
}

require("config.taskbar")
require("config.bindings")
require("config.rules")

require("dashboard")
require("drop-down-term")

-- config hot corners' action
local corner_action = require("hot-corners")

corner_action.topright(function()
    awesome.emit_signal("drop-down-term::toggle")
end)
corner_action.bottomright(function()
    awesome.emit_signal("dashboard::toggle")
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

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
-- there must be some delay because of some stupid reason that idk
single_timer(0.01, function()
    local drop_term = find_client({class = "drop-down-terminal"})
    if drop_term then
        drop_term.hidden = true
        awesome.emit_signal("drop-down-term::set-term", drop_term)
    end
end):start()

wibox.connect_signal("button::press", function(w)
    awesome.emit_signal("drop-down-term::close")

    local mouse_on_dashboard = mouse.coords().x > awful.screen.focused().geometry.width - dashboard_width
                               and dashboard_visible()
    -- ignore if mouse click on dashboard
    if not mouse_on_dashboard then
        awesome.emit_signal("dashboard::hide")
    end
end)