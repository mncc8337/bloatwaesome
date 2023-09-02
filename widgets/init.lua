local _separator = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    shape = gears.shape.rounded_rect,
    color = color_surface0,
    forced_height = 18,
    forced_width = 4,
}
local separator = wibox.widget {
    widget = wibox.container.margin,
    left = 3, right = 3,
    _separator
}
separator = v_centered_widget(separator)

widget_spacing = 10

-- require("widgets.mpd")
-- require("widgets.mem")
-- require("widgets.cpu")
-- require("widgets.temperature")
-- require("widgets.weather")
-- require("widgets.alsa")
-- require("widgets.focused_client_name")

local musicwidget
if music_player == "mpd" then
    musicwidget = require("widgets.mpd")
elseif music_player == "playerctl" then
    musicwidget = require("widgets.playerctl")
end

return {
    separator = separator,
    musicwidget = musicwidget,
    memwidget = require("widgets.mem"),
    cpuwidget = require("widgets.cpu"),
    tempwidget = require("widgets.temperature"),
    weatherwidget = require("widgets.weather"),
    alsa = require("widgets.alsa"),
    focused_client = require("widgets.focused_client_name"),
}

-- Keyboard map indicator and switcher
--mykeyboardlayout = awful.widget.keyboardlayout()

--[[
bling.widget.window_switcher.enable {
    type = "thumbnail",
    hide_window_switcher_key = "Escape",
    minimize_key = "n",
    unminimize_key = "N",
    kill_client_key = "q",
    cycle_key = "Tab",
    previous_key = "Right",
    next_key = "Left",
    vim_previous_key = "l",
    vim_next_key = "h",
    cycleClientsByIdx = awful.client.focus.byidx,
    filterClients = awful.widget.tasklist.filter.currenttags,
}
]]--