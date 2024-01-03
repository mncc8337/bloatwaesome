local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")

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

function split_str(inputstr, sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

--[[ I/O ]]--
local json = require("modules.json")

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