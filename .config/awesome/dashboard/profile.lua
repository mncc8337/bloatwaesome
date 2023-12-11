local beautiful = require("beautiful")
local wibox     = require("wibox")

local markup    = require("lain").util.markup
local ui        = require("dashboard.ui_elements")

local profile_pic = wibox.widget.imagebox(profile_picture)
profile_pic.forced_width = 100
profile_pic.forced_height = 100

local name = io.popen("id -un"):read("*all")
name = string.gsub(name, '\n', '')
-- local host = io.popen([[cat /etc/hostname]]):read("*all")
local p_name = wibox.widget.textbox("<span font='"..beautiful.font_type.mono.." 12'>"..'@'..name.."</span>")
p_name.align = "center"
p_name.valign = "center"
p_name.forced_height = 20
p_name.forced_width = profile_pic.forced_width
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
                markup = markup.fg.color(color, "<span font='"..beautiful.font_type.icon.." 12'>"..icon.." </span>"),
            },
            widget = wibox.container.margin,
            left = 12,
        },
        {
            {
                widget = wibox.widget.textbox,
                markup = markup.fg.color(color, "<span font = '"..beautiful.font_type.mono.." 12'>"..text.."</span>"),
                halign = "right",

            },
            widget = wibox.container.margin,
            right = 4,
        }
    }
end
local function update_fetch_component(widget, icon, text, color)
    widget.first.widget.markup = markup.fg.color(color, "<span font='"..beautiful.font_type.icon.." 12'>"..icon.." </span>")
    widget.second.widget.markup = markup.fg.color(color, "<span font = '"..beautiful.font_type.mono.." 12'>"..text.."</span>")
end

local line_distro   = fetch_component("c", "a", "#ffffff")
local line_version  = fetch_component("c", "a", "#ffffff")
local line_packages = fetch_component("c", "a", "#ffffff")
local line_wm       = fetch_component("c", "a", "#ffffff")

local function update_info()
    local distro = io.popen(". /etc/os-release && printf \"$NAME\""):read("*all")
    local versio = io.popen("uname -r"):read("*all")
    local packag = io.popen("pacman -Qq | wc -l"):read("*all")

    update_fetch_component(line_distro, "", distro, beautiful.color.blue)
    update_fetch_component(line_version, "", string.gsub(versio, '\n', ''), beautiful.color.yellow)
    update_fetch_component(line_packages, "󰏖", string.gsub(packag, '\n', ''), beautiful.color.green)
    update_fetch_component(line_wm, "", "AwesomeWM", beautiful.color.red)
end
awesome.connect_signal("dashboard::show", update_info)

local fetch = v_centered_widget(wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = 2,
    line_distro,
    line_version,
    line_packages,
    line_wm,
    forced_width = dashboard_width - profile_pic.forced_width - 230, --3
})

return ui.create_dashboard_panel(wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    fetch,
    profile,
})