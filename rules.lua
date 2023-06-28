-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
     }
    },
    -- pavucontrol
    {
        rule_any = {class = {"Pavucontrol"}},
        properties = {
            ontop = true,
            floating = true,
            skip_taskbar = true,
            placement = awful.placement.top_right,
        }
    },
    -- drop-down terminal
    {
        rule_any = {name = {"drop-down-terminal"}},
        properties = {
            floating = true,
            ontop = true,
            skip_taskbar = true,
            placement = awful.placement.top_right,
            height = 500,
            width = 800,
        }
    },
    -- drop-down music player ?
    {
        rule_any = {name = {"drop-down-ncmpcpp"}},
        properties = {
            floating = true,
            ontop = true,
            skip_taskbar = true,
            placement = awful.placement.top_right,
        }
    },
    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Sxiv",
          "Nemo",
  	    },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false}
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
local function reconfig_border(c)
    if c.fullscreen or c.maximized then
        c.border_width = 0
        awful.spawn("xprop -id " .. c.window .. " -f _PICOM_RCORNER 32c -set _PICOM_RCORNER 0")
    else
        c.border_width = beautiful.border_width
        awful.spawn("xprop -id " .. c.window .. " -f _PICOM_RCORNER 32c -set _PICOM_RCORNER 1")
    end
end
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    reconfig_border(c)
end)
client.connect_signal("property::fullscreen", reconfig_border)
client.connect_signal("property::maximized", reconfig_border)
