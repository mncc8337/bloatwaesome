-- signals
--[[
    weather::update, get info
    weather::current, current weather data
    weather::forecast, forecast weather data
]]--

local awful  = require("awful")
local gears  = require("gears")
local config = require("config")
local json   = require("modules.json")

local awesome_dir = require("gears").filesystem.get_configuration_dir()

local function current_func(stdout)
    local dat = nil

    -- cannot get data
    if stdout == "" then
        dat = {}
        dat["cod"] = 1
        dat["icon_image"] = awesome_dir.."icon/openweathermap/na.png"
    else
        -- see https://openweathermap.org/current
        -- for dat usage
        dat = json.decode(stdout)
    end


    -- if success
    if dat["cod"] == 200 then
        -- local sunrise = tonumber(weather_now["sys"]["sunrise"])
        -- local sunset  = tonumber(weather_now["sys"]["sunset"])
        -- local icon    = weather_now["weather"][1]["icon"]
        -- local loc_now = os.time()

        -- if sunrise <= loc_now and loc_now <= sunset then
        --     icon = string.gsub(icon, "n", "d")
        -- else
        --     icon = string.gsub(icon, "d", "n")
        -- end

        -- add an additional field
        dat["icon_image"] = awesome_dir.."icon/openweathermap/"..dat["weather"][1]["icon"]..".png"
    else
        dat["icon_image"] = awesome_dir.."icon/openweathermap/na.png"
    end
    awesome.emit_signal("weather::current", dat)
end

local function forecast_func(stdout)
    local dat = nil
    
    -- cannot get data
    if stdout == "" then
        dat = {}
        dat["cod"] = 1
        dat["icon_image"] = awesome_dir.."icon/openweathermap/na.png"
    else
        dat = json.decode(stdout)
    end
    
    -- if success
    if dat["cod"] == 200 then
        awesome.emit_signal("weather::forecast", dat)
    end
end

local current_call  = "curl -s 'https://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&appid=%s&units=%s&lang=%s'"
local forecast_call = "curl -s 'https://api.openweathermap.org/data/2.5/forecast?lat=%s&lon=%s&appid=%s&cnt=%s&units=%s&lang=%s'"

current_call   = current_call:format(config.openweathermap.latitude,
                                     config.openweathermap.longtitude,
                                     config.openweathermap.API_key,
                                     config.openweathermap.units,
                                     config.openweathermap.lang)
forecast_call = forecast_call:format(config.openweathermap.latitude,
                                     config.openweathermap.longtitude,
                                     config.openweathermap.API_key,
                                     config.openweathermap.cnt,
                                     config.openweathermap.units,
                                     config.openweathermap.lang)

awesome.connect_signal("weather::update", function()
    awful.spawn.easy_async(current_call, current_func)
    awful.spawn.easy_async(forecast_call, forecast_func)
end)

awesome.emit_signal("weather::update")
gears.timer {
    timeout = config.widget_interval.weather,
    single_shot = false, autostart = true,
    callback = function()
        awesome.emit_signal("weather::update")
    end
}