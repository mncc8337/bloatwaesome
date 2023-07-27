-- Keyboard map indicator and switcher
--mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()
mytextclock.forced_width = 160
mytextclock.align = "center"
mytextclock.valign = "center"

separator = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    shape = gears.shape.rounded_rect,
    color = color_surface0,
    forced_height = 18,
    forced_width = 4,
}
separator = wibox.widget {
    widget = wibox.container.margin,
    left = 3, right = 3,
    separator
}
separator = v_centered_widget(separator)

-- widget icons
memico    = markup.fg.color(color_yellow, "󰘚  ")
tempico   = markup.fg.color(color_red,    "󰔏  ")
cpuico    = markup.fg.color(color_blue,   "󰍛  ")
volumeico = markup.fg.color(color_text,   "󰕾  ") -- 󰕿 󰖀 󰖁 󰝟

--[[ lain widgets ]]--
local lain_weather = lain.widget.weather {
    APPID = "880023f5747dbe369798eb5e34244c70",
    units = "metric",
    lat = 16.404138,
    lon = 107.685390,
    cnt = 1,
    settings = function()
        units = math.floor(weather_now["main"]["temp"]+.5)
        widget:set_markup(units .. "°C ")
    end,
    notification_text_fun = function(wn)
        local  day = os.date("%a %d %H:%M", wn["dt"])
        local desc = wn["weather"][1]["description"]
        local temp = tostring(wn["main"]["temp"])
        local tfeel= tostring(wn["main"]["feels_like"])
        local pres = tostring(wn["main"]["pressure"])
        local humi = tostring(wn["main"]["humidity"])
        local wspe = tostring(wn["wind"]["speed"])
        local wdeg = tostring(wn["wind"]["deg"])
        local clou = tostring(wn["clouds"]["all"])
        local visb = tostring(wn["visibility"]/1000)
        local sset = os.date("%H:%M", wn["sys"]["sunset"])
        local rise = os.date("%H:%M", wn["sys"]["sunrise"])
        return "<span font='Dosis bold 12'>"..day.."</span>, "..desc..'\n'.."<span font='Dosis 12'>"..
               " "..temp.."°C, * "..tfeel.."°C\n"..
               " "..pres.."hPa,  "..humi.."%\n"..
               "   "..wspe.."m/s,   "..wdeg.."°\n"..
               "   "..clou.."%,    "..visb.."km\n"..
               "   "..rise..",    "..sset.."</span>"
    end,
}
lain_weather.widget.forced_width = 40
lain_weather.widget.align = "center"

local lain_cpu = lain.widget.cpu {
    timeout = 3,
    settings = function()
        widget:set_markup(cpuico..cpu_now.usage..'%')
    end
}
lain_cpu.widget.align = "center"

local lain_mem = lain.widget.mem {
    timeout = 1,
    settings = function()
        widget:set_markup(memico..mem_now.used.."MiB, "..mem_now.perc.."%")
    end
}
lain_mem.widget.align = "center"

local lain_temp = lain.widget.temp {
    timeout = 1,
    -- run `find /sys/devices -type f -name *temp*`
    tempfile = "/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input",
    settings = function()
        widget:set_markup(tempico..coretemp_now.."°C")
    end
}
lain_temp.widget.align = "center"

