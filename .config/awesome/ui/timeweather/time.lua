local config    = require("config")
local awful     = require("awful")
local gears     = require("gears")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local ui         = require("ui.ui_elements")

local styles = {
    normal = {
        shape = rounded_rect(beautiful.popup_roundness),
        bg_color = beautiful.calendar_normal_bg,
        fg_color = beautiful.calendar_normal_fg,
    },
    focus   = {
        bg_color = beautiful.calendar_focus_bg,
        fg_color = beautiful.calendar_focus_fg,
        shape = rounded_rect(beautiful.popup_roundness),
    },
    header = {
        bg_color = beautiful.calendar_header_bg,
        fg_color = beautiful.calendar_header_fg,
    },
    weekday = {
        bg_color = beautiful.calendar_weekday_bg,
        fg_color = beautiful.calendar_weekday_fg,
    },
}

local cal = wibox.widget {
    widget = wibox.widget.calendar.month,
    date = os.date("*t"),
    font = beautiful.font_type.mono,
    spacing = 10,
    flex_height = false,
    long_weekdays = true,
}

local prev_button = ui.create_button_fg("", beautiful.color.surface0, beautiful.color.text, function(_) end, 32, 23, 16)
local next_button = ui.create_button_fg("", beautiful.color.surface0, beautiful.color.text, function(_) end, 32, 23, 16)

local date_selected = nil
local function decorate_cell(widget, flag, date)
    local cur_date = os.date("*t")
    if (cur_date.year ~= date.year or cur_date.month ~= date.month) and flag == "focus" then
        flag = "normal"
    end
    if flag == "header" then
        return wibox.widget {
            {
                layout = wibox.layout.align.horizontal,
                prev_button, widget, next_button
            },
            widget = wibox.container.background,
            bg = styles["header"].bg_color,
        }
    end
    if flag == "monthheader" and not styles.monthheader then
        flag = "header"
    end
    -- allow center alignment
    if flag == "normal" or flag == "focus" then
        widget.text = tostring(tonumber(widget.text))
    end

    widget.align = "center"

    local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
    local weekday = tonumber(os.date('%w', os.time(d)))
    
    local props = styles[flag] or {}
    
    local ret = wibox.widget {
        widget,
        shape = props.shape,
        fg = props.fg_color,
        bg = props.bg_color,
        widget = wibox.container.background,
    }

    local selected = false

    if date_selected and flag == "normal"
       and date.year == date_selected.year
       and date.month == date_selected.month
       and date.day == date_selected.day then
        ret.bg = beautiful.calendar_day_focus_bg
        selected = true
    end

    if flag == "normal" and not selected then
        ret:connect_signal("mouse::enter", function()
            ret.bg = beautiful.calendar_day_hover_bg
        end)
        ret:connect_signal("mouse::leave", function()
            ret.bg = beautiful.calendar_day_normal_bg
        end)
        ret:buttons {awful.button({}, 1, function()
            date_selected = date
            -- force redraw
            cal:set_date(os.date("*t"))
        end)}
    end

    return ret
end
cal.fn_embed = decorate_cell


local function change_month(number)
    local date = cal:get_date()
    cal:set_date(nil)
    date.month = date.month + number
    cal:set_date(date)
end

cal:buttons {
    awful.button({}, 2, function()
        cal:set_date(os.date("*t"))
        date_selected = nil
    end),
    awful.button({}, 4, function() change_month(-1) end),
    awful.button({}, 5, function() change_month( 1) end),
}
prev_button:buttons(awful.button({}, 1, function() change_month(-1) end))
next_button:buttons(awful.button({}, 1, function() change_month( 1) end))

return ui.create_dashboard_panel(wibox.widget {
    {
        wibox.widget {
            layout = wibox.layout.align.horizontal,
            cal,
            v_centered_widget({
                layout = wibox.layout.fixed.vertical,
                wibox.widget {
                    widget = wibox.widget.textclock,
                    format = "%H\n%M",
                    font = beautiful.font_type.mono.." 40",
                    align = "right", valign = "center",
                },
                wibox.widget {
                    widget = wibox.widget.textclock,
                    format = "%B %Y",
                    font = beautiful.font_type.standard.." 12",
                    align = "right", valign = "center",
                },
            }),
        },
        widget = wibox.container.margin,
        right = 5, left = 5,
    },
    widget = wibox.container.margin,
    margins = 4,
})