-- signals
--[[
    alsa::increase_volume_level, level
    alsa::toggle_mute
]]--
local config    = require("config")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local rubato    = require("modules.rubato")

local volumeico = wibox.widget.textbox()
volumeico.font = beautiful.font_type.icon.." 16"

local alsawidget = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "<b>N/A</b>"
}

local slider_hiding = false
local volume_level = 0
local muted = false

local function update_icon(vol)
    if muted then
        volumeico.markup = '󰝟 '
        return
    end

    if vol <= 25 then
        volumeico.markup = '󰕿 '
    elseif vol <= 75 then
        volumeico.markup = '󰖀 '
    else
        volumeico.markup = '󰕾 '
    end
end
awesome.connect_signal("alsa::avg", function(vol)
    volume_level = vol
    update_icon(vol)

    alsawidget.markup = "<b>"..vol..'%'.."</b>"

    if not slider_hiding then
        alsawidget.forced_width = alsawidget:get_preferred_size()
    end
end)
awesome.connect_signal("alsa::mute", function(_muted)
    muted = _muted
    update_icon(volume_level)
end)

local function update_widget()
    awesome.emit_signal("alsa::update")
end

volumeico:buttons {awful.button({}, 1, function()
    awful.spawn.easy_async("amixer sset "..config.alsa_channel.." toggle", update_widget)
end)}

local _volume_slider = wibox.widget {
    bar_height   = 10,
    bar_color    = beautiful.volumebar_bg,
    bar_active_color = beautiful.volumebar_fg,
    handle_width  = 0,
    minimum       = 0,
    maximum       = 100,
    value         = 75,
    forced_width  = 300,
    forced_height = 50,
    widget        = wibox.widget.slider,
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

volume_slider_popup:connect_signal("mouse::enter", function() close_popup_timer:stop() end)
volume_slider_popup:connect_signal("mouse::leave", function()
    close_popup_timer.timeout = 0.1
    close_popup_timer:again()
end)
local finish_update_volume = true
local function slide_update_volume(slider)
    if not finish_update_volume then return end
    finish_update_volume = false
    awful.spawn.easy_async("amixer sset "..config.alsa_channel..' '..slider.value..'%', function()
        update_widget()
        finish_update_volume = true
    end)
end
_volume_slider:connect_signal("property::value", slide_update_volume)

-- mini slider shows when hover volumewidget
local mini_slider = wibox.widget {
    bar_height   = 3,
    bar_color    = beautiful.volumebar_bg,
    bar_active_color = beautiful.volumebar_fg,
    -- handle_color = color_base,
    -- handle_shape = gears.shape.circle,
    -- handle_border_color = color_blue,
    -- handle_border_width = 2,
    handle_width  = 0,
    minimum       = 0,
    maximum       = 100,
    value         = 75,
    forced_width  = config.mini_volume_slider_length,
    forced_height = 50,
    widget        = wibox.widget.slider,
}
mini_slider:connect_signal("property::value", slide_update_volume)

local mini_slider_anim = rubato.timed {
    duration = 0.3,
    intro = 0.15,
    override_dt = true,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        mini_slider.forced_width = pos
        alsawidget.forced_width = (1.0 - pos/config.mini_volume_slider_length) * alsawidget:get_preferred_size()
    end
}

local volumewidget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    volumeico,
    alsawidget,
    mini_slider,
}
volumewidget:connect_signal("mouse::enter", function()
    mini_slider.value = volume_level
    mini_slider_anim.target = config.mini_volume_slider_length
    slider_hiding = true
end)
volumewidget:connect_signal("mouse::leave", function()
    _volume_slider.value = volume_level
    mini_slider_anim.target = 0
    slider_hiding = false
    update_widget()
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

awesome.connect_signal("alsa::increase_volume_level", function(num)
    local sign = '+'
    if num < 0 then sign = '-' end

    awful.spawn.easy_async("amixer sset "..config.alsa_channel..' '..math.abs(num)..'%'..sign, update_widget)
    _volume_slider.value = volume_level + num
    show_volume_slider("top", 2)
end)
awesome.connect_signal("alsa::toggle_mute", function()
    awful.spawn.easy_async("amixer sset "..config.alsa_channel.." toggle", update_widget)
    show_volume_slider("top", 2)
end)

awesome.connect_signal("dashboard::show", function()
     _volume_slider.value = volume_level
end)

return {
    volumewidget = volumewidget,
    volume_slider = volume_slider,
}