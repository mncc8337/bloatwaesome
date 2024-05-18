local gears = require("gears")

local color = {
    bg1     = '#CED4E5',
    bg2     = '#B2B7D7',
    bg3     = '#A8AAD1',
    bg4     = '#868CBE',
    fg1     = '#6D719E',
    fg2     = '#63658D',
    fg3     = '#605A7C',
    fg4     = '#49445A',
    red     = '#e05e5e',
    orange  = '#e0a15e',
    yellow  = '#d4b942',
    green   = '#42d47c',
    cyan    = '#5ee0cd',
    blue    = '#5e83e0',
    magenta = '#945ee0',
    pink    = '#dc5ee0',
}

color.accent1 = color.blue
color.accent2 = color.bg4

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/birbs.png"

mods.mem_icon_color     = color.blue
mods.cpu_icon_color     = color.blue
mods.temp_icon_color    = color.blue
mods.filesys_icon_color = color.blue

mods.profile_distro  = color.blue
mods.profile_version = color.blue
mods.profile_package = color.blue
mods.profile_wm      = color.blue

mods.shutdown_button = color.red
mods.reboot_button   = color.yellow
mods.logout_button   = color.fg3
mods.sleep_button    = color.blue


mods.tag_color = {
    color.red,
    color.orange,
    color.yellow,
    color.green,
    color.cyan,
    color.blue,
    color.magenta,
    color.pink,
}

return {
    color = color,
    mods = mods,
}
