local lain = require("lain")
local markup = lain.util.markup
local utf8 = require "utf8"

local function timeformat(t)
    decor = ''
    second = math.floor(t % 60)
    if second < 10 then decor = '0' end
    minute = math.floor((t - second)/60)
    return minute..':'..decor..second
end
local function decor_setter(album, date)
    local decor = ""
    if album == "N/A" and date ~= "N/A" then
        decor = date
    elseif album ~= "N/A" and date == "N/A" then
        decor = album
    elseif album ~= "N/A" and date ~= "N/A" then
        decor = album..", "..date
    end
    return decor
end
local musicico = markup.fg.color(color_blue, "󰝚  ")
local songinf4 = wibox.widget.textbox()
local coverico = wibox.widget.imagebox(".config/awesome/mpd_cover.png")
coverico.clip_shape = round_rect(5)
coverico.forced_width = 149
coverico.forced_height = 149
local current_album = ""
local current_song = ""
local mpd_off = true
local mpd_paused = false
local mpd_random = false
local mpd_repeat = false
local mpd_single = false
local time_elapsed = 0
local time_total = 0
local music_progressbar = wibox.widget.slider {
    bar_height = 3,
    forced_width = 1,
    forced_height = 14,
    bar_shape = gears.shape.rounded_rect,
    bar_active_color = color_blue,
    bar_color = color_surface0,
    handle_color = color_base,
    handle_shape = gears.shape.circle,
    handle_border_color = color_blue,
    handle_border_width = 2,
    handle_width = 10,
    maximum = 100,
    minimum = 0,
    value = 75,
}
local text_time_now = wibox.widget.textbox()
text_time_now.font = "Dosis Bold 11"
local text_time_total = wibox.widget.textbox()
text_time_total.font = "Dosis Bold 11"
local music_progressbar_with_time = wibox.widget {
    layout = wibox.layout.align.vertical,
    {
        layout = wibox.layout.align.horizontal,
        text_time_now, {widget = wibox.widget.textbox}, text_time_total
    },
    music_progressbar
}
local music_time_updating = false
music_progressbar:connect_signal("button::press", function() music_time_updating = true end)
-- need patch (havent been merged yet) https://github.com/awesomeWM/awesome/pull/2773/files
music_progressbar:connect_signal("button::release", function()
    awful.spawn.easy_async("mpc seek "..music_progressbar.value.."%", function()
        music_time_updating = false
    end)
end)
-- music_progressbar.add_button()
-- update the time when sliding
music_progressbar:connect_signal("property::value", function()
    if music_time_updating then
        local tm = math.floor(time_total * music_progressbar.value / 100 + 0.5)
        text_time_now.text = timeformat(tm)
    end
end)

local lain_mpd = lain.widget.mpd {
    timeout = 1,
    notify = "off",
    settings = function()
        local status = "stopped"
        if mpd_now.state == "play" then
            status = "playing"
            mpd_paused = false
        elseif mpd_now.state == "pause" then
            status = "paused"
            mpd_paused = true
        end

        if status == "stopped" then
            mpd_off = true
            widget:set_markup(markup.fg.color(color_overlay0, "󰝛 "))
            return
        else
            mpd_off = false
            musicico = markup.fg.color(color_blue, "󰝚  ")
        end

        mpd_random = mpd_now.random_mode
        mpd_repeat = mpd_now.repeat_mode
        mpd_single = mpd_now.single_mode

        local title = mpd_now.artist.." - "..mpd_now.title
        if utf8.len(title) > 45 then
            title = utf8.sub(title, 1, 42) .. "..."
        end

        widget:set_markup(musicico..markup.fg.color(color_subtext0, title))
        local bruhd = decor_setter(mpd_now.album, mpd_now.date)
        local decor = ", "..bruhd
        if bruhd == '' then
            decor = ''
        end

        if not music_time_updating then
            time_elapsed = mpd_now.elapsed
            time_total = mpd_now.time
            music_progressbar:set_value(time_elapsed / time_total * 100)
            text_time_now.text = timeformat(time_elapsed)
            text_time_total.text = timeformat(time_total)   
        end

        songinf4:set_markup("<span font='Dosis bold 16'>"..mpd_now.title.."</span>\n"..
                            "<span font='Dosis 12'>"..mpd_now.artist..decor.."</span>\n")
        mpd_notification_preset = {
            title   = "now playing",
            timeout = 4,
            text = mpd_now.artist.." - "..mpd_now.title..'\n'..bruhd
        }

        local album = mpd_now.artist..mpd_now.album
        local song = mpd_now.artist..mpd_now.title

        if album ~= current_album or (song ~= current_song and mpd_now.album == "N/A") then
            current_album = album
            local cmd = '. .config/awesome/scripts/mp3_cover_getter.sh "'..mpd_now.file..'"'
            awful.spawn.easy_async_with_shell(cmd, function() awesome.emit_signal("music::cover_changed") end)
        end
        if song ~= current_song then
            current_song = song
            if not mpd_inf4.visible then lain_mpd.show_notify() end
        end
    end,
}
lain_mpd.align = "center"
lain_mpd.update()

