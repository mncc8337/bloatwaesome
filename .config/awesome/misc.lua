local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

--[[ centered thing ]]--
function h_centered_widget(widget)
    local placeholder = wibox.widget {}
    local w = {
        layout = wibox.layout.align.horizontal,
        expand = "outside",
        placeholder, widget, placeholder
    }
    return w
end
function v_centered_widget(widget)
    local placeholder = wibox.widget {}
    local w = {
        layout = wibox.layout.align.vertical,
        expand = "outside",
        placeholder, widget, placeholder
    }
    return w
end
function centered_widget(widget)
    local w = h_centered_widget(widget)
    w = v_centered_widget(w)
    return w
end

function find_client(rule)
    local dropdown = function(c)
        return awful.rules.match(c, rule)
    end
    local temp = nil
    for c in awful.client.iterate(dropdown) do
        temp = c
    end
    return temp
end

--[[ drop down terminal ]]--
-- over-complicated animation support
local rubato = require("rubato")
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

function dropdown_terminal_open()
    term:move_to_tag(awful.tag.selected())
    term.hidden = false
    client.focus = term
    term:raise()

    term_current_action = "opening"
    if awful.screen.focused().wibar.visible == true then
        dropdown_term_timed.target = taskbar_size
    else
        dropdown_term_timed.target = 0
    end
end
function dropdown_terminal_close()
    term_current_action = "closing"
    dropdown_term_timed.target = -term.height
end

function dropdown_terminal_toggle()
    term = find_client({class = "drop-down-terminal"})
    if not term then
        local pid = awful.spawn(terminal.." --class drop-down-terminal")
        local function init_term(c)
            if c.class == "drop-down-terminal" then
                term = c
                term:connect_signal("unfocus", dropdown_terminal_close)

                dropdown_term_timed.pos = -term.height
                dropdown_term_timed.target = -term.height
                dropdown_terminal_open()
                client.disconnect_signal("manage", init_term)
            end
        end
        client.connect_signal("manage", init_term)
    else
        if term_current_action == "opened" or term_current_action == "opening" then
            dropdown_terminal_close()
        elseif term_current_action == "closed" or term_current_action == "closing" then
            dropdown_terminal_open()
        end
    end
end

function utf8.sub(s, start_char_idx, end_char_idx)
    start_byte_idx = utf8.offset(s, start_char_idx)
    end_byte_idx = utf8.offset(s, end_char_idx + 1) - 1
    return string.sub(s, start_byte_idx, end_byte_idx)
end

function rounded_rect(r)
    return function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, r)
    end
end

function single_timer(timeout, callback)
    return gears.timer {
        timeout = timeout,
        single_shot = true,
        callback = callback,
    }
end

--[[ I/O ]]--
local json = require("json")

-- TODO: use lua func instead
function save_to_file(text, file)
    awful.spawn.with_shell("printf '"..text.."' > "..file)
end
function read_file(file)
    return io.popen("cat "..file):read("*all")
end
function read_json(file)
    local content = read_file(file)
    return json.decode(content)
end
function save_json(content, file)
    local encoded = json.encode(content)
    save_to_file(encoded, file)
end