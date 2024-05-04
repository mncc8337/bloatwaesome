local gears = require("gears")

local color = {
    bg1     = '#282828',
    bg2     = '#3c3836',
    bg3     = '#504945',
    bg4     = '#665c54',
    fg1     = '#bdae93',
    fg2     = '#d5c4a1',
    fg3     = '#ebdbb2',
    fg4     = '#fbf1c7',
    red     = '#fb4934',
    orange  = '#fe8019',
    yellow  = '#fabd2f',
    green   = '#b8bb26',
    cyan    = '#8ec07c',
    blue    = '#83a598',
    magenta = '#d3869b',
    pink    = '#d65d0e',
}
color.accent1 = color.orange
color.accent2 = color.fg2

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/satellite.png"

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
