local lain = require("lain")
local markup = lain.util.markup

local volumeico = markup.fg.color(color_text, "󰕾  ") -- 󰕿 󰖀 󰖁 󰝟
local volico = wibox.widget.textbox()
local lain_alsa = lain.widget.alsa {
    timeout = 2,
    settings = function()
        local volume_level = volume_now.level
        local current_vol_ico = ""
        if volume_level <= 25 then
            current_vol_ico = "󰕿  "
            volico.markup = '󰕿 '
        elseif volume_level <= 75 then
            current_vol_ico = "󰖀  "
            volico.markup = '󰖀 '
        else
            current_vol_ico = "󰕾  "
            volico.markup = '󰕾 '
        end

        if volume_now.status == "off" then
            volumeico = markup.fg.color(color_text, "󰝟  ")
            volico.markup = '󰝟 '
        else
            volumeico = markup.fg.color(color_text, current_vol_ico)
        end
        widget:set_markup(volumeico..volume_now.level.."%")
    end
}
lain_alsa.widget.align = "center"
lain_alsa.update()

local volume_slider = wibox.widget {
    bar_shape    = gears.shape.rounded_rect,
    bar_height   = 3,
    bar_color    = color_surface2,
    bar_active_color = color_blue,
    handle_color = color_base,
    handle_shape = gears.shape.circle,
    handle_border_color = color_blue,
    handle_border_width = 2,
    handle_width = 15,
    minimum      = 0,
    maximum      = 100,
    value        = 75,
    forced_width = 300,
    widget       = wibox.widget.slider,
}
local volume_slider_popup = awful.popup {
    ontop = true,
    y = taskbar_size,
    visible = false,
    --maximum_width = 220,
    maximum_height = 50,
    border_color = beautiful.border_focus,
    border_width = beautiful.border_width,
    widget = wibox.widget {
        {
            layout = wibox.layout.align.horizontal,
            volico,
            volume_slider,
        },
        widget = wibox.container.margin,
        right = 10, left = 10,
    }
}
local volume_slider_timer = gears.timer {
    timeout = 0.1,
    single_shot = true,
    callback = function()
        volume_slider_popup.visible = false
    end
}
local volume_button_triggered_timer = gears.timer {
    timeout = 1.5,
    single_shot = true,
    callback = function()
        volume_slider_popup.visible = false
    end
}
volume_slider_popup:connect_signal("mouse::enter", function() volume_slider_timer:stop() end)
volume_slider_popup:connect_signal("mouse::leave", function() volume_slider_timer:again() end)
local finish_update_volume = true
volume_slider:connect_signal("property::value", function()
    if not finish_update_volume then return end
    finish_update_volume = false
    awful.spawn.easy_async("pactl set-sink-volume "..alsa_device..' '..volume_slider.value..'%', function()
        lain_alsa.update()
        finish_update_volume = true
    end)
end)

local volumewidget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    lain_alsa
}
volumewidget:buttons(gears.table.join(awful.button({ }, 3, function()
    local c = find_client_with_class("Pavucontrol")
    if c then
        c:kill()
        if mouse.current_widget == lain_alsa.widget then
            volume_slider_popup.visible = true
        end
    else
        if volume_slider_popup.visible then volume_slider_popup.visible = false end
        awful.spawn("pavucontrol")
    end
end)))
volumewidget:connect_signal("mouse::enter", function()
    local c = find_client_with_class("Pavucontrol")
    if c then return end

    volume_slider_timer:stop()
    volume_slider.value = lain_alsa.last.level
    volume_slider_popup.visible = true
    --volume_slider_popup:move_next_to(mouse.current_widget_geometry)
end)
volumewidget:connect_signal("mouse::leave", function() volume_slider_timer:again() end)

return {
    lain_alsa = lain_alsa,
    volumewidget = volumewidget,
    volume_slider = volume_slider,
    volume_slider_popup = volume_slider_popup,
    volume_button_triggered_timer = volume_button_triggered_timer,
}