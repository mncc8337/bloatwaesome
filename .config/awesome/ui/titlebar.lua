local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")

local function button(color, func)
    local b = wibox.widget {
        widget = wibox.container.background,
        bg = color,
        shape = rounded_rect(3),
        forced_width = 20,
        forced_height = 10,
    }
    b:buttons(awful.button({ }, 1, func))

    return b
end

client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    local ontop_button = button(beautiful.color.surface0, function()
        c.ontop = not c.ontop
    end)
    c:connect_signal("property::ontop", function(c)
        if c.ontop then
            ontop_button.bg = beautiful.color.blue
        else
            ontop_button.bg = beautiful.color.surface0
        end
    end)

    local sticky_button = button(beautiful.color.surface0, function()
        c.sticky = not c.sticky
    end)
    c:connect_signal("property::sticky", function(c)
        if c.sticky then
            sticky_button.bg = beautiful.color.green
        else
            sticky_button.bg = beautiful.color.surface0
        end
    end)

    awful.titlebar(c, {
        size = 15,
        bg_normal = beautiful.border_normal,
        bg_focus = beautiful.border_focus,
    }):setup {
        layout = wibox.layout.align.horizontal,
        wibox.widget {
            widget = wibox.container.place,
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = 5,
                wibox.widget {forced_width = 2},
                button(beautiful.color.red, function()
                    c:kill()
                end),
                button(beautiful.color.yellow, function()
                    gears.timer.delayed_call(function()
                        c.minimized = not c.minimized
                    end)
                end),
            }
        },
        wibox.widget {buttons = buttons},
        wibox.widget {
            widget = wibox.container.place,
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = 5,
                ontop_button,
                sticky_button,
                wibox.widget {forced_width = 2},
            }
        },
    }
end)