-----------------------------------------------------------------------

local prevbutton    = wibox.widget.textbox(" 󰒮")
prevbutton.font   = "sans 18"
prevbutton.align  = "left"
prevbutton.valign = "center"
prevbutton.forced_width  = 40

local togglebutton  = wibox.widget.textbox("󰏤")
togglebutton.font   = "sans 16"
togglebutton.align  = "center"
togglebutton.valign = "center"
togglebutton.forced_width  = 42

local nextbutton    = wibox.widget.textbox("󰒭 ")
nextbutton.font   = "sans 18"
nextbutton.align  = "right"
nextbutton.valign = "center"
nextbutton.forced_width  = 40

local shufflebutton = wibox.widget.textbox("󰒞") -- 󰒝
shufflebutton.font = "sans 18"
shufflebutton.align = "center"
shufflebutton.valign = "center"
shufflebutton.forced_width = 22

local repeatbutton = wibox.widget.textbox("󰑖") -- 󰑘 󰑗
repeatbutton.font = "sans 18"
repeatbutton.align = "center"
repeatbutton.valign = "center"
repeatbutton.forced_width = 22

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
prevbutton:buttons(gears.table.join(awful.button({}, 1, function()
    awful.spawn("mpc prev")
    togglebutton.markup = "󰏤"
    lain_mpd.update()
end)))

local togglebuttonw = wibox.widget {
    togglebutton,
    bg = color_surface1,
    shape = gears.shape.circle,
    widget = wibox.container.background
}
togglebutton:connect_signal("mouse::enter", function() togglebuttonw.bg = focus_color end)
togglebutton:connect_signal("mouse::leave", function() togglebuttonw.bg = color_surface1 end)
togglebutton:buttons(gears.table.join(awful.button({}, 1, function()
    if mpd_paused then
        togglebutton.markup = "󰏤"
    else
        togglebutton.markup = "󰐊"
    end
    awful.spawn("mpc toggle")
    lain_mpd.update()
end)))

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
nextbutton:buttons(gears.table.join(awful.button({}, 1, function()
    awful.spawn("mpc next")
    togglebutton.markup = "󰏤"
    lain_mpd.update()
end)))

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
shufflebutton:buttons(gears.table.join(awful.button({}, 1, function()
    if mpd_random then
        shufflebutton.text = "󰒞"
    else
        shufflebutton.text = "󰒝"
    end
    awful.spawn("mpc random")
    lain_mpd.update()
end)))

