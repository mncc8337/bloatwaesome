-- signals
--[[
    widget::increase_volume_level, level
    widget::toggle_mute
    widget::show_volume_control, top or top_right, timeout

    widget::volume_mute, true or false
]]--

local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local lain      = require("lain")
local markup    = lain.util.markup

local volume_level = 0

local volumeico = wibox.widget.textbox()
volumeico.font = beautiful.font_icon.." 16"

local prev_status = "off"
local lain_alsa = lain.widget.alsa {
    timeout = 2,
    settings = function()
        local volume_level = volume_now.level
        if volume_level <= 25 then
            volumeico.markup = '󰕿 '
        elseif volume_level <= 75 then
            volumeico.markup = '󰖀 '
        else
            volumeico.markup = '󰕾 '
        end

        if volume_now.status == "off" then
            volumeico.markup = '󰝟 '
        end

        if prev_status ~= volume_now.status then
            local status = volume_now.status == "off"
            awesome.emit_signal("widget::volume_mute", status)
        end
        prev_status = volume_now.status

        widget.markup = markup.bold(volume_now.level..'%')
        volume_level = volume_now.level
    end
}
lain_alsa.widget.align = "center"
lain_alsa.update()

local _volume_slider = wibox.widget {
    bar_height   = 10,
    bar_color    = color_crust,
    bar_active_color = color_blue,
    -- handle_color = color_base,
    -- handle_shape = gears.shape.circle,
    -- handle_border_color = color_blue,
    -- handle_border_width = 2,
    handle_width = 0,
    minimum      = 0,
    maximum      = 100,
    value        = 75,
    forced_width = 300,
    forced_height = 50,
    widget       = wibox.widget.slider,
}
local volume_slider = wibox.widget {
    {
        layout = wibox.layout.align.horizontal,
        volumeico,
        _volume_slider,
    },
    widget = wibox.container.margin,
    right = 10, left = 10,
}
local volume_slider_popup = wibox {
    ontop = true,
    visible = false,
    type = "dock",
    width = 350,
    height = 50,
    border_color = beautiful.border_focus,
    border_width = beautiful.border_width,
    widget = volume_slider,
}
local popup_placement_config = {
    margins = {
        top = taskbar_size,
        right = beautiful.border_width + 1
    }
}
local close_popup_timer = single_timer(1, function()
    volume_slider_popup.visible = false
end)
local function show_volume_slider(position, timeout)
    if dashboard_visible() then return end
    if position == "top_right" then
        awful.placement.top_right(volume_slider_popup, popup_placement_config)
    elseif position == "top" then
        awful.placement.top(volume_slider_popup, popup_placement_config)
    end
    close_popup_timer:stop()
    close_popup_timer.timeout = timeout
    volume_slider_popup.visible = true
    close_popup_timer:start()
end
volume_slider_popup:connect_signal("mouse::enter", function() close_popup_timer:stop() end)
volume_slider_popup:connect_signal("mouse::leave", function()
    close_popup_timer.timeout = 0.1
    close_popup_timer:again()
end)
local finish_update_volume = true
_volume_slider:connect_signal("property::value", function()
    if not finish_update_volume then return end
    finish_update_volume = false
    awful.spawn.easy_async("pactl set-sink-volume "..alsa_device..' '.._volume_slider.value..'%', function()
        lain_alsa.update()
        finish_update_volume = true
    end)
end)

local volumewidget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    volumeico,
    lain_alsa,
}
volumewidget:buttons {awful.button({ }, 3, function()
    local c = find_client({class = "Pavucontrol"})
    if c then
        c:kill()
        if mouse.current_widget == lain_alsa.widget then
            show_volume_slider("top_right", 0.1)
            close_popup_timer:stop()
        end
    else
        close_popup_timer:stop()
        if volume_slider_popup.visible then volume_slider_popup.visible = false end
        awful.spawn("pavucontrol")
    end
end)}
volumewidget:connect_signal("mouse::enter", function()
    local c = find_client({class = "Pavucontrol"})
    if c then return end

    _volume_slider.value = lain_alsa.last.level
    show_volume_slider("top_right", 0.1)
    close_popup_timer:stop()
end)
volumewidget:connect_signal("mouse::leave", function()
    close_popup_timer.timeout = 0.1
    close_popup_timer:start()
end)

awesome.connect_signal("widget::increase_volume_level", function(num)
    local sign = ''
    if num > 0 then sign = '+' else sign = '-' end
    awful.spawn.easy_async("pactl set-sink-volume "..alsa_device..' '..sign..math.abs(num)..'%', function() lain_alsa.update() end)
    _volume_slider.value = lain_alsa.last.level + num
    show_volume_slider("top", 1.5)
end)
awesome.connect_signal("widget::toggle_mute", function()
    awful.spawn.easy_async("pactl set-sink-mute "..alsa_device.." toggle", function() lain_alsa.update() end)
    show_volume_slider("top", 1.5)
end)
awesome.connect_signal("widget::show_volume_control", function(pos, timeout)
    show_volume_slider(pos, timeout)
end)
awesome.connect_signal("widget::hide_volume_control", function(pos, timeout)
    close_popup_timer:stop()
    volume_slider_popup.visible = false
end)

return {
    volumewidget = volumewidget,
    volume_slider = volume_slider,
}