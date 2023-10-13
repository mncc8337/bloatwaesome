local dpi = require("beautiful.xresources").apply_dpi
local markup = require("lain").util.markup
local utf8 = require "utf8"
local music_player = require("widgets.musicplayer")

local player_off = true
local media_length = 0
local current_player = ""

local musicico = markup.fg.color(color_blue, "󰝚  ")

local titlew = wibox.widget.textbox()
titlew:set_markup(markup.fg.color(color_overlay0, "󰝛 "))

-- Get Song Info
local playerctl = bling.signal.playerctl.lib()
local prev_notification
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

    if album ~= "" then
        album = ", "..album
    end

    -- Set art widget
    if album_path == '' then
        album_path = ".config/awesome/fallback.png"
    end

    local temp = artist.." - "..title
    if utf8.len(temp) > 45 then
        temp = utf8.sub(temp, 1, 42) .. "..."
    end
    titlew:set_markup(musicico..temp)
    music_player.set_title(title)
    music_player.set_detail(artist..album)
    music_player.set_cover(album_path)

    if new then
        local common =  {
            timeout = 4,
            -- title = title,
            message = "now playing\n"..
                      "<span font = 'Dosis 18'><b>"..title.."</b></span>\n"..
                      artist..album,
            icon        = album_path,
            icon_size   = 120,
            border_width = beautiful.border_width
        }
        if prev_notification ~= nil then
            prev_notification:destroy()
        end
        prev_notification = naughty.notify(common)
    end
end)
playerctl:connect_signal("no_players", function()
    current_player = ""
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

playerctlwidget:buttons(gears.table.join(awful.button({ }, 1, function() music_player.toggle_lock_visibility() end)))

playerctlwidget:connect_signal("mouse::enter", function()
    if player_off then return end
    music_player.show(true)
end)
playerctlwidget:connect_signal("mouse::leave", function() music_player.hide() end)

-- process music player signals
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