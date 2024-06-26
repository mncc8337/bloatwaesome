local config    = require("config")
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

local function update_tag_color(self, c3, index, objects)
    self:get_children_by_id('mytext_role')[1].text = ""
    self:get_children_by_id('text_color')[1].fg = beautiful.taglist_fg_not_focus

    for i, tag in ipairs(awful.screen.focused().tags) do
        if i == index then
            if #tag:clients() > 0 then
                self:get_children_by_id('mytext_role')[1].text = ""
            end
            if tag.selected then
                self:get_children_by_id('text_color')[1].fg = beautiful.tag_color[index]
            end
        end
    end
end

--[[ taskbar ]]--
awful.screen.connect_for_each_screen(function(s)
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Each screen has its own tag table.
    local tag_table = {}
    for i = 1, config.tag_num do
        table.insert(tag_table, tostring(i))
    end
    awful.tag(tag_table, s, awful.layout.layouts[1])
    
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
                    font = beautiful.font_type.icon.." bold 16",
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
                    self.bg = beautiful.tag_color[index]
                end)
                self:connect_signal('mouse::leave', function()
                   self.bg = beautiful.taglist_bg_focus
                end)

                update_tag_color(self, c3, index, objects)
            end,
            update_callback = update_tag_color,
        },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        layout   = {
            spacing = 5,
            layout  = wibox.layout.fixed.horizontal
        },
        style    = {
            shape = rounded_rect(4),
        },
        widget_template = {
            {
                centered_widget({
                    {
                        id     = 'icon_role',
                        widget = wibox.widget.imagebox,
                    },
                    margins = 2,
                    widget  = wibox.container.margin,
                }),
                id     = 'background_role',
                widget = wibox.container.background,
            },
            widget = wibox.container.margin,
            top = 3, bottom = 3,
        },
    }
    
    -- Create the wibox
    s.wibar = awful.wibar {
        position = "top",
        screen = s,
        height = config.bar_size,
    }
    if config.floating_bar then
        s.wibar.margins = {
            top = config.screen_spacing,
            bottom = 10 - beautiful.useless_gap * 2,
            left = beautiful.useless_gap * 2,
            right = beautiful.useless_gap * 2
        }
        s.wibar.shape = rounded_rect(beautiful.popup_roundness)
        s.wibar.border_width = 2
        s.wibar.border_color = beautiful.border_normal
    end

    -- Add widgets to the wibox
    s.wibar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        -- left
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            widgets.launcher,
            s.mytaglist,
            widgets.separator,
            s.mytasklist,
        },
        -- middle
        widgets.clock,
        -- right
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 10,
            widgets.music,
            {
                wibox.widget.systray(),
                widget = wibox.container.margin,
                top = 4, bottom = 4,
                left = -4, right = -4,
            },
            widgets.alsa,
            s.layoutbox,
        }
    }
end)