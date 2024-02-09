local beautiful = require("beautiful")
local wibox     = require("wibox")

local ui        = require("ui.ui_elements")

--[[ arcchart ]]--
local arc_bundle = ui.create_arcchart("", beautiful.mem_icon_color)

local mem_used_text = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "8GIG NOWAY",
    font = beautiful.font_type.mono.." bold 11",
    align = "right",
    valign = "bottom",
    forced_height = 25,
}

awesome.connect_signal("mem::percent", function(percent)
    arc_bundle.set_value(percent)
end)
awesome.connect_signal("mem::used", function(mem)
    mem_used_text.markup = (math.floor(mem*100/1000)/100).."GB"
end)
awesome.connect_signal("dashboard::show", function()
    awesome.emit_signal("mem::update")
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
                font = beautiful.font_type.mono.." bold 9",
                valign = "bottom",
                forced_height = 25,
            },
            mem_used_text,
        },
        widget = wibox.container.margin,
        left = 8, right = 8, bottom = 8,
    }
})
