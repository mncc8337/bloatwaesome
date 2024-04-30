local gears = require("gears")

local color = {
    '#171b24',
    '#1f2430',
    '#242936',
    '#707a8c',
    '#8a9199',
    '#cccac2',
    '#d9d7ce',
    '#f3f4f5',
    '#f28779',
    '#ffad66',
    '#ffd173',
    '#d5ff80',
    '#95e6cb',
    '#5ccfe6',
    '#d4bfff',
    '#f29e74'
}

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/evening-sky.png"

return {
    color = color,
    mods = mods,
}