local gears = require("gears")

local color = {
    bg1     = "#1c1c1c",
    bg2     = "#000000",
    bg3     = "#292929",
    bg4     = "#363636",
    fg1     = "#424242",
    fg2     = "#bfbfbf",
    fg3     = "#ffffff",
    fg4     = "#ffffff",
    red     = "#ffffff",
    orange  = "#ffffff",
    yellow  = "#ffffff",
    green   = "#ffffff",
    cyan    = "#ffffff",
    blue    = "#ffffff",
    magenta = "#ffffff",
    pink    = "#ffffff",
}
color.accent1 = color.blue
color.accent2 = color.fg4

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/wind-turbine.png"

return {
    color = color,
    mods = mods,
}