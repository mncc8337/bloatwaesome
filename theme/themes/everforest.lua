local gears = require("gears")

local color = {
    bg1     = '#2f383e',
    bg2     = '#374247',
    bg3     = '#4a555b',
    bg4     = '#859289',
    fg1     = '#9da9a0',
    fg2     = '#d3c6aa',
    fg3     = '#e4e1cd',
    fg4     = '#fdf6e3',
    red     = '#7fbbb3',
    orange  = '#d699b6',
    yellow  = '#dbbc7f',
    green   = '#83c092',
    cyan    = '#e69875',
    blue    = '#a7c080',
    magenta = '#e67e80',
    pink    = '#eaedc8',
}
color.accent1 = color.blue
color.accent2 = color.green

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/forest.jpg"

mods.tag_color = {
    "#a7c080",
    "#a7c080",
    "#a7c080",
    "#a7c080",
    "#a7c080",
    "#a7c080",
    "#a7c080",
    "#a7c080",
    "#a7c080",
    "#a7c080",
    -------
    "#a7c080",
    "#a7c080",
}

return {
    color = color,
    mods = mods,
}
