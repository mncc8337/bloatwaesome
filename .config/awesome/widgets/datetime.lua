local datetimewidget = wibox.widget {
    widget = wibox.widget.textclock
}
local calendar = awful.widget.calendar_popup.month {
    -- week_numbers = true,
    long_weekdays = true,
    spacing = 0,
    style_month = {
        border_color = beautiful.border_focus,
    },
    style_header = {
        fg_color = color_blue,
        markup = function(t) return "<i>"..t.."</i>" end,
        border_width = 0,
    },
    style_weekday = {
        fg_color = color_lavender,
        border_width = 0,
    },
    style_normal = {
        fg_color = color_subtext0,
        border_width = 0,
    },
    style_focus = {
        fg_color = color_green,
        bg_color = color_base,
        border_width = 0,
    },
}
local tooltip = awful.tooltip {
    objects        = {datetimewidget},
    timeout = 1,
    timer_function = function()
        return os.date("%A %B %d %Y, %T")
    end,
}
calendar:attach(datetimewidget, "tc", {on_hover = false})
calendar:connect_signal("property::visible", function()
    if calendar.visible then
        tooltip:remove_from_object(datetimewidget)
        tooltip.visible = false
    else
        tooltip:add_to_object(datetimewidget)
    end
end)

return datetimewidget