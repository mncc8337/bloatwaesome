gears       = require("gears")
awful       = require("awful")
beautiful   = require("beautiful")
require("awful.autofocus")
wibox       = require("wibox")
naughty     = require("naughty")
-- menubar     = require("menubar")

hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- local dpi = require("beautiful.xresources").apply_dpi

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

awesome_dir = debug.getinfo(1, 'S').source:match[[^@(.*/).*$]]

-- Themes define colours, icons, font and wallpapers.
beautiful.init(awesome_dir.."/config/theme.lua")
bling = require("bling")
-- menubar.utils.lookup_icon(beautiful.icon_theme)

-- debug only
function notify(message, title)
    naughty.notify({title = title, message = message})
end

-- number of tags
tag_num = 4

taskbar_size = 32

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

alsa_device = 0

-- "mpd" or "playerctl"
-- use "playerctl" for support for vlc, mpv, RhythmBox, web browsers, cmus, spotify and others
music_player = "playerctl"

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"

--[[ others ]]--
require("remember-geometry")
--[[
nice = require("nice")
nice {
    minimize_color = "#4cbb17",
    maximize_color = "#ffb400",
    no_titlebar_maximized = true,
    titlebar_items = {
        left = {
            "floating", "ontop", "sticky"
        },
        middle = "title",
        right = {
        "minimize", "maximize", "close"
        }
    }
}
]]--


--[[ layouts ]]--
local machi = require("layout-machi")

local centered = bling.layout.centered
local equal = bling.layout.equalarea
local desk = bling.layout.desk
local mstab = bling.layout.mstab
machi.editor.nested_layouts = {
    ["0"] = desk,
    ["1"] = awful.layout.suit.spiral,
    ["2"] = awful.layout.suit.fair,
    ["3"] = awful.layout.suit.fair.horizontal,
}

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.spiral.dwindle,
    mstab,
    -- awful.layout.suit.max,
    centered,
    equal,
    machi.default_layout,
    awful.layout.suit.floating,
}

require("misc")

--[[ main widgets ]]--
-- require("menu")
require("config.taskbar")

--[[ key bindings ]]--
require("config.bindings")
require("config.rules")

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
    if drop_term then drop_term.hidden = true end
end)
