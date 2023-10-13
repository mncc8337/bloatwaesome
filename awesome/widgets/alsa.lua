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
local popup_placement_config = {
    margins = {
        top = taskbar_size,
        right = beautiful.border_width + 1
    }
}
awful.placement.top_right(volume_slider_popup, popup_placement_config)
local close_popup_timer = gears.timer {
    timeout = 1,
    single_shot = true,
    callback = function()
        volume_slider_popup.visible = false
    end
}
local function show_volume_slider(position, timeout)
    if position == "top right" then
        awful.placement.top_right(volume_slider_popup, popup_placement_config)
    elseif position == "top" then
        awful.placement.top(volume_slider_popup, popup_placement_config)
    end
    close_popup_timer:stop()
    close_popup_timer.timeout = timeout
    volume_slider_popup.visible = true
    close_popup_timer:start()
end
volume_slider_popup.visible = true
volume_slider_popup:connect_signal("mouse::enter", function() close_popup_timer:stop() end)
volume_slider_popup:connect_signal("mouse::leave", function()
    close_popup_timer.timeout = 0.1
    close_popup_timer:again()
end)
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
            show_volume_slider("top right", 0.1)
            close_popup_timer:stop()
        end
    else
        close_popup_timer:stop()
        if volume_slider_popup.visible then volume_slider_popup.visible = false end
        awful.spawn("pavucontrol")
    end
end)))
volumewidget:connect_signal("mouse::enter", function()
    local c = find_client_with_class("Pavucontrol")
    if c then return end

    volume_slider.value = lain_alsa.last.level
    show_volume_slider("top right", 0.1)
    close_popup_timer:stop()
end)
volumewidget:connect_signal("mouse::leave", function()
    close_popup_timer.timeout = 0.1
    close_popup_timer:start()
end)

local function add_volume_level(num)
    local sign = ''
    if num > 0 then sign = '+' else sign = '-' end
    awful.spawn.easy_async("pactl set-sink-volume "..alsa_device..' '..sign..math.abs(num)..'%', function() lain_alsa.update() end)
    volume_slider.value = lain_alsa.last.level + num
    show_volume_slider("top", 1.5)
end
local function toggle_mute()
    awful.spawn.easy_async("pactl set-sink-mute "..alsa_device.." toggle", function() lain_alsa.update() end)
    show_volume_slider("top", 1.5)
end

return {
    volumewidget = volumewidget,
    add_volume_level = add_volume_level,
    toggle_mute = toggle_mute,
}