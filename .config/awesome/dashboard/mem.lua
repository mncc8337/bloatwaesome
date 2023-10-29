local beautiful = require("beautiful")
local wibox     = require("wibox")

local lain      = require("lain")

local ui        = require("dashboard.ui_elements")

--[[ arcchart ]]--
local arc_bundle = ui.create_arcchart("", color_yellow, color_crust)

local mem_used_text = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "8GIG NOWAY",
    font = beautiful.font_mono.." bold 12",
    align = "right",
    valign = "bottom",
    forced_height = 25,
}

awesome.connect_signal("widget::memory_percent", function(percent)
    arc_bundle.set_value(percent)
end)
awesome.connect_signal("widget::memory", function(mem)
    mem_used_text.markup = mem.."MiB"
end)

return ui.create_dashboard_panel(wibox.widget {
    layout = wibox.layout.align.vertical,
    {
        arc_bundle.arc,
        widget = wibox.container.margin,
        top = 8, left = 8, right = 8, bottom = 5,
    },
    {
        {
            layout = wibox.layout.align.horizontal,
            wibox.widget {
                widget = wibox.widget.textbox,
                markup = "RAM",
                font = beautiful.font_mono.." bold 10",
                valign = "bottom",
                forced_height = 25,
            },
            mem_used_text,
        },
        widget = wibox.container.margin,
        left = 8, right = 8, bottom = 8,
    }
})
