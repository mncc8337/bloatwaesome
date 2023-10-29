local awful = require("awful")

local floating_client_geometries = {}
local prev_floating_client_geometries = {}
local unmaximized_state = {}
local clients_screens = {}
client.connect_signal("property::geometry", function(c)
    clients_screens[c.window] = c.screen
    if
        awesome.startup or
        awful.layout.get(awful.screen.focused()) ~= awful.layout.suit.floating
    then
        return
    end
    unmaximized_state[c.window] = not c.maximized
    if c.maximized then
        return
    end
    if floating_client_geometries[c.window] then
        prev_floating_client_geometries[c.window] = floating_client_geometries[c.window]
    end
    floating_client_geometries[c.window] = c:geometry()
end)

tag.connect_signal("property::layout", function(t)
    if t.layout == awful.layout.suit.floating then
        for _, c in ipairs(t:clients()) do
            if
                floating_client_geometries and
                unmaximized_state and
                floating_client_geometries[c.window] and
                unmaximized_state[c.window]
            then
                c:geometry(floating_client_geometries[c.window])
            end
        end
    else
        for _, c in ipairs(t:clients()) do c.maximized = false end
    end

end)

client.connect_signal("property::maximized", function(c)
    if
        c.maximized or
        awful.layout.get(awful.screen.focused()) ~= awful.layout.suit.floating
    then
        return
    end
    if prev_floating_client_geometries[c.window] then
        c:geometry(prev_floating_client_geometries[c.window])
    else
        c.screen = clients_screens[c.window]
    end
end)

client.connect_signal("manage", function (c)
    --[[
    local g = c.screen.geometry
    floating_client_geometries[c.window] = c:geometry({
        x = g.width / 6,
        y = g.height / 6,
        width = g.width / 1.5,
        height = g.height / 1.5
    })
    ]]--
    floating_client_geometries[c.window] = c:geometry()
    prev_floating_client_geometries[c.window] = nil
end)
