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

-- get the first client that match the rule
function find_client(rule)
    local cl = function(c)
        return awful.rules.match(c, rule)
    end

    for c in awful.client.iterate(cl) do
        return c
    end
    return nil
end

function rounded_rect(size, corners)
    if corners then
        return function(cr, width, height)
            gears.shape.partially_rounded_rect(
                cr, width, height,
                corners.topleft, corners.topright, corners.bottomright, corners.bottomleft,
                size
            )
        end
    else
        return function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, size)
        end
    end
end

function single_timer(timeout, callback)
    return gears.timer {
        timeout = timeout,
        single_shot = true,
        callback = callback,
    }
end

-- run func(pid) if a process is running
function process_running(name, func)
    awful.spawn.easy_async_with_shell("pgrep -f "..name, function(stdout)
        if stdout ~= '' then func(stdout:gsub('\n', '')) end
    end)
end

--[[ I/O ]]--
local json = require("modules.json")

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

function markup_fg(color, str)
    return string.format("<span foreground='%s'>%s</span>", color, str)
end
function markup_bg(color, str)
    return string.format("<span background='%s'>%s</span>", color, str)
end
