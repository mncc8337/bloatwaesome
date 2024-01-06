return {
    awesome_dir = debug.getinfo(1, 'S').source:match[[^@(.*/).*$]],
    openweathermap = {
        API_key = "open weather API key",
        latitude = 69,
        longtitude = 420,
    },
    theme = "catppuccin", -- catppuccin, monochrome

    tag_num = 4, -- should be no more than 12
    bar_size = 28,
    floating_bar = true,

    terminal = "alacritty",
    editor = "code",

    modkey = "Mod4",
    altkey = "Mod1",

    profile_picture = "/home/mncc/.config/awesome/avt.png",

    -- alsa device to control
    alsa_device = 0,

    popup_roundness = 5,
    dashboard_width = 500,
}
