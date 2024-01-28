--[[ drop down terminal ]]--
-- over-complicated animation support

local config    = require("config")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local rubato    = require("modules.rubato")

local term_opened = false
local term = nil
local pid = -1

local dropdown_term_timed = rubato.timed {
    duration = 0.3,
    intro = 0.1,
    override_dt = true,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        if term == nil then return end
        term.y = pos
        if pos == -term.height and not term_opened then
            term.hidden = true
        end
    end
}

local function dropdown_terminal_open()
    term:move_to_tag(awful.tag.selected())
    term.hidden = false
    client.focus = term
    term:raise()

    term_opened = true
    local offset = term.width + beautiful.border_width * 2
    dropdown_term_timed.target = config.bar_size
                                 + config.screen_spacing
                                 + (config.floating_bar and config.screen_spacing + beautiful.border_width * 2 or 0)
    term.x = (config.floating_bar and beautiful.useless_gap * 2 or config.screen_spacing)
end
local function dropdown_terminal_close()
    local function check_func(_pid)
        if _pid == '' then -- term died
            term = nil
        else
            term_opened = false
            dropdown_term_timed.target = -term.height
        end
    end
    -- check if term is alive or not
    awful.spawn.easy_async_with_shell("ps -p "..pid.." > /dev/null && echo sussybaka", check_func)
end

local function dropdown_terminal_toggle()
    local function check_func(_pid)
        if _pid == '' then -- term died
            pid = awful.spawn(config.terminal.." --class drop-down-terminal")
            local function init_term(c)
                if c.class == "drop-down-terminal" then
                    term = c

                    -- dropdown_term_timed.pos = -term.height
                    dropdown_term_timed.target = -term.height
                    awesome.emit_signal("drop-down-term::open")
                    client.disconnect_signal("manage", init_term)
                end
            end
            client.connect_signal("manage", init_term)
        else
            if term_opened then
                awesome.emit_signal("drop-down-term::close")
            else
                awesome.emit_signal("drop-down-term::open")
            end
        end
    end
    awful.spawn.easy_async_with_shell("ps -p "..pid.." > /dev/null && echo sussybaka", check_func)
end

-- close on click
local function hide_term_on_click()
    if term_opened then
        awesome.emit_signal("drop-down-term::close")
    end
end
awful.mouse.append_global_mousebinding(awful.button({}, 1, hide_term_on_click))
client.connect_signal("button::press", function(c)
    if c.class ~= "drop-down-terminal" then
        hide_term_on_click()
    end
end)

local function set_term(c)
    term = c
    pid = term.pid
end

awesome.connect_signal("drop-down-term::open", dropdown_terminal_open)
awesome.connect_signal("drop-down-term::close", dropdown_terminal_close)
awesome.connect_signal("drop-down-term::toggle", dropdown_terminal_toggle)
awesome.connect_signal("drop-down-term::set-term", set_term)

require("wibox").connect_signal("button::press", function(w)
    awesome.emit_signal("drop-down-term::close")
end)