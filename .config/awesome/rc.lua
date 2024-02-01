-- TODO: make misc.lua optional
require("misc")

local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local naughty   = require("naughty")

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        }
        in_error = false
    end)
end
-- }}}
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end

function notify(msg, title)
    naughty.notify {message = msg, title = title}
end

require("awful.autofocus")
require("modules.remember-geometry")

-- load config
local config = require("config")
local theme = require("theme")
theme.load(config.theme)
if config.floating_bar then
    naughty.config.padding = beautiful.useless_gap * 2
else
    naughty.config.padding = config.bar_screen_space
end

local bling = require("modules.bling")

--[[ bling things ]]--
-- bling.module.flash_focus.enable()

--[[ layouts ]]--
awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.spiral.dwindle,
    bling.layout.mstab,
    bling.layout.centered,
    awful.layout.suit.floating,
})

require("signals")
require("bindings")
require("rules")
require("ui")

-- config hot corners' action
local corner_action = require("modules.hot-corners")

corner_action.topright(function()
    awesome.emit_signal("dashboard::toggle")
end)
corner_action.topleft(function()
    awesome.emit_signal("drop-down-term::toggle")
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

-- hide drop-down client on start
-- there must be some delay because of some stupid reason that idk
single_timer(0.000001, function()
    local drop_term = find_client({class = "drop-down-terminal"})
    if drop_term then
        drop_term.hidden = true
        awesome.emit_signal("drop-down-term::set-term", drop_term)
    end
end):start()