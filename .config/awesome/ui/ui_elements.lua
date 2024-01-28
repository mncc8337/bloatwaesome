local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local markup    = require("lain").util.markup
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
        bg = beautiful.color.crust,
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
            markup = markup.fg.color(color, text),
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

local created_tab_buttons = {}
local function create_tab_button(text, name)
    local button = wibox.widget {
        {
            widget = wibox.widget.textbox,
            markup = text,
            align = "center",
            valign = "center",
            forced_height = 15,
            forced_width = 90,
            font = beautiful.font_type.icon.." 10",
        },
        widget = wibox.container.background,
        bg = beautiful.button_normal,
    }

    local base_color = beautiful.button_normal

    local function set_active()
        base_color = beautiful.button_selected
        button.bg = base_color
        button.fg = beautiful.fg_invert
    end
    local function set_deactive()
        base_color = beautiful.button_normal
        button.bg = base_color
        button.fg = beautiful.fg_normal
    end

    local function set_action(action)
        button:buttons{awful.button({}, 1, function()
            action()
            for _, b in ipairs(created_tab_buttons) do
                b.set_deactive()
            end
            set_active()
            awesome.emit_signal("dashboard::change_tab", name)
        end)}
    end

    button:connect_signal("mouse::enter", function()
        if base_color ~= beautiful.button_selected then
            button.bg = beautiful.button_focus
            button.fg = beautiful.fg_normal
        end
    end)
    button:connect_signal("mouse::leave", function()
        button.bg = base_color
        if base_color == beautiful.button_selected then
            button.fg = beautiful.fg_invert
        else
            button.fg = beautiful.fg_normal
        end
    end)

    local self =  {
        button = button,
        set_active = set_active,
        set_deactive = set_deactive,
        set_action = set_action,
    }
    table.insert(created_tab_buttons, self)

    return self
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
    local function scroll_to(i)
        local dis = i - current_tab
        if dis == 0 then return end

        -- pretty inefficient but idk the other way to do this
        for idx, cx in ipairs(current_x) do
            current_x[idx] = cx - (width + margins.left + margins.right) * dis
            tab_timed[idx].target = current_x[idx] + margins.left
        end
        current_tab = i
    end

    return {
        widget = wibox.widget {layout = scroller},
        scroll_to = scroll_to,
    }
end

return {
    arc_size = arc_size,
    create_arcchart = create_arcchart,
    create_dashboard_panel = create_dashboard_panel,
    create_button_bg = create_button_bg,
    create_button_fg = create_button_fg,
    create_tab_button = create_tab_button,
    h_scrollable = h_scrollable,
}