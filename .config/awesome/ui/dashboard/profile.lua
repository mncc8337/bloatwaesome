local config    = require("config")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local awful     = require("awful")

local ui        = require("ui.ui_elements")

local profile_pic = wibox.widget.imagebox(config.profile_picture)
profile_pic.forced_width = 100
profile_pic.forced_height = 100

local p_name = wibox.widget {
    widget = wibox.widget.textbox,
    font = beautiful.font_type.mono.." 12",
    align = "center",
    valign = "center",
    forced_height = 20,
    forced_width = profile_pic.forced_width,
}

-- update name
awful.spawn.easy_async("id -un", function(name)
    p_name.markup = '@'..name:sub(1, -2)
end)

local profile = wibox.widget {
    {
        layout = wibox.layout.align.vertical,
        profile_pic,
        p_name,
    },
    widget = wibox.container.margin,
    top = 12, bottom = 5, right = 12, left = 5,
}

local function fetch_component(icon, text, color)
    return wibox.widget {
        layout = wibox.layout.align.horizontal,
        {
            {
                widget = wibox.widget.textbox,
                markup = markup_fg(color, "<span font='"..beautiful.font_type.icon.." 12'>"..icon.." </span>"),
            },
            widget = wibox.container.margin,
            left = 12,
        },
        {
            {
                widget = wibox.widget.textbox,
                markup = markup_fg(color, "<span font = '"..beautiful.font_type.mono.." 12'>"..text.."</span>"),
                halign = "right",

            },
            widget = wibox.container.margin,
            right = 4,
        }
    }
end
local function update_fetch_component(widget, icon, text, color)
    widget.first.widget.markup = markup_fg(color, "<span font='"..beautiful.font_type.icon.." 12'>"..icon.." </span>")
    widget.second.widget.markup = markup_fg(color, "<span font = '"..beautiful.font_type.mono.." 12'>"..text.."</span>")
end

local line_distro   = fetch_component("c", "a", "#ffffff")
local line_version  = fetch_component("c", "a", "#ffffff")
local line_packages = fetch_component("c", "a", "#ffffff")
local line_wm       = fetch_component("c", "a", "#ffffff")
update_fetch_component(line_wm, "", "AwesomeWM", beautiful.color.red)

local function update_info()
    awful.spawn.easy_async_with_shell(". /etc/os-release && printf \"$NAME\"", function(distro)
        update_fetch_component(line_distro, "", distro:sub(1, -2), beautiful.color.blue)
    end)
    awful.spawn.easy_async("uname -r", function(version)
        update_fetch_component(line_version, "", version:sub(1, -2), beautiful.color.yellow)
    end)
    awful.spawn.easy_async_with_shell("pacman -Qq | wc -l", function(package)
        update_fetch_component(line_packages, "󰏖", package:sub(1, -2), beautiful.color.green)
    end)
end
awesome.connect_signal("dashboard::show", update_info)

local fetch = v_centered_widget(wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = 2,
    line_distro,
    line_version,
    line_packages,
    line_wm,
})

return ui.create_dashboard_panel(wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    fetch,
    profile,
})