local volico = wibox.widget.textbox()
lain_alsa = lain.widget.alsa {
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

local musicico = markup.fg.color(color_blue, "󰝚  ")
local songinf4 = wibox.widget.textbox()
local coverico = wibox.widget.imagebox(".config/awesome/mpd_cover.png")
coverico.forced_width = 120
coverico.forced_height = 120
local current_album = ""
local current_song = ""
mpd_off = true
local mpd_paused = false
local first_time = true
lain_mpd = lain.widget.mpd {
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
            if first_time then
                first_time = false
                awful.spawn.easy_async("mpd", function() awful.spawn("mpd --kill") end)
            end
            lain_mpd.timer:stop()
            mpd_off = true
            lain_mpd.widget:set_markup(markup.fg.color(color_overlay0, "󰝛 "))
            return
        else
            if first_time then first_time = false end
            mpd_off = false
            musicico = markup.fg.color(color_blue, "󰝚  ")
        end

        function timeformat(t)
            decor = ''
            second = math.floor(t % 60)
            if second < 10 then decor = '0' end
            minute = math.floor((t - second)/60)
            return minute..':'..decor..second
        end
        function decor_setter(album, date)
            local decor = "none"
            if album == "N/A" and date ~= "N/A" then
                decor = date
            elseif album ~= "N/A" and date == "N/A" then
                decor = album
            elseif album ~= "N/A" and date ~= "N/A" then
                decor = album..", "..date
            end
            return decor
        end

        widget:set_markup(musicico..markup.fg.color(color_subtext0, mpd_now.artist.." - "..mpd_now.title))
        local bruhd = ""
        local decor = decor_setter(mpd_now.album, mpd_now.date)
        if decor ~= "none" then
            bruhd = decor..'\n'
            decor = ", "..decor..'\n'
        else decor = "\n" end
        songinf4:set_markup("<span font='Dosis 12'>"..markup.bold(status)..'\n'..mpd_now.title..'\n'..
                            mpd_now.artist..decor..
                            '['..timeformat(mpd_now.elapsed)..'/'..timeformat(mpd_now.time)..']'.."</span>")
        mpd_notification_preset = {
            title   = "now playing",
            timeout = 4,
            text = mpd_now.artist.." - "..mpd_now.title..'\n'..bruhd
        }

        local album = mpd_now.artist..mpd_now.album
        local song = mpd_now.artist..mpd_now.title

        if album ~= current_album or (song ~= current_song and mpd_now.album == "N/A") then
            current_album = album
            local cmd = '. .config/awesome/mp3_cover_getter.sh "'..mpd_now.file..'"'
            awful.spawn.easy_async_with_shell(cmd, function() awesome.emit_signal("music::cover_changed") end)
        end
        if song ~= current_song then
            current_song = song
            if not mpd_inf4.visible then lain_mpd.show_notify() end
        end
    end,
}
awesome.connect_signal("music::cover_changed", function()
    coverico.image = gears.surface.load_uncached(".config/awesome/mpd_cover.png")
    if not mpd_inf4.visible then lain_mpd.show_notify() end
end)
lain_mpd.align = "center"

--[[ widget container ]]--
weatherwidget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    {
        lain_weather.icon,
        widget = wibox.container.margin,
        right = -3
    },
    lain_weather,
    widget = wibox.container
}
lain_weather.attach(weatherwidget)

volumewidget = wibox.widget {
    layout = wibox.layout.align.horizontal,
    lain_alsa
}
-- spawn pavucontrol when click
volumewidget:buttons(gears.table.join(awful.button({ }, 1, function () toggle_pavucontrol() end)))

volume_slider = wibox.widget {
    bar_shape    = gears.shape.rounded_rect,
    bar_height   = 7,
    bar_color    = color_blue,
    handle_color = color_text,
    handle_shape = gears.shape.circle,
    handle_width = 15,
    minimum      = 0,
    maximum      = 100,
    value        = 75,
    forced_width = 300,
    widget       = wibox.widget.slider,
}
volume_slider_popup = awful.popup {
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
    timeout = 0.08,
    single_shot = true,
    callback = function()
        volume_slider_popup.visible = false
    end
}
volume_button_triggered_timer = gears.timer {
    timeout = 1.5,
    single_shot = true,
    callback = function()
        volume_slider_popup.visible = false
    end
}
volumewidget:connect_signal("mouse::enter", function()
    local c = find_client_with_class("Pavucontrol")
    if c then return end
    volume_slider_timer:stop()
    volume_slider.value = lain_alsa.last.level
    volume_slider_popup.visible = true
    --volume_slider_popup:move_next_to(mouse.current_widget_geometry)
end)
volumewidget:connect_signal("mouse::leave", function() volume_slider_timer:again() end)
volume_slider_popup:connect_signal("mouse::enter", function() volume_slider_timer:stop() end)
volume_slider_popup:connect_signal("mouse::leave", function() volume_slider_timer:again() end)
-- limit the shell spawning
local volume_setter_timer = gears.timer {
    timeout = 0.01,
    single_shot = true,
    callback = function()
        awful.spawn.easy_async_with_shell("pactl set-sink-volume "..alsa_device..' '..volume_slider.value..'%', function(_, _, _, _) lain_alsa.update() end)
    end
}
volume_slider:connect_signal("widget::redraw_needed", function() -- when value changed
    volume_setter_timer:again()
end)

cpuwidget = wibox.widget {
    layout = wibox.layout.align.horizontal,
    lain_cpu,
}

tempwidget = wibox.widget {
    layout = wibox.layout.align.horizontal,
    lain_temp,
}

memwidget = wibox.widget {
    layout = wibox.layout.align.horizontal,
    lain_mem,
}
mpdwidget = wibox.widget {
    widget = wibox.container.margin,
    right = 3,
    wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        lain_mpd
    }
}

