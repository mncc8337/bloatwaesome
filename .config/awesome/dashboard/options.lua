local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local markup    = require("lain").util.markup
local ui        = require("dashboard.ui_elements")

-- awful.screen.focused()
local layoutbox = awful.widget.layoutbox(awful.screen.focused())
layoutbox:buttons {
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
}
layoutbox.forced_width = 32
layoutbox.forced_height = 32

local function crop_screen()
    awesome.emit_signal("dashboard::hide")
    awful.spawn.with_shell(". "..awesome_dir.."scripts/screenshot.sh area save")
end

local mute_button = ui.create_button("󰕾", beautiful.color.yellow, function()
    awesome.emit_signal("widget::toggle_mute")
end)
awesome.connect_signal("widget::volume_mute", function(mute)
    if mute then
        mute_button.widget.markup = markup.fg.color(beautiful.color.yellow, "󰝟")
    else
        mute_button.widget.markup = markup.fg.color(beautiful.color.yellow, "󰕾")
    end
end)

local option_menu = wibox.widget {
    {
        layout = wibox.layout.fixed.vertical,
        spacing = 5,
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            ui.create_button("󰆞", beautiful.color.sapphire, crop_screen),
            layoutbox,
        },
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
            mute_button,
            ui.create_button("󰒓", beautiful.color.lavender, function() awful.spawn.with_shell(editor.." ~/.config/awesome/") end),
        },
    },
    widget = wibox.container.margin,
    margins = 5,
}

-- awesome.connect_signal("dashboard::show", function()
--     layoutbox.screen = awful.screen.focused()
-- end)
screen.connect_signal("primary_changed", function(i)
    layoutbox.screen = i
end)

return ui.create_dashboard_panel(option_menu)