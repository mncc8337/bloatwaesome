-- signals
--[[
    alsa::increase_volume_level, level
    alsa::toggle_mute
    alsa::show_volume_control, top or top_right, timeout

    alsa::volume_mute, true or false
]]--
local config       = require("config")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local rubato    = require("modules.rubato")

local lain      = require("lain")
local markup    = lain.util.markup

local volume_level = 0

local volumeico = wibox.widget.textbox()
volumeico.font = beautiful.font_type.icon.." 16"

local prev_status = "off"
local alsa_hiding = false
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
            awesome.emit_signal("alsa::volume_mute", status)
        end
        prev_status = volume_now.status

        widget.markup = markup.bold(volume_now.level..'%')
        volume_level = volume_now.level

        if not alsa_hiding then
            widget.forced_width = widget:get_preferred_size()
        end
    end
}
lain_alsa.widget.align = "center"
lain_alsa.update()

volumeico:buttons {awful.button({}, 1, function()
    awful.spawn.easy_async("pactl set-sink-mute "..config.alsa_device.." toggle", lain_alsa.update)
end)}

local _volume_slider = wibox.widget {
    bar_height   = 10,
    bar_color    = beautiful.volumebar_bg,
    bar_active_color = beautiful.volumebar_fg,
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
    shape = rounded_rect(beautiful.popup_roundness),
}
local popup_placement_config = {
    margins = {
        top = config.bar_size + (config.floating_bar and 10 or 0),
        right = (config.floating_bar and beautiful.useless_gap * 2 or 0)
    }
}
local close_popup_timer = single_timer(1, function()
    volume_slider_popup.visible = false
end)
local function show_volume_slider(position, timeout)
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
local function slide_update_volume(s)
    if not finish_update_volume then return end
    finish_update_volume = false
    awful.spawn.easy_async("pactl set-sink-volume "..config.alsa_device..' '..s.value..'%', function()
        if lain_alsa.widget.forced_width ~= 0 then
            lain_alsa.update()
        end
        finish_update_volume = true
    end)
end
_volume_slider:connect_signal("property::value", slide_update_volume)
_volume_slider:connect_signal("property::value", slide_update_volume)

-- mini slider shows when hover volumewidget
local slid = wibox.widget {
    bar_height   = 3,
    bar_color    = beautiful.volumebar_bg,
    bar_active_color = beautiful.volumebar_fg,
    -- handle_color = color_base,
    -- handle_shape = gears.shape.circle,
    -- handle_border_color = color_blue,
    -- handle_border_width = 2,
    handle_width = 0,
    minimum      = 0,
    maximum      = 100,
    value        = 75,
    forced_width = 80,
    forced_height = 50,
    widget       = wibox.widget.slider,
}
slid:connect_signal("property::value", slide_update_volume)
local slid_anim = rubato.timed {
    duration = 0.3,
    intro = 0.15,
    override_dt = true,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        slid.forced_width = pos
        lain_alsa.widget.forced_width = (1.0 - pos/80.0) * lain_alsa.widget:get_preferred_size()
    end
}

local volumewidget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    volumeico,
    lain_alsa,
    slid,
}
volumewidget:connect_signal("mouse::enter", function()
    slid.value = lain_alsa.last.level
    slid_anim.target = 80
    alsa_hiding = true
end)
volumewidget:connect_signal("mouse::leave", function()
    _volume_slider.value = lain_alsa.last.level
    slid_anim.target = 0
    alsa_hiding = false
    lain_alsa.update()
end)

awesome.connect_signal("alsa::increase_volume_level", function(num)
    local sign = ''
    if num > 0 then sign = '+' else sign = '-' end
    awful.spawn.easy_async("pactl set-sink-volume "..config.alsa_device..' '..sign..math.abs(num)..'%', lain_alsa.update)
    _volume_slider.value = lain_alsa.last.level + num
    show_volume_slider("top", 1.5)
end)
awesome.connect_signal("alsa::toggle_mute", function()
    awful.spawn.easy_async("pactl set-sink-mute "..config.alsa_device.." toggle", lain_alsa.update)
    show_volume_slider("top", 1.5)
end)
awesome.connect_signal("alsa::show_volume_control", function(pos, timeout)
    show_volume_slider(pos, timeout)
end)
awesome.connect_signal("alsa::hide_volume_control", function(pos, timeout)
    close_popup_timer:stop()
    volume_slider_popup.visible = false
end)

awesome.connect_signal("dashboard::show", function()
     _volume_slider.value = lain_alsa.last.level
end)

return {
    volumewidget = volumewidget,
    volume_slider = volume_slider,
}