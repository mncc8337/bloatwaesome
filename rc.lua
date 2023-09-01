gears       = require("gears")
awful       = require("awful")
beautiful   = require("beautiful")
require("awful.autofocus")
wibox       = require("wibox")
naughty     = require("naughty")
-- menubar     = require("menubar")

hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

require("error_handling")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(".config/awesome/theme.lua")
bling = require("bling")
-- menubar.utils.lookup_icon(beautiful.icon_theme)

-- number of tags
tag_num = 4

taskbar_size = 30

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

alsa_device = 0

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

require("extension")

--[[ main widgets ]]--
-- require("menu")
require("taskbar")

--[[ key bindings ]]--
require("bindings")
require("rules")

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
    local drop_mpll = find_client_with_name("drop-down-ncmpcpp")
    if drop_term then drop_term.hidden = true end
    if drop_mpll then drop_mpll.hidden = true end
end)