--[[
█████████╗   ███████████████████████████╗   ███╗    ███╗   ███╗██████╗███╗   ████████████╗██████╗██████╗
██╔════╚██╗ ██╔██╔════╚══██╔══██╔════████╗ ████║    ████╗ ██████╔═══██████╗  ████╚══██╔══██╔═══████╔══██╗
███████╗╚████╔╝███████╗  ██║  █████╗ ██╔████╔██║    ██╔████╔████║   ████╔██╗ ████║  ██║  ██║   ████████╔╝
╚════██║ ╚██╔╝ ╚════██║  ██║  ██╔══╝ ██║╚██╔╝██║    ██║╚██╔╝████║   ████║╚██╗████║  ██║  ██║   ████╔══██╗
███████║  ██║  ███████║  ██║  █████████║ ╚═╝ ██║    ██║ ╚═╝ ██╚██████╔██║ ╚██████║  ██║  ╚██████╔██║  ██║
╚══════╝  ╚═╝  ╚══════╝  ╚═╝  ╚══════╚═╝     ╚═╝    ╚═╝     ╚═╝╚═════╝╚═╝  ╚═══╚═╝  ╚═╝   ╚═════╝╚═╝  ╚═╝
]]--
local sysmon = awful.popup {
    ontop = true,
    visible = false,
    maximum_width = 1000,
    maximum_height = 500,
    border_color = beautiful.border_focus,
    border_width = beautiful.border_width,
    widget = {
        {
            layout = wibox.layout.fixed.vertical,
            memwidget,
            cpuwidget,
            tempwidget,
        },
        widget = wibox.container.margin,
        margins = 5
    }
}
sysmon_icon = wibox.widget {
    layout = wibox.layout.align.horizontal,
    lain_cpu
}
sysmon_icon.width = 47

local sysmon_timer = gears.timer {
    timeout = 0.08,
    single_shot = true,
    callback = function()
        sysmon.visible = false
    end
}
sysmon_icon:connect_signal("mouse::enter", function()
    sysmon_timer:stop()
    sysmon.visible = true
    sysmon:move_next_to(mouse.current_widget_geometry)
end)
sysmon_icon:connect_signal("mouse::leave", function() sysmon_timer:again() end)
sysmon_icon:buttons(gears.table.join(awful.button({ }, 1, function () awful.spawn(terminal.." --title=btop -e btop") end)))
sysmon:connect_signal("mouse::enter", function() sysmon_timer:stop()  end)
sysmon:connect_signal("mouse::leave", function() sysmon_timer:again() end)

--[[
███╗   █████╗   ███████████╗██████╗    ██████╗ █████╗███╗   ███████████╗
████╗ ██████║   ████╔════████╔════╝    ██╔══████╔══██████╗  ████╔════██║
██╔████╔████║   █████████████║         ██████╔█████████╔██╗ ███████╗ ██║
██║╚██╔╝████║   ██╚════██████║         ██╔═══╝██╔══████║╚██╗████╔══╝ ██║
██║ ╚═╝ ██╚██████╔█████████╚██████╗    ██║    ██║  ████║ ╚██████████████████╗
╚═╝     ╚═╝╚═════╝╚══════╚═╝╚═════╝    ╚═╝    ╚═╝  ╚═╚═╝  ╚═══╚══════╚══════╝
]]--
local prevbutton    = wibox.widget.textbox(" 󰒮")
local togglebutton  = wibox.widget.textbox("󰏤")
local nextbutton    = wibox.widget.textbox("󰒭 ")
prevbutton  .font   = "sans 18"
togglebutton.font   = "sans 16"
nextbutton  .font   = "sans 18"
prevbutton  .align  = "left"
togglebutton.align  = "center"
nextbutton  .align  = "right"
prevbutton  .valign = "center"
togglebutton.valign = "center"
nextbutton  .valign = "center"
prevbutton  .forced_height = 30
togglebutton.forced_height = 30
nextbutton  .forced_height = 30
prevbutton  .forced_width  = 42
togglebutton.forced_width  = 30
nextbutton  .forced_width  = 42
local normal_color = color_surface0
local focus_color  = color_subtext0

local fake_textl = wibox.widget.textbox()
local fake_togglebuttonl = wibox.widget {
    fake_textl,
    widget = wibox.container.background,
    bg = normal_color
}
fake_textl.forced_width = 24
fake_textl.forced_height = 30

