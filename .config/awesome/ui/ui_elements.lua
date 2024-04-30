local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local rubato    = require("modules.rubato")

local arc_num_per_row = 4
local arc_size = (beautiful.dashboard_width - 8 * (3 * arc_num_per_row + 1))/arc_num_per_row
local function create_arcchart(icon, fg)
    local icon_widget = wibox.widget {
        widget = wibox.widget.textbox,
        markup = icon,
        fg = fg,
        align = "center",
        valign = "center",
        font = beautiful.font_type.icon.." 24",
    }
    local arc = wibox.widget {
        widget = wibox.container.arcchart,
        colors = {fg},
        bg = beautiful.arc_bg,
        forced_width = arc_size,
        forced_height = arc_size,
        thickness = 8,
        min_value = 0,
        max_value = 100,
        value = 75,
        icon_widget,
    }

    -- idk why arc.value is only writtable
    local arc_value = 75
    local function set_value(value)
        arc.value = value
        arc_value = value
    end
    icon_widget:connect_signal("mouse::enter", function()
        icon_widget.font = beautiful.font_type.mono.." 24"
        icon_widget.markup = arc_value..'%'
    end)
    icon_widget:connect_signal("mouse::leave", function()
        icon_widget.font = beautiful.font_type.icon.." 24"
        icon_widget.markup = icon
    end)

    return {
        arc = arc,
        set_value = set_value,
    }
end

local function create_dashboard_panel(_widget)
    return wibox.widget {
        {
            _widget,
            widget = wibox.container.background,
            bg = beautiful.bg_normal,
        },
        widget = wibox.container.margin,
        margins = 4,
    }
end

local function create_button_bg(text, color, onclick, width, height, font_size)
    local w = wibox.widget {
        {
            widget = wibox.widget.textbox,
            markup = markup_fg(color, text),
            font = beautiful.font_type.icon..' '..(font_size or 16),
            align = "center",
            forced_width = width or 32,
            forced_height = height or 32,
        },
        widget = wibox.container.background,
        bg = beautiful.button_normal,
    }

    w:connect_signal("mouse::enter", function()
        w.bg = beautiful.button_focus
    end)
    w:connect_signal("mouse::leave", function()
        w.bg = beautiful.button_normal
    end)
    w:buttons{awful.button({}, 1, onclick)}

    return w
end

local function create_button_fg(icon, normal_color, focus_color, onclick, width, height, font_size, align)
    -- font_size and align are optional
    -- onclick must have only 1 arg which is the textbox

    local button  = wibox.widget.textbox(icon)
    button.font   = beautiful.font_type.icon..' '.. (font_size or 20)
    button.align  = align or "center"
    button.valign = "center"
    button.forced_width  = width

    local buttonw = wibox.widget {
        button,
        fg = normal_color,
        widget = wibox.container.background
    }

    button:connect_signal("mouse::enter", function() buttonw.fg = focus_color end)
    button:connect_signal("mouse::leave", function() buttonw.fg = normal_color end)
    button:buttons {awful.button({}, 1, function()
        onclick(button)
    end)}

    return buttonw
end

-- a horizontal tabs scroller uses rubato for smooth movement
-- tabs: tabs to add to the scroller
-- width: the width of the scroller
-- height: the height of the scroller
-- margins: margins
local function h_scrollable(tabs, width, height, margins)
    local current_x = {}
    local tab_timed = {}
    local scroller = wibox.layout.manual()
    for i, tab in ipairs(tabs) do
        tab.forced_width = width - margins.left - margins.right
        tab.forced_height = height - margins.top - margins.bottom
        scroller:add_at(tab, {x = margins.left + (i - 1) * (width + margins.left + margins.right), y = margins.top})

        table.insert(tab_timed, rubato.timed {
            duration = 0.3,
            intro = 0.15,
            override_dt = true,
            easing = rubato.easing.quadratic,
            subscribed = function(pos)
                scroller:move(i, {x = pos, y = margins.top})
            end
        })
        table.insert(current_x, (i - 1) * (width + margins.left + margins.right))
        tab_timed[i].target = current_x[i] + margins.left
    end

    local current_tab = 1
    local function scroll(dis)
        if current_tab + dis < 1 or current_tab + dis > #tabs then return end

        -- pretty inefficient but idk the other way to do this
        for idx, cx in ipairs(current_x) do
            current_x[idx] = cx - (width + margins.left + margins.right) * dis
            tab_timed[idx].target = current_x[idx] + margins.left
        end
        current_tab = current_tab + dis
    end
    local function scroll_to(i)
        local dis = i - current_tab
        if dis == 0 then return end

        scroll(dis)
    end

    return {
        widget = wibox.widget {layout = scroller},
        scroll_to = scroll_to,
        scroll = scroll,
    }
end

return {
    arc_size = arc_size,
    create_arcchart = create_arcchart,
    create_dashboard_panel = create_dashboard_panel,
    create_button_bg = create_button_bg,
    create_button_fg = create_button_fg,
    h_scrollable = h_scrollable,
}