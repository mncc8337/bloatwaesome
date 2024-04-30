local config        = require("config")
local gears         = require("gears")
local awful         = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local awesome_dir = gears.filesystem.get_configuration_dir()

local modkey = config.modkey
local altkey = config.altkey

globalkeys = gears.table.join(
    -- client thing
    awful.key({modkey}, "d", function()
        local already_minimized = true
        -- check if all client is minimized or not
        for _, c in ipairs(mouse.screen.selected_tag:clients()) do
            if not c.minimized and c.name ~= "drop-down-terminal" then
                already_minimized = false
            end
        end

        -- if all clients are minimized then unminimize them, else minimized all clients
        for _, c in ipairs(mouse.screen.selected_tag:clients()) do
            if c.name ~= "drop-down-terminal" then
                c.minimized = not already_minimized
            end
        end
    end,
    {description = "(un)minimize all clients", group = "client"}),

    awful.key({modkey, "Control" }, "n", function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", {raise = true})
        end
    end,
    {description = "restore minimized", group = "client"}),

    awful.key({modkey}, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    --

    -- awesome
    awful.key({modkey           }, "s",      hotkeys_popup.show_help,
              {description = "show help",      group = "awesome"}),
    awful.key({modkey, "Control"}, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({modkey, "Shift"  }, "q", awesome.quit,
              {description = "quit awesome",   group = "awesome"}),
    --

    -- switch screen
    awful.key({modkey, "Control"}, "j", function() awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({modkey, "Control"}, "k", function() awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    --

    -- tag view
    awful.key({modkey}, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({modkey}, "Right",  awful.tag.viewnext,
              {description = "view next",     group = "tag"}),
    awful.key({modkey}, "Escape", awful.tag.history.restore,
              {description = "go back",       group = "tag"}),
    --

    -- window move focus
    awful.key({modkey}, "j",   function() awful.client.focus.byidx( 1) end,
              {description = "focus next by index", group = "client"}),
    awful.key({modkey}, "k",   function() awful.client.focus.byidx(-1) end,
              {description = "focus previous by index", group = "client"}),
    awful.key({modkey}, "Tab", function() awful.client.focus.byidx( 1) end,
              {description = "switch between windows", group = "client"}),
    --

    -- swap window
    awful.key({modkey, "Shift"}, "j", function() awful.client.swap.byidx(  1) end,
              {description = "swap with next client by index",     group = "client"}),
    awful.key({modkey, "Shift"}, "k", function() awful.client.swap.byidx( -1) end,
              {description = "swap with previous client by index", group = "client"}),
    --

    -- window resize
    awful.key({modkey}, "l", function() awful.tag.incmwfact( 0.05) end,
            {description = "increase master width factor", group = "layout"}),
    awful.key({modkey}, "h", function() awful.tag.incmwfact(-0.05) end,
            {description = "decrease master width factor", group = "layout"}),
    --

    -- number of master
    awful.key({modkey, "Shift"}, "l", function() awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({modkey, "Shift"}, "h", function() awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    --

    -- column num
    awful.key({modkey, "Control"}, "l", function() awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({modkey, "Control"}, "h", function() awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    --

    -- switch layout
    awful.key({modkey         }, "space", function() awful.layout.inc( 1) end,
              {description = "select next", group = "layout"}),
    awful.key({modkey, "Shift"}, "space", function() awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),
    --

    -- rofi
    awful.key({modkey}, "w", function() awful.spawn("rofi -show drun") end,
              {description = "show rofi main menu", group = "launcher"}),
    awful.key({modkey}, "r", function() awful.spawn("rofi -show run")  end,
              {description = "run rofi",            group = "launcher"}),
    --
    
    -- launch apps
    awful.key({modkey}, "Return", function() awful.spawn(config.terminal)    end,
              {description = "open a terminal",  group = "launcher"}),
    awful.key({modkey}, "e",      function() awful.spawn(config.filemanager) end,
              {description = "open file manager", group = "launcher"}),
    --

    -- media
    awful.key({}, "XF86AudioNext", function() awesome.emit_signal("music::play_next_song")     end,
              {description = "next song",       group = "media"}),
    awful.key({}, "XF86AudioPrev", function() awesome.emit_signal("music::play_previous_song") end,
              {description = "previous song",   group = "media"}),
    awful.key({}, "XF86AudioPlay", function() awesome.emit_signal("music::toggle")             end,
              {description = "pause/play song", group = "media"}),
    awful.key({}, "XF86AudioStop", function() awesome.emit_signal("music::pause")              end,
              {description = "pause song",      group = "media"}),
    --

    -- audio
    awful.key({}, "XF86AudioRaiseVolume", function() awesome.emit_signal("alsa::increase_volume_level",  2) end,
              {description = "increase volume",    group = "media"}),
    awful.key({}, "XF86AudioLowerVolume", function() awesome.emit_signal("alsa::increase_volume_level", -2) end,
              {description = "decrease volume",    group = "media"}),
    awful.key({}, "XF86AudioMute",        function() awesome.emit_signal("alsa::toggle_mute")               end,
              {description = "mute/unmute volume", group = "media"}),
    --

    -- print screen
    awful.key({               }, "Print", function() awful.spawn.with_shell(".bin/screenshot full")      end,
              {description = "print full screen",               group = "media"}),
    awful.key({modkey         }, "Print", function() awful.spawn.with_shell(".bin/screenshot full save") end,
              {description = "print full screen and save",      group = "media"}),
    awful.key({        "Shift"}, "Print", function() awful.spawn.with_shell(".bin/screenshot area")      end,
              {description = "print a part of screen",          group = "media"}),
    awful.key({modkey, "Shift"}, "Print", function() awful.spawn.with_shell(".bin/screenshot area save") end,
              {description = "print a part of screen and save", group = "media"}),
    --

    -- corner key
    awful.key({altkey         }, "F12", function() awesome.emit_signal("dashboard::toggle_tag", 1) end,
              {description = "toggle control center",      group = "awesome"}),
    awful.key({altkey, "Shift"}, "F12", function() awesome.emit_signal("dashboard::toggle_tag", 2) end,
              {description = "toggle notification center", group = "awesome"}),
    awful.key({altkey         }, "F11", function() awesome.emit_signal("drop-down-term::toggle")   end,
              {description = "toggle drop-down terminal",  group = "awesome"}),
    awful.key({altkey         }, "F10", function() awesome.emit_signal("timeweather::toggle")      end,
              {description = "toggle time and weather",    group = "awesome"})
    --
)

clientkeys = gears.table.join(
    awful.key({modkey, "Control"}, "space",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({modkey, "Control"}, "Return", function(c) c:swap(awful.client.getmaster()) end,
              {description = "move to master",  group = "client"}),

    awful.key({modkey}, "f", function(c) c.fullscreen = not c.fullscreen end,
              {description = "toggle fullscreen",  group = "client"}),
    awful.key({modkey}, "x", function(c) c:kill()                        end,
              {description = "close",              group = "client"}),

    awful.key({modkey}, "o", function(c) c:move_to_screen()              end,
              {description = "move to screen",     group = "client"}),
    awful.key({modkey}, "t", function(c) c.ontop = not c.ontop           end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({modkey}, "y", function(c) c.sticky = not c.sticky         end,
              {description = "(un)sticky",         group = "client"}),

    awful.key({modkey}, "n", function(c) c.minimized = true              end,
              {description = "minimize",           group = "client"}),
    -- maximized client is not looking good with floating bar
    -- it is here to fix when some client is maximized by default
    awful.key({modkey}, "m", function(c) c.maximized = not c.maximized   end,
              {description = "(un)maximize",       group = "client"})
)

-- bind all key numbers to tags
for i = 1, config.tag_num do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({modkey}, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({modkey, "Control"}, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({modkey, "Shift"}, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({      }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({modkey}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({modkey}, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- set keys
root.keys(globalkeys)