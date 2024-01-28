local beautiful = require("beautiful")
local wibox     = require("wibox")

local markup = require("lain").util.markup

local ui = require("ui.ui_elements")

-- local arc_bundle = ui.create_arcchart("", beautiful.temp_icon_color)

local temp_text = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "100%",
    font = beautiful.font_type.mono.." bold 11",
    align = "right",
    valign = "bottom",
    forced_height = 25,
}

local temp_icon = wibox.widget {
    widget = wibox.widget.textbox,
    forced_width = ui.arc_size,
    forced_height = ui.arc_size,
    -- markup = markup.fg.color(beautiful.temp_icon_color, ""),
    font = beautiful.font_type.mono.." 54",
    align = "center",
}

awesome.connect_signal("widget::temperature", function(temp)
    temp = tonumber(temp)

    local icon
    if temp < 40.0 then
        icon = "󰜗"
    elseif temp < 50.0 then
        icon = ""
    elseif temp < 60.0 then
        icon = ""
    elseif temp < 70.0 then
        icon = ""
    elseif temp < 80.0 then
        icon = ""
    elseif temp < 90.0 then
        icon = ""
    else
        icon = "󱗗"
    end

    temp_icon.markup = markup.fg.color(beautiful.temp_icon_color, icon)
    temp_text.markup = temp..'°C'
end)

return ui.create_dashboard_panel(wibox.widget {
    layout = wibox.layout.align.vertical,
    {
        temp_icon,
        widget = wibox.container.margin,
        top = 8, left = 8, right = 8, bottom = 5,
    },
    {
        {
            layout = wibox.layout.align.horizontal,
            wibox.widget {
                widget = wibox.widget.textbox,
                markup = "THRM",
                font = beautiful.font_type.mono.." bold 9",
                valign = "bottom",
                forced_height = 25,
            },
            temp_text,
        },
        widget = wibox.container.margin,
        left = 8, right = 8, bottom = 8,
    }
})