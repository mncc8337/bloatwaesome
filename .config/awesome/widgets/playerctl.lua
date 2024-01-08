local config       = require("config")
local gears        = require("gears")
local beautiful    = require("beautiful")
local wibox        = require("wibox")
local naughty      = require("naughty")
local bling        = require("modules.bling")

local markup       = require("lain").util.markup
local utf8         = require "utf8"
local music_player = require("musicplayer")

local player_off = true
local media_length = 0
local current_player = ""

local musicico = wibox.widget.textbox(markup.fg.color(beautiful.music_icon_color_inactive, "󰝛 "))
musicico.font = beautiful.font_type.icon.." 12"

local titlew = wibox.widget.textbox()

local function no_player_fallback()
    awesome.emit_signal("music::set_cover", config.awesome_dir.."fallback.png")
    awesome.emit_signal("music::set_title", "No song")
    awesome.emit_signal("music::set_detail", "hehe")
    awesome.emit_signal("music::set_total_time", 1)
    awesome.emit_signal("music::set_elapsed_time", 0)
    awesome.emit_signal("music:refreshUI")
end

local playerctl = bling.signal.playerctl.lib()

local prev_notification
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
    -- consider this is `player_off`
    if artist == '' or title == '' then
        single_timer(0.01, function()
            musicico.markup = markup.fg.color(beautiful.music_icon_color_inactive, "󰝛 ")
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

    if player_name == "chromium" then
        -- remove the ' - Topic' in artist name when playing youtube music
        artist = artist:gsub("%s%-%sTopic", "")

        -- if there is (probaly) artist name in title
        if title:find("%s%-%s") then
            -- youtube title often contain more information about artist
            -- or this is a reup

            temp_title = title:gsub("%s%-%s", "ඞ")
            tokens = split_str(temp_title, "ඞ")

            -- it should have 2 tokens
            if #tokens == 2 then
                -- assume that the title does not contain the artist name, else this will break
                -- TODO: fix the above (impossible)

                -- if there is artist name in token 1
                if tokens[1]:find(artist) then
                    -- then the title should be in token 2
                    artist = tokens[1]
                    title = tokens[2]
                -- same of the above but in reverse
                elseif tokens[2]:find(artist) then
                    artist = tokens[2]
                    title = tokens[1]
                end
            end
        end

        -- set fetched artwork (see https://github.com/mncc8337/chromium-artwork-fetcher)
        album_path = config.awesome_dir.."artwork.png"
    end

    -- Set fallback art
    if album_path == '' then
        album_path = awesome_dir.."fallback.png"
    end

    local display = artist.." - "..title
    if title:find("%s%-%s") and player_name == "chromium" then
        display = title
    end

    musicico.markup = markup.fg.color(beautiful.music_icon_color_active, "󰝚 ")
    titlew.markup = display
    awesome.emit_signal("music::set_title", title)
    awesome.emit_signal("music::set_detail", artist..album)

    -- the chrome extension will automatically emit this signal when done fetching
    if player_name ~= "chromium" then
        awesome.emit_signal("music::set_cover", album_path)
    end

    if new then
        local delay = 0
        -- wait for the extension to done fetching the artwork
        if player_name == "chromium" then delay = 1.0 end
        single_timer(delay, function()
            local common =  {
                timeout = 4,
                -- title = title,
                message = "now playing\n"..
                        "<span font = '"..beautiful.font_type.standard.." 18'><b>"..title.."</b></span>\n"..
                        artist..album,
                icon        = album_path,
                icon_size   = 120,
            }
            if prev_notification ~= nil then
                prev_notification:destroy()
            end
            prev_notification = naughty.notify(common)
        end):start()
end
end)
playerctl:connect_signal("no_players", function()
    current_player = ""
    musicico.markup = markup.fg.color(beautiful.music_icon_color_inactive, "󰝛 ")
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
awesome.connect_signal("music::play", function()
    playerctl:play()
end)
awesome.connect_signal("music::pause", function()
    playerctl:pause()
end)
awesome.connect_signal("music::toggle", function()
    playerctl:play_pause()
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
