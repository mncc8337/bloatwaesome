local beautiful = require("beautiful")
local wibox     = require("wibox")

local lain = require("lain")

local ui = require("dashboard.ui_elements")

--[[ arcchart ]]--
local arc_bundle = ui.create_arcchart("", color_blue, color_crust)

local cpu_usage_text = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "100%",
    font = beautiful.font_mono.." bold 12",
    align = "right",
    valign = "bottom",
    forced_height = 25,
}

--[[ graph ]]--
local graph_bundle = ui.create_graph("CPU", color_blue, color_base, 100, 0)

awesome.connect_signal("widget::cpu_usage", function(usage)
    cpu_usage_text.markup = usage..'%'
    arc_bundle.set_value(usage)
    graph_bundle.add_value(usage)
end)

return {
    arcchart = ui.create_dashboard_panel(wibox.widget {
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
                    font = beautiful.font_mono.." bold 10",
                    valign = "bottom",
                    forced_height = 25,
                },
                cpu_usage_text,
            },
            widget = wibox.container.margin,
            left = 8, right = 8, bottom = 8,
        }
    }),
    graph = ui.create_dashboard_panel(graph_bundle.graph),
}