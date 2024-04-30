local beautiful = require("beautiful")
local wibox     = require("wibox")

local ui = require("ui.ui_elements")

local arc_bundle = ui.create_arcchart("󰋊", beautiful.filesys_icon_color)

local fs_used_text = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "DISK",
    font = beautiful.font_type.mono.." bold 11",
    align = "right",
    valign = "bottom",
    forced_height = 25,
}

awesome.connect_signal("fs::usage", function(percent)
    arc_bundle.set_value(percent)
end)
awesome.connect_signal("fs::used", function(used)
    fs_used_text.markup = (math.floor(used*100)/100).."GB"
end)
awesome.connect_signal("dashboard::show", function()
    awesome.emit_signal("fs::update")
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
                markup = "DSK",
                font = beautiful.font_type.mono.." bold 9",
                valign = "bottom",
                forced_height = 25,
            },
            fs_used_text,
        },
        widget = wibox.container.margin,
        left = 8, right = 8, bottom = 8,
    }
})