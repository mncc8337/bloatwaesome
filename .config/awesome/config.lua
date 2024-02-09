return {
    openweathermap = {
        API_key = "open weather API key",
        latitude = 69,
        longtitude = 420,
    },
    theme = "catppuccin", -- catppuccin, monochrome

    tag_num = 4, -- should be no more than 12
    bar_size = 28,
    floating_bar = true,
    -- the space between bar (or dashboard and drop-down terminal if not floating bar) and screen border
    screen_spacing = 5,
    -- recommend: 12 if not floating bar
    --             5 if     floating bar

    terminal = "alacritty",
    editor = "code",

    modkey = "Mod4",
    altkey = "Mod1",

    profile_picture = "/home/mncc/.config/awesome/avt.png",

    -- interval to reload widget in second
    widget_interval = {
        cpu = 2,
        mem = 2,
        disk = 15 * 60,
        therm = 2
    },
    -- alsa device to control
    alsa_device = 0,
    -- cpu core to show usage, 0 for average
    core_id = 0,
    -- tempfile to get temperature
    -- run `find /sys/devices -type f -name "*temp*"` and choose a file here
    -- or set to nil to automatically find it
    tempfile = nil,

    hot_corners_size = 2,
}
