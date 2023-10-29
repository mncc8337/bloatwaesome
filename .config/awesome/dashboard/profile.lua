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
local p_name = wibox.widget.textbox("<span font='"..beautiful.font_mono.." 12'>"..'@'..name.."</span>")
p_name.align = "center"
p_name.valign = "center"
p_name.forced_height = 20
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
                markup = markup.fg.color(color, "<span font='"..beautiful.font_icon.." 12'>"..icon.." </span>"),
            },
            widget = wibox.container.margin,
            left = 12,
        },
        {
            {
                widget = wibox.widget.textbox,
                markup = markup.fg.color(color, "<span font = '"..beautiful.font_mono.." 12'>"..text.."</span>"),
                halign = "right",

            },
            widget = wibox.container.margin,
            right = 4,
        }
    }
end
local distro = io.popen(". /etc/os-release && printf \"$NAME\""):read("*all")
local versio = io.popen("uname -r"):read("*all")
local packag = io.popen("pacman -Qq | wc -l"):read("*all")
local fetch = v_centered_widget(wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = 2,
    fetch_component("", distro, color_blue),
    fetch_component("", string.gsub(versio, '\n', ''), color_yellow),
    fetch_component("󰏖", string.gsub(packag, '\n', ''), color_green),
    fetch_component("", "AwesomeWM", color_red),
    forced_width = dashboard_width - profile_pic.forced_width - 170, --3
})

return ui.create_dashboard_panel(wibox.widget {
    layout = wibox.layout.align.horizontal,
    fetch,
    profile,
})