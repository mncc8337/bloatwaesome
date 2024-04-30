local gears = require("gears")

local color = {
    '#2f383e',
    '#374247',
    '#4a555b',
    '#859289',
    '#9da9a0',
    '#d3c6aa',
    '#e4e1cd',
    '#fdf6e3',
    '#7fbbb3',
    '#d699b6',
    '#dbbc7f',
    '#83c092',
    '#e69875',
    '#a7c080',
    '#e67e80',
    '#eaedc8',
}

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