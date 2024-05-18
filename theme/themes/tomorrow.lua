local gears = require("gears")

local color = {
    bg1     = '#ffffff',
    bg2     = '#e0e0e0',
    bg3     = '#d6d6d6',
    bg4     = '#8e908c',
    fg1     = '#969896',
    fg2     = '#4d4d4c',
    fg3     = '#282a2e',
    fg4     = '#1d1f21',
    red     = '#c82829',
    orange  = '#f5871f',
    yellow  = '#eab700',
    green   = '#718c00',
    cyan    = '#3e999f',
    blue    = '#4271ae',
    magenta = '#8959a8',
    pink    = '#a3685a',
}
color.accent1 = color.blue
color.accent2 = color.cyan

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/lavender.jpg"

return {
    color = color,
    mods = mods,
}