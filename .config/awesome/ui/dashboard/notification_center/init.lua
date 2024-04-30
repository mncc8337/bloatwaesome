local beautiful = require("beautiful")
local wibox     = require("wibox")
local awful     = require("awful")
local naughty   = require("naughty")
local ui        = require("ui.ui_elements")
local config    = require("config")

local notifs_count = 0

local notifs_container = wibox.widget {
    layout = require("modules.overflow").vertical,
    scrollbar_enabled = true,
    spacing = 10,
    step = 80,
}

local empty_notif = wibox.widget {
    widget = wibox.widget.textbox,
    markup = markup_fg(beautiful.color[4], "<i>no notifications</i>"),
    align = "center",
    valigh = "center",
}
notifs_container:insert(1, empty_notif)
local empty_alert = true

local function remove(wid)
    notifs_container:remove_widgets(wid)
    
    if #notifs_container.children == 0 then
        notifs_container:insert(1, empty_notif)
        empty_alert = true
    end
end

local function add_notif(title, message, icon)
    local close_button = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.titlebar_close_button,
        shape = rounded_rect(3),
        forced_width = 20,
        forced_height = 10,
    }
    
    local title_widget = wibox.widget {
        wibox.widget {
            layout = wibox.layout.align.horizontal,
            wibox.widget {
                widget = wibox.widget.textbox,
                markup = ' '.."<b>"..title.."</b>"..", "..markup_fg(beautiful.color[5], os.date("%H:%M:%S")),
                font = beautiful.font_type.standard.."18",
            },
            nil,
            wibox.widget {
                wibox.widget {
                    close_button,
                    widget = wibox.container.margin,
                    right = 8,
                },
                widget = wibox.container.place,
            },
        },
        widget = wibox.container.background,
        bg = beautiful.notification_title_bg,
    }

    local message_widget = wibox.widget {
        widget = wibox.widget.textbox,
        markup = message,
        font = beautiful.font_type.standard.."16",
    }

    
    local notif
    
    if icon then
        notif = wibox.widget {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget {
                wibox.widget {
                    widget = wibox.widget.imagebox,
                    image = icon,
                    forced_width = 100,
                    forced_height = 100,
                    clip_shape = rounded_rect(4),
                },
                widget = wibox.container.margin,
                margins = 8,
                right = 0,
            },
            wibox.widget {
                message_widget,
                widget = wibox.container.margin,
                left = 5, right = 8,
            }
        }
    else
        notif = wibox.widget {
            message_widget,
            widget = wibox.container.margin,
            margins = 8,
        }
    end
    
    notif = wibox.widget {
        layout = wibox.layout.align.vertical,
        title_widget,
        notif
    }
    
    notif = ui.create_dashboard_panel(notif)
    
    close_button:buttons(awful.button({ }, 1, function() remove(notif) end))

    notifs_container:insert(1, notif)

    
    if empty_alert then
        remove(empty_notif)
        empty_alert = false
    end
end


naughty.connect_signal("added", function(n)
    if n.title == "debug" then return end
    add_notif(n.title, n.message, n.icon)
end)

return notifs_container