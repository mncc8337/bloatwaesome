local awful        = require("awful")
local beautiful    = require("beautiful")
local wibox        = require("wibox")

local ui           = require("dashboard.ui_elements")

local calendar_tab = require("dashboard.tabs.calendar")
local weather_tab  = require("dashboard.tabs.weather")
local todo_tab     = require("dashboard.tabs.todo-list")


local calbutton = ui.create_tab_button("󰸗", "calendar", calendar_tab)
local wtbutton = ui.create_tab_button("󰅟", "weather", weather_tab)
local tdbutton = ui.create_tab_button("", "todo-list", todo_tab)

local buttons = wibox.widget {
    h_centered_widget({
        layout = wibox.layout.fixed.horizontal,
        spacing = 12,
        calbutton.button,
        wtbutton.button,
        tdbutton.button,
    }),
    widget = wibox.container.margin,
    margins  = 5,
}
local layout = wibox.layout.align.vertical(wibox.widget {}, cal, buttons)

local scrollable = ui.h_scrollable({calendar_tab, weather_tab, todo_tab},
                                   dashboard_width - 16, awful.screen.focused().geometry.height - 715,
                                   {top = 12, bottom = 5, left = 12, right = 12})
layout:set_second(scrollable.widget)

-- load config
local config = read_json(awesome_dir.."config.json")

awesome.connect_signal("dashboard::change_tab", function(name)
    config["dashboard"]["last_panel"] = name
    save_json(config, awesome_dir.."config.json")
end)

-- load first tab on start
if config["dashboard"]["last_panel"] == "calendar" then
    calbutton.set_active()
    scrollable.scroll_to(1)
elseif config["dashboard"]["last_panel"] == "weather" then
    wtbutton.set_active()
    scrollable.scroll_to(2)
elseif config["dashboard"]["last_panel"] == "todo-list" then
    tdbutton.set_active()
    scrollable.scroll_to(3)
-- more here
end

calbutton.set_action(function() scrollable.scroll_to(1) end)
wtbutton.set_action(function() scrollable.scroll_to(2) end)
tdbutton.set_action(function() scrollable.scroll_to(3) end)

local pan = wibox.widget {layout = layout}
pan.forced_height = awful.screen.focused().geometry.height - 665

return ui.create_dashboard_panel(pan)