local fake_textr = wibox.widget.textbox()
local fake_togglebuttonr = wibox.widget {
    fake_textr,
    widget = wibox.container.background,
    bg = normal_color
}
fake_textr.forced_width = 24
fake_textr.forced_height = 30

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

local togglebuttonw = wibox.widget {
    togglebutton,
    bg = color_surface1,
    shape = gears.shape.circle,
    widget = wibox.container.background
}
togglebutton:connect_signal("mouse::enter", function() togglebuttonw.bg = focus_color end)
togglebutton:connect_signal("mouse::leave", function() togglebuttonw.bg = color_surface1 end)

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

local buttons = wibox.widget {
    layout = wibox.layout.stack,
    {
        layout = wibox.layout.fixed.horizontal,
        expand = "none",
        {
            widget = wibox.container.margin,
            right = -8,
            prevbuttonw,
        },
        fake_togglebuttonl,
        fake_togglebuttonr,
        {
            widget = wibox.container.margin,
            left = -8,
            nextbuttonw,
        }
    },
    h_centered_widget(togglebuttonw)
}

prevbutton:buttons(gears.table.join(awful.button({}, 1, function()
    awful.spawn.with_shell("mpc prev")
    lain_mpd.update()
end)))
togglebutton:buttons(gears.table.join(awful.button({}, 1, function()
    awful.spawn.with_shell("mpc toggle")
    lain_mpd.update()
    if togglebutton.markup == "󰐊" then
        togglebutton.markup = "󰏤"
    else
        togglebutton.markup = "󰐊"
    end
end)))
nextbutton:buttons(gears.table.join(awful.button({}, 1, function()
    if togglebuttonw.bg == focus_color then return end
    awful.spawn.with_shell("mpc next")
    lain_mpd.update()
end)))

mpd_inf4 =  awful.popup {
    ontop = true,
    visible = false,
    --maximum_width = 300,
    --maximum_height = 500,
    shape = round_rect(beautiful.round_corner_radius),
    border_color = beautiful.border_focus,
    border_width = beautiful.border_width,
    widget = {
        layout = wibox.layout.align.horizontal,
        {
            coverico,
            margins = 5,
            widget = wibox.container.margin
        },
        {
            {
                layout = wibox.layout.fixed.vertical,
                songinf4,
                h_centered_widget(buttons)
            },
            right = 5, top = 5,
            widget = wibox.container.margin
        }
    }
}
local mpd_inf4_timer = gears.timer {
    timeout = 0.08,
    single_shot = true,
    callback = function()
        mpd_inf4.visible = false
    end
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

    mpd_inf4_timer:stop()
    mpd_inf4.visible = true
    mpd_inf4:move_next_to(mouse.current_widget_geometry)
end)
mpdwidget:connect_signal("mouse::leave", function() mpd_inf4_timer:again() end)
mpdwidget:buttons(gears.table.join(
    awful.button({ }, 1, function () dropdownncmpcpp() end),
    awful.button({ }, 3, function () toggle_lain_mpd()  end)
))
mpd_inf4:connect_signal("mouse::enter", function() mpd_inf4_timer:stop()  end)
mpd_inf4:connect_signal("mouse::leave", function() mpd_inf4_timer:again() end)

--[[
 ██████╗██████████╗  ███████████████╗███████╗
██╔═══██╚══██╔══██║  ████╔════██╔══████╔════╝
██║   ██║  ██║  ████████████╗ ██████╔███████╗
██║   ██║  ██║  ██╔══████╔══╝ ██╔══██╚════██║
╚██████╔╝  ██║  ██║  ███████████║  █████████║
 ╚═════╝   ╚═╝  ╚═╝  ╚═╚══════╚═╝  ╚═╚══════╝
]]--
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

focused_client = wibox.widget.textbox()
focused_client.font = "Dosis Bold 12"
local function update_fc_widget()
    local current_focus_client = client.focus
    if current_focus_client then
        if current_focus_client.name then
            -- shorten the name
            local name = current_focus_client.name
            if string.len(name) > 50 then
                name = string.sub(name, 1, 47) .. "..."
            end
            focused_client.markup = markup.fg.color(color_subtext0, name)
        else
            focused_client.markup = markup.fg.color(color_overlay2, "unamed client")
        end
    else focused_client.markup = "" end
end
client.connect_signal("property::name", function() update_fc_widget() end)
client.connect_signal("focus", function(c) update_fc_widget() end)
client.connect_signal("unfocus", function(c) update_fc_widget() end)
