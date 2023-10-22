-- NOTE
--[[
    DEPRECATED
    im not using mpd anymore
    features are not up to date
    bug to be expected
]]--

local lain = require("lain")
local markup = lain.util.markup
local utf8 = require "utf8"
local music_player = require("widgets.musicplayer")

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
local current_album = ""
local current_song = ""
local mpd_off = true
local mpd_paused = false
local notification_preset = {}

local function show_notify() end

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

        music_player.status.player_paused = mpd_paused
        music_player.status.shuffle = mpd_now.random_mode
        if mpd_now.repeat_mode and not mpd_now.single_mode then
            music_player.status.loop_playlist = true
            music_player.status.loop_track = false
            music_player.status.no_loop = false
        elseif mpd_now.repeat_mode and mpd_now.single_mode then
            music_player.status.loop_playlist = fasle
            music_player.status.loop_track = true
            music_player.status.no_loop = false
        elseif not mpd_now.repeat_mode and not mpd_now.single_mode then
            music_player.status.loop_playlist = fasle
            music_player.status.loop_track = false
            music_player.status.no_loop = true
        end

        local title = mpd_now.artist.." - "..mpd_now.title
        if utf8.len(title) > 45 then
            title = utf8.sub(title, 1, 42) .. "..."
        end

        widget:set_markup(musicico..markup.fg.color(color_subtext0, title))
        local detail1 = decor_setter(mpd_now.album, mpd_now.date)
        local detail2 = ", "..detail1
        if detail1 == '' then
            detail2 = ''
        end

        music_player.set_title(mpd_now.title)
        music_player.set_detail(mpd_now.artist..detail2)

        music_player.set_elapsed_time(mpd_now.elapsed)
        music_player.set_total_time(mpd_now.time)

        notification_preset = {
            timeout = 4,
            message = "now playing\n"..
                      "<span font = 'Dosis 18'><b>"..mpd_now.title.."</b></span>\n"..
                      mpd_now.artist..detail1
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
            show_notify()
        end
    end,
}
lain_mpd.align = "center"
lain_mpd.update()

show_notify = function()
    local common =  {
        preset      = notification_preset,
        icon        = ".config/awesome/mpd_cover.png",
        icon_size   = 120,
        replaces_id = lain_mpd.id,
        border_width = beautiful.border_width
    }
    lain_mpd.id = naughty.notify(common).id
end

local mpdwidget = wibox.widget {
    widget = wibox.container.margin,
    right = widget_spacing,
    wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        lain_mpd
    }
}

mpdwidget:buttons(gears.table.join(awful.button({ }, 1, function() music_player.toggle_lock_visibility() end)))

mpdwidget:connect_signal("mouse::enter", function()
    if mpd_off then return end
    music_player.show(true)
end)
mpdwidget:connect_signal("mouse::leave", function() music_player.hide() end)

awesome.connect_signal("music::cover_changed", function()
    music_player.set_cover(".config/awesome/mpd_cover.png")
    show_notify()
end)

-- process music player signals
awesome.connect_signal("music::position_changed", function(position)
    awful.spawn("mpc seek "..position.."%")
end)

awesome.connect_signal("music::play_previous_song", function()
    awful.spawn("mpc prev")
end)
awesome.connect_signal("music::play_next_song", function()
    awful.spawn("mpc next")
end)
awesome.connect_signal("music::play_song", function()
    awful.spawn("mpc play")
end)
awesome.connect_signal("music::pause_song", function()
    awful.spawn("mpc pause")
end)
awesome.connect_signal("music::shuffle_on", function()
    awful.spawn("mpc random on")
end)
awesome.connect_signal("music::shuffle_off", function()
    awful.spawn("mpc random off")
end)
awesome.connect_signal("music::loop_playlist", function()
    awful.spawn("mpc repeat on")
    awful.spawn("mpc single off")
end)
awesome.connect_signal("music::loop_track", function()
    awful.spawn("mpc repeat on")
    awful.spawn("mpc single on")
end)
awesome.connect_signal("music::no_loop", function()
    awful.spawn("mpc repeat off")
    awful.spawn("mpc single off")
end)

return mpdwidget