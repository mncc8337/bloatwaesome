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
local text_time_total = wibox.widget.textbox("N/A")
text_time_total.font = beautiful.font_standard.." Bold 11"
local music_progressbar_with_time = wibox.widget {
    layout = wibox.layout.align.vertical,
    {
        layout = wibox.layout.align.horizontal,
        text_time_elapsed, {widget = wibox.widget.textbox}, text_time_total
    },
    music_progressbar
}

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
coverico.clip_shape = round_rect(5)
coverico.forced_height = 150

-- music player
local prevbutton  = wibox.widget.textbox(" 󰒮")
prevbutton.font   = beautiful.font_icon.." 16"
prevbutton.align  = "left"
prevbutton.valign = "center"
prevbutton.forced_width  = 40

local togglebutton  = wibox.widget.textbox("󰐊")
togglebutton.font   = beautiful.font_icon.." 16"
togglebutton.align  = "center"
togglebutton.valign = "center"
togglebutton.forced_width  = 42

local nextbutton    = wibox.widget.textbox("󰒭 ")
nextbutton.font   = beautiful.font_icon.." 16"
nextbutton.align  = "right"
nextbutton.valign = "center"
nextbutton.forced_width  = 40

local shufflebutton = wibox.widget.textbox("󰒞")
shufflebutton.font = beautiful.font_icon.." 18"
shufflebutton.align = "center"
shufflebutton.valign = "center"
shufflebutton.forced_width = 22

local loopbutton = wibox.widget.textbox("󰑖")
loopbutton.font = beautiful.font_icon.." 18"
loopbutton.align = "center"
loopbutton.valign = "center"
loopbutton.forced_width = 22

local normal_color = color_surface0
local focus_color  = color_subtext0

local fake_textl = wibox.widget.textbox()
local fake_togglebuttonl = wibox.widget {
    fake_textl,
    widget = wibox.container.background,
    bg = normal_color
}
fake_textl.forced_width = 24

local fake_textr = wibox.widget.textbox()
local fake_togglebuttonr = wibox.widget {
    fake_textr,
    widget = wibox.container.background,
    bg = normal_color
}
fake_textr.forced_width = 24

local prevbuttonw = wibox.widget {
    prevbutton,
    bg = normal_color,
    shape = round_rect(8),
    widget = wibox.container.background
}
prevbutton:connect_signal("mouse::enter", function()
    prevbuttonw.bg = focus_color
    fake_togglebuttonl.bg = focus_color
end)
prevbutton:connect_signal("mouse::leave", function()
    prevbuttonw.bg = normal_color
    fake_togglebuttonl.bg = normal_color
end)
prevbutton:buttons {awful.button({}, 1, function()
    togglebutton.markup = "󰏤"
    awesome.emit_signal("music::play_previous_song")
end)}

local togglebuttonw = wibox.widget {
    togglebutton,
    bg = color_surface1,
    shape = gears.shape.circle,
    widget = wibox.container.background
}
togglebutton:connect_signal("mouse::enter", function() togglebuttonw.bg = focus_color end)
togglebutton:connect_signal("mouse::leave", function() togglebuttonw.bg = color_surface1 end)
togglebutton:buttons {awful.button({}, 1, function()
    if status.player_paused then
        togglebutton.markup = "󰏤"
        awesome.emit_signal("music::play_song")
    else
        togglebutton.markup = "󰐊"
        awesome.emit_signal("music::pause_song")
    end
    local temp = gears.timer {
        timeout = 0.5,
        single_shot = true,
        autostart = true,
        callback = function()
            if status.player_paused then
                togglebutton.markup = "󰐊"
            else
                togglebutton.markup = "󰏤"
            end
        end
    }
end)}

local nextbuttonw = wibox.widget {
    nextbutton,
    bg = normal_color,
    shape = round_rect(8),
    widget = wibox.container.background
}
nextbutton:connect_signal("mouse::enter", function()
    nextbuttonw.bg = focus_color
    fake_togglebuttonr.bg = focus_color
end)
nextbutton:connect_signal("mouse::leave", function()
    nextbuttonw.bg = normal_color
    fake_togglebuttonr.bg = normal_color
end)
nextbutton:buttons {awful.button({}, 1, function()
    togglebutton.markup = "󰏤"
    awesome.emit_signal("music::play_next_song")
end)}

