local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local widgets   = require("widgets")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
                if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({ }, 2, function(c)
        c:kill()
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

--[[ taskbar ]]--
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    --s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    id     = 'mytext_role',
                    align = "center",
                    valign = "center",
                    widget = wibox.widget.textbox,
                    font = beautiful.font_icon.." 18",
                },
                id = 'text_color',
                forced_width = 30,
                forced_height = 30,
                widget = wibox.container.background,
            },
            id     = 'background_role',
            widget = wibox.container.background,

            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:connect_signal('mouse::enter', function()
                    self.bg = beautiful.tag_colors[index]
                end)
                self:connect_signal('mouse::leave', function()
                   self.bg = color_base
                end)

                self:get_children_by_id('mytext_role')[1].text = ""
                self:get_children_by_id('text_color')[1].fg = beautiful.taglist_fg_not_focus

                for i, tag in ipairs(awful.screen.focused().tags) do
                    if i == index then
                        if #tag:clients() > 0 then
                            self:get_children_by_id('mytext_role')[1].text = ""
                        end
                        if tag.selected then
                            self:get_children_by_id('text_color')[1].fg = beautiful.tag_colors[index]
                        end
                    end
                end
            end,

            update_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('mytext_role')[1].text = ""
                self:get_children_by_id('text_color')[1].fg = beautiful.taglist_fg_not_focus

                for i, tag in ipairs(awful.screen.focused().tags) do
                    if i == index then
                        if #tag:clients() > 0 then
                            self:get_children_by_id('mytext_role')[1].text = ""
                        end
                        if tag.selected then
                            self:get_children_by_id('text_color')[1].fg = beautiful.tag_colors[index]
                        end
                    end
                end
            end,
        },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        layout   = {
            spacing = 3,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 3,
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            {
                centered_widget({id = 'clienticon', widget = awful.widget.clienticon}),
                margins = 3,
                widget  = wibox.container.margin
            },
            nil,
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
            layout = wibox.layout.align.vertical,
        },
    }

    -- Create the wibox
    s.wibar = awful.wibar({ position = "top", screen = s, height = taskbar_size})

    -- Add widgets to the wibox
    s.wibar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        -- left
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            s.mytaglist,
            widgets.separator,
            s.mytasklist,
            widgets.focused_client,
        },
        -- middle
        wibox.widget {
            widget = wibox.widget.textclock,
            font = beautiful.font_standard.." bold 12",
            valign = "center",
            align = "center",
        },
        -- right
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 10,
            widgets.music,
            widgets.mem,
            widgets.temp,
            widgets.cpu,
            widgets.weather,
            widgets.alsa,
            {
                {
                    layout = wibox.layout.align.horizontal,
                    spacing = 5,
                    wibox.widget.systray(),
                    s.mylayoutbox,
                },
                widget = wibox.container.margin,
                top = 4, bottom = 4, right = 4, left = -4,
            }
        }
    }
end)