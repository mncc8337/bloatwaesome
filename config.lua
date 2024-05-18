local gears = require("gears")
local awesome_dir = gears.filesystem.get_configuration_dir()

return {
    openweathermap = {
        API_key    = "open weather API key",
        latitude   = 69,
        longtitude = 420,
        units      = "metric",
        lang       = "us",
        cnt        = 5,
    },
    theme = "gruvbox", -- catppuccin, monochrome, everforest, gruvbox, ayu-mirage, tomorrow, light, random

    tag_num = 6, -- should be no more than 12
    bar_size = 24,
    floating_bar = true,
    -- the space between dashboard and drop-down terminal and screen border if not floating bar
    -- the top margin of taskbar and screen border if floating bar
    screen_spacing = 12,
    -- recommend: 12 if not floating bar
    --             5 if     floating bar

    terminal    = "alacritty",
    filemanager = "nemo",
    editor      = "nvim",

    modkey = "Mod4",
    altkey = "Mod1",

    profile_picture = awesome_dir.."avt.png",

    -- interval to reload widget in second
    widget_interval = {
        cpu     = 2,
        mem     = 2,
        disk    = 15 * 60,
        therm   = 2,
        alsa    = 5 * 60,
        weather = 15 * 60,
    },
    -- mixer channel to control
    alsa_channel = "Master",
    -- volume slider length in taskbar, must be in float
    mini_volume_slider_length = 100.0,
    -- cpu core to show usage, 0 for average
    core_id = 0,
    -- tempfile to get temperature
    -- run `find /sys/devices -type f -name "*temp*"` and choose a file here
    -- or set to nil to automatically find it
    tempfile = nil,

    hot_corners_size = 2,
}
