local beautiful = require("beautiful")
local wibox     = require("wibox")

local lain = require("lain")

local ui = require("dashboard.ui_elements")

local chart_bundle = ui.create_arcchart("󰋊", color_maroon, color_crust)

local fs_chart = chart_bundle.arc
local lain_fs = lain.widget.fs {
    timeout = 600,
    showpopup = "off",
    settings = function()
        chart_bundle.set_value(fs_now["/"].percentage)
                                                                -- units correction
        widget:set_markup((math.floor(fs_now["/"].used*100)/100)..string.gsub(fs_now["/"].units, 'b', 'iB'))
    end
}
lain_fs.align = "right"
lain_fs.font = beautiful.font_mono.." bold 12"
lain_fs.valign = "bottom"
lain_fs.forced_height = 25
awesome.connect_signal("dashboard::show", lain_fs.update)

return ui.create_dashboard_panel(wibox.widget {
    layout = wibox.layout.align.vertical,
    {
        fs_chart,
        widget = wibox.container.margin,
        top = 8, left = 8, right = 8, bottom = 5,
    },
    {
        {
            layout = wibox.layout.align.horizontal,
            wibox.widget {
                widget = wibox.widget.textbox,
                markup = "DISK",
                font = beautiful.font_mono.." bold 10",
                valign = "bottom",
                forced_height = 25,
            },
            lain_fs,
        },
        widget = wibox.container.margin,
        left = 8, right = 8, bottom = 8,
    }
})