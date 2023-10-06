--[[

     Licensed under GNU General Public License v2
      * (c) 2015, Luca CPZ

--]]

local helpers  = require("lain.helpers")
local json     = require("lain.util").dkjson
local focused  = require("awful.screen").focused
local naughty  = require("naughty")
local wibox    = require("wibox")
local math     = math
local os       = os
local string   = string
local type     = type
local tonumber = tonumber

-- OpenWeatherMap
-- current weather and X-days forecast
-- lain.widget.weather

local function factory(args)
    args                        = args or {}
    local weather               = { widget = args.widget or wibox.widget.textbox() }
    local APPID                 = args.APPID -- mandatory api key
    local timeout               = args.timeout or 900 -- 15 min
    local current_call          = args.current_call  or "curl -s 'https://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&APPID=%s&units=%s&lang=%s'"
    local forecast_call         = args.forecast_call or "curl -s 'https://api.openweathermap.org/data/2.5/forecast?lat=%s&lon=%s&APPID=%s&cnt=%s&units=%s&lang=%s'"
    local city_id               = 1565681
    local lat = args.lat
    local lon = args.lon
    local units                 = args.units or "metric"
    local lang                  = args.lang or "en"
    local cnt                   = args.cnt or 5
    local icons_path            = args.icons_path or helpers.icons_dir .. "openweathermap/"
    local notification_preset   = args.notification_preset or {}
    local notification_text_fun = args.notification_text_fun or
                                  function (wn)
                                      local day = os.date("%a %d", wn["dt"])
                                      local temp = math.floor(wn["main"]["temp"])
                                      local desc = wn["weather"][1]["description"]
                                      return string.format("<b>%s</b>: %s, %d ", day, desc, temp)
                                  end
    local weather_na_markup     = args.weather_na_markup or "<span font='Roboto Bold 25'></span>"
    local followtag             = args.followtag or false
    local settings              = args.settings or function() end
    local notification_text     = wibox.widget.textbox("hello")
    --notification_text.font = "Roboto 12"

    weather.widget:set_markup(weather_na_markup)
    weather.icon_path = icons_path .. "na.png"
    weather.icon = wibox.widget.imagebox(weather.icon_path)
    local ICO = wibox.widget.imagebox(weather.icon_path)
    ICO.forced_width = 100
    ICO.forced_height = 100

    local popup = awful.popup {
        visible = false,
        ontop = true,
        maximum_width = 1000,
        maximum_height = 1000,
        border_color = beautiful.border_focus,
        border_width = beautiful.border_width,
        widget = wibox.widget {
            layout = wibox.layout.align.horizontal,
            ICO,
            {
                widget = wibox.container.margin,
                margins = 5,
                notification_text,
            }
        }
    }
    local popup_timer = gears.timer {
        timeout = 0.08,
        single_shot = true,
        callback = function()
            popup.visible = false
        end
    }
    popup:connect_signal("mouse::enter", function() popup_timer:stop() end)
    popup:connect_signal("mouse::leave", function() popup_timer:again() end)
    function weather.show()
        weather.update()
        --weather.forecast_update()
        popup_timer:stop()
        popup.visible = true
        popup:move_next_to(mouse.current_widget_geometry)
    end

    function weather.hide()
        popup_timer:again()
    end

    function weather.attach(obj)
        obj:connect_signal("mouse::enter", function() weather.show() end)
        obj:connect_signal("mouse::leave", function() weather.hide() end)
    end

    --[[
    function weather.forecast_update()
        local cmd = string.format(forecast_call, city_id, APPID, cnt, units, lang)

        helpers.async(cmd, function(f)
            local err
            weather_now, _, err = json.decode(f, 1, nil)

            if not err and type(weather_now) == "table" and tonumber(weather_now["cod"]) == 200 then
                weather.notification_text.markup = ""
                for i = 1, weather_now["cnt"], math.floor(weather_now["cnt"] / cnt) do
                    weather.notification_text.markup = weather.notification_text.markup ..
                                                notification_text_fun(weather_now["list"][i])
                    if i < weather_now["cnt"] then
                        weather.notification_text.markup = weather.notification_text.markup .. "\n"
                    end
                end
            end
        end)
    end
    ]]--

    function weather.update()
        local cmd = string.format(current_call, lat, lon, APPID, units, lang)

        helpers.async(cmd, function(f)
            local err
            weather_now, _, err = json.decode(f, 1, nil)

            if not err and type(weather_now) == "table" and tonumber(weather_now["cod"]) == 200 then
                local sunrise = tonumber(weather_now["sys"]["sunrise"])
                local sunset  = tonumber(weather_now["sys"]["sunset"])
                local icon    = weather_now["weather"][1]["icon"]
                local loc_now = os.time()

                if sunrise <= loc_now and loc_now <= sunset then
                    icon = string.gsub(icon, "n", "d")
                else
                    icon = string.gsub(icon, "d", "n")
                end

                weather.icon_path = icons_path .. icon .. ".png"
                widget = weather.widget
                settings()
            else
                weather.icon_path = icons_path .. "na.png"
                weather.widget:set_markup(weather_na_markup)
            end

            weather.icon:set_image(weather.icon_path)
            ICO:set_image(weather.icon_path)
            notification_text.markup = notification_text_fun(weather_now)
        end)
    end

    weather.timer = helpers.newtimer("weather-" .. lat .. ":" .. lon, timeout, weather.update, false, true)
    --weather.timer_forecast = helpers.newtimer("weather_forecast-" .. lat .. ":" .. lon, timeout, weather.forecast_update, false, true)

    return weather
end

return factory
