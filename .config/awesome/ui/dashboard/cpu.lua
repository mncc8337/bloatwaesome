local beautiful = require("beautiful")
local wibox     = require("wibox")

local lain = require("lain")

local ui = require("ui.ui_elements")

--[[ arcchart ]]--
local arc_bundle = ui.create_arcchart("", beautiful.cpu_icon_color)

local cpu_usage_text = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "100%",
    font = beautiful.font_type.mono.." bold 11",
    align = "right",
    valign = "bottom",
    forced_height = 25,
}

awesome.connect_signal("widget::cpu_usage", function(usage)
    cpu_usage_text.markup = usage..'%'
    arc_bundle.set_value(usage)
    -- graph_bundle.add_value(usage)
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
                markup = "CPU",
                font = beautiful.font_type.mono.." bold 9",
                valign = "bottom",
                forced_height = 25,
            },
            cpu_usage_text,
        },
        widget = wibox.container.margin,
        left = 8, right = 8, bottom = 8,
    }
})