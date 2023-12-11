local gears = require("gears")
local awful = require("awful")

-- global so we can change it from different location
topleft_action = function()
    -- notify("topleft")
end
topright_action = function()
    -- notify("topright")
end
bottomleft_action = function()
    -- notify("bottomleft")
end
bottomright_action = function()
    -- notify("bottomright")
end

local hot_corners_size = 10

local previously_toggle = {false, false, false, false}

local daemon = gears.timer {
    autostart = true,
    timeout = 0.5,
    callback = function()
        local geometry = awful.screen.focused().geometry
        if mouse.coords().x < hot_corners_size then
            if mouse.coords().y < hot_corners_size then
                if previously_toggle[1] then return end
                topleft_action()
                previously_toggle[1] = true
            elseif mouse.coords().y > geometry.height - hot_corners_size then
                if previously_toggle[2] then return end
                bottomleft_action()
                previously_toggle[2] = true
            else
                previously_toggle[1] = false
                previously_toggle[2] = false
            end
        elseif mouse.coords().x > geometry.width - hot_corners_size then
            if mouse.coords().y < hot_corners_size then
                if previously_toggle[3] then return end
                topright_action()
                previously_toggle[3] = true
            elseif mouse.coords().y > geometry.height - hot_corners_size then
                if previously_toggle[4] then return end
                bottomright_action()
                previously_toggle[4] = true
            else
                previously_toggle[3] = false
                previously_toggle[4] = false
            end
        else
            previously_toggle[1] = false
            previously_toggle[2] = false
            previously_toggle[3] = false
            previously_toggle[4] = false
        end
    end
}