local shufflebuttonw = wibox.widget {
    {
        shufflebutton,
        widget = wibox.container.margin,
        left = 8 -- 5
    },
    fg = color_surface2,
    widget = wibox.container.background
}
shufflebutton:connect_signal("mouse::enter", function()
    shufflebuttonw.fg = color_subtext2
end)
shufflebutton:connect_signal("mouse::leave", function()
    shufflebuttonw.fg = color_surface2
end)
shufflebutton:buttons {awful.button({}, 1, function()
    if status.shuffle then
        shufflebutton.text = "󰒞"
        awesome.emit_signal("music::shuffle_off")
    else
        shufflebutton.text = "󰒝"
        awesome.emit_signal("music::shuffle_on")
    end
    local temp = gears.timer {
        timeout = 0.5,
        single_shot = true,
        autostart = true,
        callback = function()
            if status.shuffle then
                shufflebutton.text = "󰒝"
            else
                shufflebutton.text = "󰒞"
            end
        end
    }
end)}

local loopbuttonw = wibox.widget {
    {
        loopbutton,
        widget = wibox.container.margin,
        right = 8,
    },
    fg = color_surface2,
    widget = wibox.container.background
}
loopbutton:connect_signal("mouse::enter", function()
    loopbuttonw.fg = color_subtext2
end)
loopbutton:connect_signal("mouse::leave", function()
    loopbuttonw.fg = color_surface2
end)
loopbutton:buttons {awful.button({}, 1, function()
    if status.no_loop then
        loopbutton.text = "󰑖"
        awesome.emit_signal("music::loop_playlist")
    elseif status.loop_playlist then
        loopbutton.text = "󰑘"
        awesome.emit_signal("music::loop_track")
    else
        loopbutton.text = "󰑗"
        awesome.emit_signal("music::no_loop")
    end
    local temp = gears.timer {
        timeout = 0.5,
        single_shot = true,
        autostart = true,
        callback = function()
            if status.no_loop then
                loopbutton.text = "󰑗"
            elseif status.loop_playlist then
                loopbutton.text = "󰑖"
            elseif status.loop_track then
                loopbutton.text = "󰑘"
            end
        end
    }
end)}

local buttons = wibox.widget {
    layout = wibox.layout.stack,
    {
        widget = wibox.container.place,
        halign = "center",
        {
            layout = wibox.layout.fixed.horizontal,
            expand = "none",
            loopbuttonw,
            {
                widget = wibox.container.margin,
                right = -6,
                prevbuttonw,
            },
            fake_togglebuttonl,
            {
                widget = wibox.container.margin,
                left = 3, right = 3,
            },
            fake_togglebuttonr,
            {
                widget = wibox.container.margin,
                left = -6,
                nextbuttonw,
            },
            shufflebuttonw,
            forced_height = 25
        },
    },
    h_centered_widget(togglebuttonw),
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
            music_progressbar_with_time,
            buttons
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
    type = "splash",
    maximum_height = 172,
    -- width = 450,
    shape = round_rect(beautiful.round_corner_radius),
    border_color = beautiful.border_focus,
    border_width = beautiful.border_width,
    widget = music_player_widget,
}

local music_player_timer = gears.timer {
    timeout = 0.1,
    single_shot = true,
    callback = function()
        music_player_popup.visible = false
    end
}

music_player_popup:connect_signal("mouse::enter", function() music_player_timer:stop()  end)
music_player_popup:connect_signal("mouse::leave", function() music_player_timer:again() end)

awesome.connect_signal("music::refreshUI", function()
    if status.player_paused then
        togglebutton.markup = "󰐊"
    else
        togglebutton.markup = "󰏤"
    end

    if status.shuffle then
        shufflebutton.text = "󰒝"
    else
        shufflebutton.text = "󰒞"
    end

    if status.no_loop then
        loopbutton.text = "󰑗"
    elseif status.loop_playlist then
        loopbutton.text = "󰑖"
    elseif status.loop_track then
        loopbutton.text = "󰑘"
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