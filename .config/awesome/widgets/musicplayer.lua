-- NOTE
--[[
    The progress bar needs patch (hasnt been merged yet)
    https://github.com/awesomeWM/awesome/pull/2773/files
    in order to set the media position.
    If you cant apply this patch please set the variable
    below to `false`, otherwise set it to `true`.
]]--
local patched_awesome = true

---- signals
--[[
    signal name                 arguments       note

                            --<< player calls >>--
    music::volume_changed       value
    music::position_changed     position

    music::play_previous_song
    music::play_next_song

    music::play_song
    music::pause_song

    music::shuffle_on
    music::shuffle_off

    music::loop_playlist
    music::loop_track
    music::no_loop

                            --<< client calls >>--
    music::show_player          near_mouse      true/false
    music::hide_player
    music::refreshUI                            update UI elements

    music::set_cover            path_to_file
    music::set_title            title
    music::set_detail           detail
    music::set_elapsed_time     time            alsa update player progressbar
    music::set_total_time       time
    music::set_volume           volume
]]--

local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

---- global variables
local status = {
    player_paused = false,
    shuffle = false,
    loop_playlist = false,
    loop_track = false,
    no_loop = false,
}
local time = {
    -- updating = false,
    elapsed = 0,
    total = 100
}
local function timeformat(t)
    decor = ''
    second = math.floor(t % 60)
    if second < 10 then decor = '0' end
    minute = math.floor((t - second)/60)
    return minute..':'..decor..second
end

---- slider
local music_progressbar = wibox.widget.slider {
    bar_height = 3,
    forced_width = 1,
    forced_height = 14,
    bar_shape = gears.shape.rounded_rect,
    bar_active_color = color_blue,
    bar_color = color_surface0,
    handle_width = 0, -- no handle
    maximum = 100,
    minimum = 0,
    value = 75,
}
local text_time_elapsed = wibox.widget.textbox("N/A")
text_time_elapsed.font = beautiful.font_standard.." Bold 11"
text_time_elapsed.valign = "top"
local text_time_total = wibox.widget.textbox("N/A")
text_time_total.font = beautiful.font_standard.." Bold 11"
text_time_total.valign = "top"

if patched_awesome then
    music_progressbar:connect_signal("button::press", function()
        time.updating = true
    end)
    music_progressbar:connect_signal("button::release", function()
        awesome.emit_signal("music::position_changed", music_progressbar.value)
        time.updating = false
    end)
end

-- update the time when sliding
music_progressbar:connect_signal("property::value", function()
    if time.updating then
        local tm = math.floor(time.total * music_progressbar.value / 100 + 0.5)
        text_time_elapsed.text = timeformat(tm)
    end
end)

-- volume slider
local volume_slider = wibox.widget.slider {
    bar_height = 4,
    forced_width = 1,
    forced_height = 14,
    bar_active_color = color_blue,
    bar_color = color_surface0,
    handle_width = 0, -- no handle
    maximum = 100,
    minimum = 0,
    value = 75,
}

volume_slider:connect_signal("property::value", function()
    awesome.emit_signal("music::volume_changed", volume_slider.value)
end)

---- song info and art
local song_title = wibox.widget.textbox("No song")
song_title.font = beautiful.font_standard.." bold 18"
local song_detail = wibox.widget.textbox("hehe")
song_detail.font = beautiful.font_standard.." 12"
local coverico = wibox.widget.imagebox()
coverico.clip_shape = rounded_rect(5)
coverico.forced_height = 120

local function ui_button_create(icon, width, normal_color, focus_color, action, font_size, align)
    -- font_size and align are optional
    -- action must have only 1 arg which is the textbox

    local button  = wibox.widget.textbox(icon)
    button.font   = beautiful.font_icon..' '.. (font_size or 20)
    button.align  = align or "center"
    button.valign = "center"
    button.forced_width  = width

    local buttonw = wibox.widget {
        button,
        fg = normal_color,
        widget = wibox.container.background
    }

    button:connect_signal("mouse::enter", function() buttonw.fg = focus_color end)
    button:connect_signal("mouse::leave", function() buttonw.fg = normal_color end)
    button:buttons {awful.button({}, 1, function()
        action(button)
    end)}

    return buttonw
end

-- music player
local recheck_delay = 0.3

local function toggle_press(w)
    if status.player_paused then
        w.text = "󰏤"
        awesome.emit_signal("music::play_song")
    else
        w.text = "󰐊"
        awesome.emit_signal("music::pause_song")
    end
    single_timer(recheck_delay, function()
        if status.player_paused then
            w.text = "󰐊"
        else
            w.text = "󰏤"
        end
    end):start()
end
local togglebutton = ui_button_create("󰐊", 42, color_surface2, color_text, toggle_press, 24)

local function refresh_toggle_button()
    if status.player_paused then
        togglebutton.widget.text = "󰐊"
    else
        togglebutton.widget.text = "󰏤"
    end
end

local function prev_press(_)
    togglebutton.widget.text = "󰏤"
    awesome.emit_signal("music::play_previous_song")
    single_timer(recheck_delay, refresh_toggle_button):start()
end
local prevbutton = ui_button_create("󰒮", 22, color_surface2, color_text, prev_press, _, "right")

