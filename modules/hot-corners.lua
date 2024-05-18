local gears = require("gears")
local awful = require("awful")

local nothing = function()
    -- notify("ngu")
end


local corner_action = {
    nothing,
    nothing,
    nothing,
    nothing,
}

local hot_corners_size = 10

local previously_toggle = {false, false, false, false}

local daemon = gears.timer {
    autostart = true,
    timeout = 0.2,
    callback = function()
        local geometry = awful.screen.focused().geometry
        local top = mouse.coords().y < hot_corners_size
        local bottom = mouse.coords().y > geometry.height - hot_corners_size
        local left = mouse.coords().x < hot_corners_size
        local right = mouse.coords().x > geometry.width - hot_corners_size

        local condition = {
            top and left,
            top and right,
            bottom and left,
            bottom and right
        }
        
        for i = 1, 4 do
            if condition[i] then
                if not previously_toggle[i] then
                    corner_action[i]()
                    previously_toggle[i] = true
                end
            else previously_toggle[i] = false end
        end
    end
}

local function change_action_1(a)
    corner_action[1] = a
end
local function change_action_2(a)
    corner_action[2] = a
end
local function change_action_3(a)
    corner_action[3] = a
end
local function change_action_4(a)
    corner_action[4] = a
end

local function set_corner_size(s)
    hot_corners_size = s
end

return {
    topleft = change_action_1,
    topright = change_action_2,
    bottomleft = change_action_3,
    bottomright = change_action_4,
    set_corner_size = set_corner_size,
}