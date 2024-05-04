local gears = require("gears")

local color = {
    bg1     = '#171b24',
    bg2     = '#1f2430',
    bg3     = '#242936',
    bg4     = '#707a8c',
    fg1     = '#8a9199',
    fg2     = '#cccac2',
    fg3     = '#d9d7ce',
    fg4     = '#f3f4f5',
    red     = '#f28779',
    orange  = '#ffad66',
    yellow  = '#ffd173',
    green   = '#d5ff80',
    cyan    = '#95e6cb',
    blue    = '#5ccfe6',
    magenta = '#d4bfff',
    pink    = '#f29e74',
}
color.accent1 = color.blue
color.accent2 = color.fg4

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/evening-sky.png"

return {
    color = color,
    mods = mods,
}