local function next_press(_)
    togglebutton.widget.text = "󰏤"
    awesome.emit_signal("music::play_next_song")
    single_timer(recheck_delay, refresh_toggle_button):start()
end
local nextbutton = ui_button_create("󰒭", 22, color_surface2, color_text, next_press, _, "left")

local function shuffle_press(w)
    if status.shuffle then
        w.text = "󰒞"
        awesome.emit_signal("music::shuffle_off")
    else
        w.text = "󰒝"
        awesome.emit_signal("music::shuffle_on")
    end
    single_timer(recheck_delay, function()
        if status.shuffle then
            w.text = "󰒝"
        else
            w.text = "󰒞"
        end
    end):start()
end
local shufflebutton = ui_button_create("󰒞", 22, color_surface0, color_text, shuffle_press)

local function loop_press(w)
    if status.no_loop then
        w.text = "󰑖"
        awesome.emit_signal("music::loop_playlist")
    elseif status.loop_playlist then
        w.text = "󰑘"
        awesome.emit_signal("music::loop_track")
    else
        w.text = "󰑗"
        awesome.emit_signal("music::no_loop")
    end
    single_timer(recheck_delay, function()
        if status.no_loop then
            w.text = "󰑗"
        elseif status.loop_playlist then
            w.text = "󰑖"
        elseif status.loop_track then
            w.text = "󰑘"
        end
    end):start()
end
local loopbutton = ui_button_create("󰑖", 22, color_surface0, color_text, loop_press)

local buttons = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    spacing = 10,
    loopbutton,
    {
        layout = wibox.layout.fixed.horizontal,
        prevbutton,
        togglebutton,
        nextbutton,
    },
    shufflebutton,
    forced_height = 35
}

local music_player_widget = wibox.widget {
    layout = wibox.layout.align.horizontal,
    {
        coverico,
        widget = wibox.container.margin,
        margins = 12,
    },
    {
        {
            layout = wibox.layout.fixed.vertical,
            {
                layout = wibox.layout.scroll.horizontal,
                step_function = wibox.container.scroll.step_functions.linear_increase,
                max_size = 300,
                extra_space = 300,
                speed = 30,
                song_title,
            },
            song_detail,
            music_progressbar,
            {
                layout = wibox.layout.align.horizontal,
                text_time_elapsed,
                h_centered_widget(buttons),
                text_time_total,
            },
        },
        widget = wibox.container.margin,
        right = 5, top = 15,
    },
    {
        {
            volume_slider,
            widget = wibox.container.margin,
            right = 10, left = 10,
        },
        widget = wibox.container.rotate,
        direction = "east",
    }
}

local music_player_popup = awful.popup {
    ontop = true,
    visible = false,
    type = "dock",
    maximum_height = 172,
    -- width = 450,
    shape = rounded_rect(beautiful.round_corner_radius),
    border_color = beautiful.border_focus,
    border_width = beautiful.border_width,
    widget = music_player_widget,
}

local music_player_timer = single_timer(0.1, function()
    music_player_popup.visible = false
end)

music_player_popup:connect_signal("mouse::enter", function() music_player_timer:stop()  end)
music_player_popup:connect_signal("mouse::leave", function() music_player_timer:again() end)

awesome.connect_signal("music::refreshUI", function()
    refresh_toggle_button()

    if status.shuffle then
        shufflebutton.widget.text = "󰒝"
    else
        shufflebutton.widget.text = "󰒞"
    end

    if status.no_loop then
        loopbutton.widget.text = "󰑗"
    elseif status.loop_playlist then
        loopbutton.widget.text = "󰑖"
    elseif status.loop_track then
        loopbutton.widget.text = "󰑘"
    end
end)
awesome.connect_signal("music::show_player", function(near_mouse)
    if dashboard_visible() then return end
    awesome.emit_signal("music::refreshUI")
    music_player_timer:stop()
    music_player_popup.visible = true
    if near_mouse then
        music_player_popup:move_next_to(mouse.current_widget_geometry)
    end
end)
awesome.connect_signal("music::hide_player", function()
    music_player_timer:again()
end)
awesome.connect_signal("music::set_cover", function(path)
    coverico.image = gears.surface.load_uncached(path)
end)
awesome.connect_signal("music::set_title", function(_title)
    song_title:set_markup(_title)
end)
awesome.connect_signal("music::set_detail", function(_detail)
    song_detail:set_markup(_detail)
end)
awesome.connect_signal("music::set_elapsed_time", function(_time)
    if not time.updating then
        time.elapsed = _time
        local formatted = timeformat(_time)
        text_time_elapsed.text = formatted

        -- also update the slider
        music_progressbar:set_value(time.elapsed / time.total * 100)
    end
end)
awesome.connect_signal("music::set_total_time", function(_time)
    if not time.updating then
        time.total = _time
        local formatted = timeformat(_time)
        text_time_total.text = formatted
    end
end)
awesome.connect_signal("music::set_volume", function(val)
    volume_slider.value = val
end)
local function is_visible()
    return music_player.visible
end

awesome.emit_signal("music::set_cover", awesome_dir.."/fallback.png")

return {
    widget = music_player_widget,
    status = status,
    is_visible = is_visible,
}