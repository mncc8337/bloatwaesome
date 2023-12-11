local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local styles = {}

styles.month = {
	bg_color = beautiful.calendar_month_bg,
}

styles.normal = {
	bg_color = beautiful.calendar_normal_bg,
	fg_color = beautiful.calendar_normal_fg,
}

styles.focus   = {
	bg_color = beautiful.calendar_focus_bg,
	fg_color = beautiful.calendar_focus_fg,
}

styles.header = {
	bg_color = beautiful.calendar_header_bg,
}

styles.weekday = {
	fg_color = beautiful.calendar_weekday_fg,
}

local function decorate_cell(widget, flag, date)
	local cur_date = os.date("*t")
	if (cur_date.year ~= date.year or cur_date.month ~= date.month) and flag == "focus" then
		flag = "normal"
	end
	if flag == "header" then
		return wibox.widget {
            widget,
            widget = wibox.container.background,
            bg = styles["header"].bg_color,
            forced_height = 30,
        }
	end
	if flag == "monthheader" and not styles.monthheader then
		flag = "header"
	end
    if flag == "normal" or flag == "focus" then
        widget.text = tostring(tonumber(widget.text))
    end

	widget.align = "center"
    widget.forced_width = (dashboard_width  - 8 - 24 - 60)/7


    local d = {year = date.year, month = (date.month or 1), day = (date.day or 1)}
    local weekday = tonumber(os.date("%w", os.time(d)))
    local default_bg = (weekday == 0 or weekday == 6) and beautiful.calendar_weekday_bg or beautiful.calendar_weekend_bg

    local props = styles[flag] or {}

    local ret = wibox.widget {
        shape = props.shape,
        fg = props.fg_color,
        bg = props.bg_color or default_bg,
        widget = wibox.container.background,
        widget,
    }
    return ret
end
local cal = wibox.widget {
    widget = wibox.widget.calendar.month,
    date = os.date("*t"),
	font = beautiful.font_type.mono,
    spacing = 10,
    flex_height = false,
    long_weekdays = true,
    fn_embed = decorate_cell,
}

local function change_month(number)
	local date = cal:get_date()
	cal:set_date(nil)
	date.month = date.month + number
	cal:set_date(date)
end
cal:buttons {
	awful.button({}, 4, function() change_month(-1) end),
	awful.button({}, 5, function() change_month(1) end)
}

return cal