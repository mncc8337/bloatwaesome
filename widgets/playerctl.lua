local dpi = require("beautiful.xresources").apply_dpi
local markup = require("lain").util.markup
local utf8 = require "utf8"
local music_player = require("widgets.musicplayer")

local player_off = true
local media_length = 0

local musicico = markup.fg.color(color_blue, "󰝚  ")
local art = wibox.widget {
    image = ".config/awesome/fallback.png",
    resize = true,
    forced_height = dpi(80),
    forced_width = dpi(80),
    widget = wibox.widget.imagebox
}

local titlew = wibox.widget.textbox()
titlew:set_markup(markup.fg.color(color_overlay0, "󰝛 "))

-- Get Song Info
local notification_id = 0
local playerctl = bling.signal.playerctl.lib()
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
    -- consider this is `player_off`
    if artist == '' or title == '' then
        local temp = gears.timer {
            timeout = 0.01,
            single_shot = true,
            autostart = true,
            callback = function()
                titlew:set_markup(markup.fg.color(color_overlay0, "󰝛 "))
            end
        }
        player_off = true
        return
    end
    player_off = false

    -- Set art widget
    if album_path == '' then
        album_path = ".config/awesome/fallback.png"
    end
    art:set_image(gears.surface.load_uncached(album_path))

    titlew:set_markup(musicico..artist.." - "..title)
    music_player.set_title(title)
    music_player.set_detail(artist)
    music_player.set_cover(album_path)

    if new then
        local common =  {
            title   = "now playing",
            timeout = 4,
            text    = artist.." - "..title,
            icon        = album_path,
            icon_size   = 100,
            replaces_id = notification_id,
            border_width = beautiful.border_width
        }
        notification_id = naughty.notify(common).id
    end
end)
playerctl:connect_signal("no_players", function()
    titlew:set_markup(markup.fg.color(color_overlay0, "󰝛 "))
    player_off = true
end)
playerctl:connect_signal("playback_status", function(_, playing)
    music_player.status.player_paused = not playing
end)
playerctl:connect_signal("position", function(_, interval_sec, length_sec)
    music_player.set_elapsed_time(math.floor(interval_sec + 0.5))
    music_player.set_total_time(math.floor(length_sec + 0.5))
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
end)
playerctl:connect_signal("shuffle", function(_, shuffle)
    music_player.status.shuffle = shuffle
end)

local playerctlwidget = wibox.widget {
    widget = wibox.container.margin,
    right = widget_spacing,
    wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        titlew
    }
}

playerctlwidget:connect_signal("mouse::enter", function()
    if player_off then return end
    music_player.show(true)
end)
playerctlwidget:connect_signal("mouse::leave", function() music_player.hide() end)

-- process music player signals
awesome.connect_signal("music::position_changed", function(position)
    awful.spawn("playerctl position "..(media_length * position / 100))
end)
awesome.connect_signal("music::play_previous_song", function()
    awful.spawn("playerctl previous")
end)
awesome.connect_signal("music::play_next_song", function()
    awful.spawn("playerctl next")
end)
awesome.connect_signal("music::play_song", function()
    awful.spawn("playerctl play")
end)
awesome.connect_signal("music::pause_song", function()
    awful.spawn("playerctl pause")
end)
awesome.connect_signal("music::shuffle_on", function()
    awful.spawn("playerctl shuffle on")
end)
awesome.connect_signal("music::shuffle_off", function()
    awful.spawn("playerctl shuffle off")
end)
awesome.connect_signal("music::loop_playlist", function()
    awful.spawn("playerctl loop playlist")
end)
awesome.connect_signal("music::loop_track", function()
    awful.spawn("playerctl loop track")
end)
awesome.connect_signal("music::no_loop", function()
    awful.spawn("playerctl loop none")
end)

return playerctlwidget