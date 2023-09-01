local lain = require("lain")

local lain_weather = lain.widget.weather {
    APPID = "880023f5747dbe369798eb5e34244c70",
    units = "metric",
    lat = 16.404138,
    lon = 107.685390,
    cnt = 1,
    settings = function()
        units = math.floor(weather_now["main"]["temp"]+.5)
        widget:set_markup(units .. "°C ")
    end,
    notification_text_fun = function(wn)
        local  day = os.date("%a %d %H:%M", wn["dt"])
        local desc = wn["weather"][1]["description"]
        local temp = tostring(wn["main"]["temp"])
        local tfeel= tostring(wn["main"]["feels_like"])
        local pres = tostring(wn["main"]["pressure"])
        local humi = tostring(wn["main"]["humidity"])
        local wspe = tostring(wn["wind"]["speed"])
        local wdeg = tostring(wn["wind"]["deg"])
        local clou = tostring(wn["clouds"]["all"])
        local visb = tostring(wn["visibility"]/1000)
        local sset = os.date("%H:%M", wn["sys"]["sunset"])
        local rise = os.date("%H:%M", wn["sys"]["sunrise"])
        return "<span font='Dosis bold 12'>"..day.."</span>, "..desc..'\n'.."<span font='Dosis 12'>"..
               " "..temp.."°C, * "..tfeel.."°C\n"..
               " "..pres.."hPa,  "..humi.."%\n"..
               "   "..wspe.."m/s,   "..wdeg.."°\n"..
               "   "..clou.."%,    "..visb.."km\n"..
               "   "..rise..",    "..sset.."</span>"
    end,
}
lain_weather.widget.align = "center"
lain_weather.update()

local weatherwidget = wibox.widget {
    widget = wibox.container.margin,
    right = widget_spacing,
    wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        {
            lain_weather.icon,
            widget = wibox.container.margin,
            right = -3,
            left = -5
        },
        lain_weather,
        widget = wibox.container
    }
}
lain_weather.attach(weatherwidget)

return weatherwidget