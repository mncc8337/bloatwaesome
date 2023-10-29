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

function find_client_with_name(name_)
    local dropdown = function(c)
        return awful.rules.match(c, {name = name_})
    end
    local temp
    for c in awful.client.iterate(dropdown) do
         temp = c
    end
    return temp
end
function find_client_with_class(class_)
    local dropdown = function(c)
        return awful.rules.match(c, {class = class_})
    end
    local temp
    for c in awful.client.iterate(dropdown) do
         temp = c
    end
    return temp
end

--[[ drop down client ]]--
local rubato = require("rubato")
local term_current_action = "closed"
local term = nil
local timed = rubato.timed {
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

function dropdownterminal()
    term = nil
    term = find_client_with_name("drop-down-terminal")
    if not term then
        awful.spawn(terminal.." --title drop-down-terminal")
        term_current_action = "opened"
    else
        if term_current_action == "opened" or term_current_action == "opening" then
            term_current_action = "closing"
            timed.target = -term.height
        elseif term_current_action == "closed" or term_current_action == "closing" then
            term:move_to_tag(awful.tag.selected())
            term.hidden = false

            term_current_action = "opening"
            if awful.screen.focused().wibar.visible == true then
                timed.target = taskbar_size
            else
                timed.target = 0
            end

            client.focus = term
            term:raise()
        end
    end
end
tag.connect_signal("property::selected", function()
    if term ~= nil and not term.hidden then
        term_current_action = "closed"
        term.y = 0
        term.hidden = true
    end
end)

function utf8.sub(s, start_char_idx, end_char_idx)
    start_byte_idx = utf8.offset(s, start_char_idx)
    end_byte_idx = utf8.offset(s, end_char_idx + 1) - 1
    return string.sub(s, start_byte_idx, end_byte_idx)
end

function round_rect(r)
    return function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, r)
    end
end


--[[ I/O ]]--
local json = require("json")

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