local repeatbuttonw = wibox.widget {
    {
        repeatbutton,
        widget = wibox.container.margin,
        right = 8,
    },
    fg = color_surface2,
    widget = wibox.container.background
}
repeatbutton:connect_signal("mouse::enter", function()
    repeatbuttonw.fg = color_subtext2
end)
repeatbutton:connect_signal("mouse::leave", function()
    repeatbuttonw.fg = color_surface2
end)
repeatbutton:buttons(gears.table.join(awful.button({}, 1, function()
    if not mpd_repeat and not mpd_single then
        repeatbutton.text = "󰑖"
        awful.spawn("mpc repeat on")
        awful.spawn("mpc single off")
    elseif mpd_repeat and not mpd_single then
        repeatbutton.text = "󰑘"
        awful.spawn("mpc repeat on")
        awful.spawn("mpc single on")
    elseif mpd_repeat and mpd_single then
        repeatbutton.text = "󰬺"
        awful.spawn("mpc repeat off")
        awful.spawn("mpc single on")
    else
        repeatbutton.text = "󰑗"
        awful.spawn("mpc repeat off")
        awful.spawn("mpc single off")
    end
    lain_mpd.update()
end)))

local buttons = wibox.widget {
    layout = wibox.layout.stack,
    {
        widget = wibox.container.place,
        halign = "center",
        {
            layout = wibox.layout.fixed.horizontal,
            expand = "none",
            repeatbuttonw,
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

local mpd_inf4 = awful.popup {
    ontop = true,
    visible = false,
    --maximum_width = 300,
    maximum_height = 159,
    shape = round_rect(beautiful.round_corner_radius),
    border_color = beautiful.border_focus,
    border_width = beautiful.border_width,
    widget = {
        layout = wibox.layout.fixed.horizontal,
        {
            coverico,
            widget = wibox.container.margin,
            margins = 5,
        },
        {
            {
                layout = wibox.layout.fixed.vertical,
                songinf4,
                music_progressbar_with_time,
                buttons
            },
            widget = wibox.container.margin,
            right = 5, top = 15,
        }
    }
}
local mpd_inf4_timer = gears.timer {
    timeout = 0.1,
    single_shot = true,
    callback = function()
        mpd_inf4.visible = false
    end
}

mpd_inf4:connect_signal("mouse::enter", function() mpd_inf4_timer:stop()  end)
mpd_inf4:connect_signal("mouse::leave", function() mpd_inf4_timer:again() end)

local mpdwidget = wibox.widget {
    widget = wibox.container.margin,
    right = widget_spacing,
    wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        lain_mpd
    }
}

mpdwidget:connect_signal("mouse::enter", function()
    local temp = find_client_with_name("drop-down-ncmpcpp")
    if temp then
        if not temp.hidden then return end
    end
    if mpd_off then return end

    if not mpd_paused then
        togglebutton.markup = "󰏤"
    else
        togglebutton.markup = "󰐊"
    end

    if mpd_random then
        shufflebutton.text = "󰒝"
    else
        shufflebutton.text = "󰒞"
    end

    if not mpd_repeat and not mpd_single then
        repeatbutton.text = "󰑗"
    elseif mpd_repeat and not mpd_single then
        repeatbutton.text = "󰑖"
    elseif mpd_repeat and mpd_single then
        repeatbutton.text = "󰑘"
    else
        repeatbutton.text = "󰬺"
    end

    mpd_inf4_timer:stop()
    mpd_inf4.visible = true
    mpd_inf4:move_next_to(mouse.current_widget_geometry)
end)
mpdwidget:connect_signal("mouse::leave", function() mpd_inf4_timer:again() end)
mpdwidget:buttons(gears.table.join(
    awful.button({ }, 1, function () dropdownncmpcpp() end),
    awful.button({ }, 3, function ()
        local cc = ""
        if not mpd_off then
            lain_mpd.timer:stop()
            mpd_off = true
            cc = "off"
            awful.spawn("killall mpd")
        else
            lain_mpd.timer:start()
            mpd_off = false
            cc = "on"
            awful.spawn("mpd")
        end
        naughty.notify({title = "MPD "..cc})
        lain_mpd.update()
    end)
))
awesome.connect_signal("music::cover_changed", function()
    coverico.image = gears.surface.load_uncached(".config/awesome/mpd_cover.png")
    if not mpd_inf4.visible then lain_mpd.show_notify() end
end)

return mpdwidget