local alsa = require("widgets").alsa

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    -- awful.button({ }, 3, function () mymainmenu:toggle() end)
    -- awful.button({ }, 4, awful.tag.viewnext)
    -- awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({altkey}, "o", function() toggle_lain_mpd() end,
        {description = "toggle mpd widget", group = "media"}),
    awful.key({altkey}, "n", function() awful.spawn("mpc next") end,
        {description = "next song", group = "media"}),
    awful.key({altkey}, "p", function() awful.spawn("mpc prev") end,
        {description = "previous song", group = "media"}),
    awful.key({altkey}, "space", function() awful.spawn("mpc toggle") end,
        {description = "pause/play song", group = "media"}),
    awful.key({ modkey }, "F12", function() dropdownterminal() end,
        {description = "spawn a drop-down terminal", group = "launcher"}),
    awful.key({ modkey }, "F11", function() dropdownncmpcpp() end,
        {description = "spawn a drop-down music player", group = "launcher"}),
    -- On the fly useless gaps change
    awful.key({ modkey, "Control" }, "F1", function () lain.util.useless_gaps_resize(1) end,
        {description = "increase useless gaps size", group = "layout"}),
    awful.key({ modkey, "Control" }, "F2", function () lain.util.useless_gaps_resize(-1) end,
        {description = "decrease useless gaps size", group = "layout"}),
    -- minimize all client
    awful.key({modkey}, "d", function()
        local already_minimized = true
        -- check if all client is minimized or not
    for _, cl in ipairs(mouse.screen.selected_tag:clients()) do
            local c = cl
            if c then
                if not c.minimized and c.name ~= "drop-down-terminal" and c.name ~= "drop-down-ncmpcpp" then
                    already_minimized = false
                end
            end
        end

        for _, cl in ipairs(mouse.screen.selected_tag:clients()) do
            local c = cl
            if c then
                -- if all clients are minimized then unminimize them, else minimized all clients
                if c.name ~= "drop-down-terminal" and c.name ~= "drop-down-ncmpcpp" then
                    c.minimized = not already_minimized
                end
            end
        end
    end, {description = "(un)minimize all clients", group = "client"}),
    awful.key({ modkey }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
            end
        end,
        {description = "toggle wibar", group = "awesome"}),
    -- VOLUME
    awful.key({}, "XF86AudioRaiseVolume", function ()
        awful.spawn.easy_async("pactl set-sink-volume "..alsa_device.." +2%", function() alsa.lain_alsa.update() end)
        alsa.volume_slider.value = alsa.lain_alsa.last.level + 2
        alsa.volume_button_triggered_timer:again()
        alsa.volume_slider_popup.visible = true
    end,
    {description = "increase volume", group = "media"}),
    awful.key({}, "XF86AudioLowerVolume", function ()
        awful.spawn.easy_async("pactl set-sink-volume "..alsa_device.." -2%", function() alsa.lain_alsa.update() end)
        alsa.volume_slider.value = alsa.lain_alsa.last.level - 2
        alsa.volume_button_triggered_timer:again()
        alsa.volume_slider_popup.visible = true
    end,
    {description = "decrease volume", group = "media"}),
    awful.key({}, "XF86AudioMute", function ()
        awful.spawn.easy_async("pactl set-sink-mute "..alsa_device.." toggle", function() alsa.lain_alsa.update() end)
        alsa.volume_button_triggered_timer:again()
        alsa.volume_slider_popup.visible = true
    end,
    {description = "mute volume", group = "media"}),
    -- FILE MANAGER
    awful.key({ modkey,           }, "e", function () awful.spawn("nemo") end, {description = "open file explorer", group = "launcher"}),
    -- PRINT
    awful.key({}, "Print", function () os.execute(". ~/.config/awesome/scripts/screenshot.sh full") end,
        {description = "print full screen", group = "media"}),
    awful.key({modkey}, "Print", function () os.execute(". ~/.config/awesome/scripts/screenshot.sh full save") end,
        {description = "print full screen and save", group = "media"}),
    awful.key({ "Shift" }, "Print", function () os.execute(". ~/.config/awesome/scripts/screenshot.sh area") end,
        {description = "print a part of screen", group = "media"}),
    awful.key({modkey, "Shift"}, "Print", function () os.execute(". ~/.config/awesome/scripts/screenshot.sh area save") end,
        {description = "print a part of screen and save", group = "media"}),
    -- BOTTOM
    awful.key({"Shift", "Control"}, "Escape", function() awful.spawn(terminal.." --title=\"btop\" -e btop") end,
        {description = "open btop", group = "launcher"}),
    -- DEFAULT
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            --awful.client.focus.byidx(-1)
            awful.spawn("rofi -show window")
        end,
        {description = "open rofi windows", group = "launcher"}
    ),
    awful.key({ modkey,           }, "w", function ()
            -- mymainmenu:toggle()
            awful.spawn("rofi -show drun")
        end,
        {description = "show rofi main menu", group = "launcher"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    --[[
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    ]]--
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal("request::activate", "key.unminimize", {raise = true})
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey }, "r", function ()
            -- awful.screen.focused().mypromptbox:run()
            awful.spawn("rofi -show run")
        end,
        {description = "run rofi", group = "launcher"}) -- default: run prompt
    --[[
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    ]]--
    --[[
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
    ]]--
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "x",
        function (c)
            c:kill()
        end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    --[[
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    ]]--
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, tag_num do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}
