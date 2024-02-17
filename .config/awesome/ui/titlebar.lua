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

    local _ontop_color = not c.ontop and beautiful.titlebar_button_inactive or beautiful.titlebar_ontop_button
    local ontop_button = button(_ontop_color, function()
        c.ontop = not c.ontop
    end)
    c:connect_signal("property::ontop", function(c)
        if c.ontop then
            ontop_button.bg = beautiful.titlebar_ontop_button
        else
            ontop_button.bg = beautiful.titlebar_button_inactive
        end
    end)

    local _sticky_color = not c.sticky and beautiful.titlebar_button_inactive or beautiful.titlebar_sticky_button
    local sticky_button = button(_sticky_color, function()
        c.sticky = not c.sticky
    end)
    c:connect_signal("property::sticky", function(c)
        if c.sticky then
            sticky_button.bg = beautiful.titlebar_sticky_button
        else
            sticky_button.bg = beautiful.titlebar_button_inactive
        end
    end)

    awful.titlebar(c, {
        size = 15,
        bg_normal = beautiful.border_normal,
        bg_focus = beautiful.border_focus,
    }):setup {
        wibox.widget {
            layout = wibox.layout.align.horizontal,
            -- right
            wibox.widget {
                widget = wibox.container.place,
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 5,
                    button(beautiful.titlebar_close_button, function()
                        c:kill()
                    end),
                    button(beautiful.titlebar_minimize_button, function()
                        gears.timer.delayed_call(function()
                            c.minimized = not c.minimized
                        end)
                    end),
                }
            },
            -- middle
            wibox.widget {buttons = buttons},
            -- left
            wibox.widget {
                widget = wibox.container.place,
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = 5,
                    ontop_button,
                    sticky_button,
                }
            },
        },
        widget = wibox.container.margin,
        left = 10, right = 10,
    }
end)