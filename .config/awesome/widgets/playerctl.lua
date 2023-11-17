local gears        = require("gears")
local beautiful    = require("beautiful")
local wibox        = require("wibox")
local naughty      = require("naughty")
local bling        = require("bling")

local markup       = require("lain").util.markup
local utf8         = require "utf8"
local music_player = require("widgets.musicplayer")

local player_off = true
local media_length = 0
local current_player = ""

local musicico = wibox.widget.textbox(markup.fg.color(color_overlay0, "󰝛 "))
musicico.font = beautiful.font_icon.." 12"

local titlew = wibox.widget.textbox()

local function no_player_fallback()
    awesome.emit_signal("music::set_title", "No song")
    awesome.emit_signal("music::set_detail", "hehe")
    awesome.emit_signal("music::set_total_time", 1)
    awesome.emit_signal("music::set_elapsed_time", 0)
    awesome.emit_signal("music:refreshUI")
end

-- Get Song Info
local playerctl = bling.signal.playerctl.lib()

-- get artwprk for chromium browser
local function find_web_art()
end

local prev_notification
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
    -- consider this is `player_off`
    if artist == '' or title == '' then
        single_timer(0.01, function()
            musicico.markup = markup.fg.color(color_overlay0, "󰝛 ")
            titlew.markup = ""
        end):start()

        player_off = true
        no_player_fallback()
        return
    end
    player_off = false

    if album ~= "" then
        album = ", "..album
    end

    -- Set art widget
    if album_path == '' then
        album_path = awesome_dir.."/fallback.png"
    end

    local temp = artist.." - "..title

    musicico.markup = markup.fg.color(color_blue, "󰝚 ")
    titlew.markup = temp
    awesome.emit_signal("music::set_title", title)
    awesome.emit_signal("music::set_detail", artist..album)
    awesome.emit_signal("music::set_cover", album_path)

    if new then
        local common =  {
            timeout = 4,
            -- title = title,
            message = "now playing\n"..
                      "<span font = '"..beautiful.font_standard.." 18'><b>"..title.."</b></span>\n"..
                      artist..album,
            icon        = album_path,
            icon_size   = 120,
        }
        if prev_notification ~= nil then
            prev_notification:destroy()
        end
        prev_notification = naughty.notify(common)
    end
end)
playerctl:connect_signal("no_players", function()
    current_player = ""
    musicico.markup = markup.fg.color(color_overlay0, "󰝛 ")
    titlew.markup = ""
    player_off = true
    no_player_fallback()
end)
playerctl:connect_signal("playback_status", function(_, playing)
    music_player.status.player_paused = not playing
    awesome.emit_signal("music::refreshUI")
end)
playerctl:connect_signal("volume", function(_, value)
    awesome.emit_signal("music::set_volume", math.floor(value * 100))
end)
playerctl:connect_signal("position", function(_, interval_sec, length_sec)
    awesome.emit_signal("music::set_elapsed_time", math.floor(interval_sec + 0.5))
    awesome.emit_signal("music::set_total_time", math.floor(length_sec + 0.5))
    media_length = length_sec
end)
-- playlist track none
playerctl:connect_signal("loop_status", function(_, loop_status)
    if loop_status == "playlist" then
        music_player.status.loop_playlist = true
        music_player.status.loop_track = false
        music_player.status.no_loop = false
    elseif loop_status == "track" then
        music_player.status.loop_playlist = false
        music_player.status.loop_track = true
        music_player.status.no_loop = false
    else
        music_player.status.loop_playlist = false
        music_player.status.loop_track = false
        music_player.status.no_loop = true
    end
    awesome.emit_signal("music::refreshUI")
end)
playerctl:connect_signal("shuffle", function(_, shuffle)
    music_player.status.shuffle = shuffle
    awesome.emit_signal("music::refreshUI")
end)

local playerctlwidget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    musicico,
    {
        layout = wibox.container.scroll.horizontal,
        step_function = wibox.container.scroll.step_functions.linear_increase,
        max_size = 300,
        extra_space = 300,
        speed = 30,
        titlew,
    },
}

playerctlwidget:connect_signal("mouse::enter", function()
    if player_off then return end
    awesome.emit_signal("music::show_player", true)
end)
playerctlwidget:connect_signal("mouse::leave", function()
    awesome.emit_signal("music::hide_player")
end)

-- process music player signals
awesome.connect_signal("music::volume_changed", function(value)
    playerctl:set_volume(value / 100)
end)
awesome.connect_signal("music::position_changed", function(position)
    playerctl:set_position(media_length * position / 100)
end)
awesome.connect_signal("music::play_previous_song", function()
    playerctl:previous()
end)
awesome.connect_signal("music::play_next_song", function()
    playerctl:next()
end)
awesome.connect_signal("music::play_song", function()
    playerctl:play()
end)
awesome.connect_signal("music::pause_song", function()
    playerctl:pause()
end)
awesome.connect_signal("music::shuffle_on", function()
    playerctl:set_shuffle(true)
end)
awesome.connect_signal("music::shuffle_off", function()
    playerctl:set_shuffle(false)
end)
awesome.connect_signal("music::loop_playlist", function()
    playerctl:set_loop_status("PLAYLIST")
end)
awesome.connect_signal("music::loop_track", function()
    playerctl:set_loop_status("TRACK")
end)
awesome.connect_signal("music::no_loop", function()
    playerctl:set_loop_status("NONE")
end)

return playerctlwidget
