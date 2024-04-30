---- signals
--[[
    signal name                 argument        note

                            --<< player calls >>--
    music::volume_changed       value
    music::position_changed     position

    music::play_previous_song
    music::play_next_song

    music::play
    music::pause
    music::toggle

    music::shuffle_on
    music::shuffle_off

    music::loop_playlist
    music::loop_track
    music::no_loop

                            --<< client calls >>--
    music::refreshUI                            update UI elements

    music::set_cover            path_to_file
    music::set_title            title
    music::set_detail           detail
    music::set_elapsed_time     time            also update player progressbar
    music::set_total_time       time
    music::set_volume           volume
]]--

local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local ui        = require("ui.ui_elements")

local awesome_dir = gears.filesystem.get_configuration_dir()

local status = {
    player_paused = false,
    shuffle       = false,
    loop_playlist = false,
    loop_track    = false,
    no_loop       = false,
}

local time = {
    elapsed = 0,
    total   = 100
}
local function timeformat(t)
    decor = ''
    second = math.floor(t % 60)
    if second < 10 then decor = '0' end
    minute = math.floor((t - second)/60)
    return minute..':'..decor..second
end

local music_progressbar = wibox.widget {
    widget = wibox.widget.progressbar,
    forced_width = 1,
    forced_height = 14,
    margins = {
        top = 5,
        bottom = 5,
    },
    color = beautiful.music_progressbar_fg,
    background_color = beautiful.music_progressbar_bg,
    max_value = 100,
    value = 75,
}
local text_time_elapsed = wibox.widget.textbox("N/A")
text_time_elapsed.font = beautiful.font_type.standard.." Bold 11"
text_time_elapsed.valign = "top"

local text_time_total = wibox.widget.textbox("N/A")
text_time_total.font = beautiful.font_type.standard.." Bold 11"
text_time_total.valign = "top"

-- volume slider
local volume_slider = wibox.widget.slider {
    bar_height = 4,
    forced_width = 1,
    forced_height = 14,
    bar_active_color = beautiful.volumebar_fg,
    bar_color = beautiful.volumebar_bg,
    handle_width = 0,
    maximum = 100,
    minimum = 0,
    value = 75,
}

local update_volume = gears.timer {
    timeout = 0.2,
    single = true,
    callback = function()
        awesome.emit_signal("music::volume_changed", volume_slider.value)
    end
}
volume_slider:connect_signal("property::value", function()
    -- do not call it too much
    update_volume:again()
end)

---- song info and art
local song_title = wibox.widget.textbox("Nothing to see")
song_title.font = beautiful.font_type.standard.." bold 18"
local song_detail = wibox.widget.textbox(" ")
song_detail.font = beautiful.font_type.standard.." 12"
local coverico = wibox.widget.imagebox(awesome_dir.."fallback.png")
coverico.clip_shape = rounded_rect(beautiful.popup_roundness)
coverico.forced_height = 128

-- music player
local recheck_delay = 1.0

local function toggle_press(w)
    awesome.emit_signal("music::toggle")
    single_timer(recheck_delay, function()
        if status.player_paused then
            w.text = "󰐊"
        else
            w.text = "󰏤"
        end
    end):start()
end
local togglebutton = ui.create_button_fg("󰐊", beautiful.musicplayer_primary_button_normal, beautiful.musicplayer_button_focus, toggle_press, 32, _, 20, _)

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
local prevbutton = ui.create_button_fg("󰒮", beautiful.musicplayer_primary_button_normal, beautiful.musicplayer_button_focus, prev_press, 22, _, _, "right")

local function next_press(_)
    togglebutton.widget.text = "󰏤"
    awesome.emit_signal("music::play_next_song")
    single_timer(recheck_delay, refresh_toggle_button):start()
end
local nextbutton = ui.create_button_fg("󰒭", beautiful.musicplayer_primary_button_normal, beautiful.musicplayer_button_focus, next_press, 22, _, _, "left")

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
local shufflebutton = ui.create_button_fg("󰒞", beautiful.musicplayer_secondary_button_normal, beautiful.musicplayer_button_focus, shuffle_press, 22)

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
local loopbutton = ui.create_button_fg("󰑖", beautiful.musicplayer_secondary_button_normal, beautiful.musicplayer_button_focus, loop_press, 22)

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
        margins = 8,
    },
    {
        {
            layout = wibox.layout.fixed.vertical,
            {
                layout = wibox.container.scroll.horizontal,
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
awesome.connect_signal("music::set_cover", function(path)
    coverico.image = gears.surface.load_uncached(path)
    -- coverico.image = path
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

return {
    widget = music_player_widget,
    status = status,
    togglebutton = togglebutton,
    prevbutton = prevbutton,
    nextbutton = nextbutton,
}