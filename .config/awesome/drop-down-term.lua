--[[ drop down terminal ]]--
-- over-complicated animation support

local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local rubato    = require("rubato")

local term_current_action = "closed"
local term = nil
local dropdown_term_timed = rubato.timed {
    duration = 0.3,
    intro = 0.1,
    override_dt = true,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        if term == nil then return end
        term.y = pos
        if pos == -term.height and term_current_action == "closing" then
            term.hidden = true
            term_current_action = "closed"
        elseif pos == taskbar_size and term_current_action == "opening" then
            term_current_action = "opened"
        end
    end
}

local function dropdown_terminal_open()
    term:move_to_tag(awful.tag.selected())
    term.hidden = false
    client.focus = term
    term:raise()

    term_current_action = "opening"
    if awful.screen.focused().wibar.visible == true then
        dropdown_term_timed.target = taskbar_size + 10
        term.x = awful.screen.focused().geometry.width - 890 - beautiful.useless_gap * 2
    else
        dropdown_term_timed.target = 0
        term.x = awful.screen.focused().geometry.width - 890
    end
end
local function dropdown_terminal_close()
    if term then
        term_current_action = "closing"
        dropdown_term_timed.target = -term.height
    end
end

local function dropdown_terminal_toggle()
    term = find_client({class = "drop-down-terminal"})
    if not term then
        local pid = awful.spawn(terminal.." --class drop-down-terminal")
        local function init_term(c)
            if c.class == "drop-down-terminal" then
                term = c
                term:connect_signal("unfocus", function()
                    awesome.emit_signal("drop-down-term::close")
                end)

                dropdown_term_timed.pos = -term.height
                dropdown_term_timed.target = -term.height
                awesome.emit_signal("drop-down-term::open")
                client.disconnect_signal("manage", init_term)
            end
        end
        client.connect_signal("manage", init_term)
    else
        if term_current_action == "opened" or term_current_action == "opening" then
            awesome.emit_signal("drop-down-term::close")
        elseif term_current_action == "closed" or term_current_action == "closing" then
            awesome.emit_signal("drop-down-term::open")
        end
    end
end

-- close on click
local function hide_term_on_click()
    if term_current_action == "open" or term_current_action == "opening" then
        awesome.emit_signal("drop-down-term::close")
    end
end
awful.mouse.append_global_mousebinding(awful.button({}, 1, hide_term_on_click))
client.connect_signal("button::press", function(c)
    if c.class ~= "drop-down-terminal" then
        hide_term_on_click()
    end
end)

awesome.connect_signal("drop-down-term::open", dropdown_terminal_open)
awesome.connect_signal("drop-down-term::close", dropdown_terminal_close)
awesome.connect_signal("drop-down-term::toggle", dropdown_terminal_toggle)