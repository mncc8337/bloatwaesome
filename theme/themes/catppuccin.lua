local gears = require("gears")

local color = {
    bg1     = "#1e1e2e",
    bg2     = "#11111b",
    bg3     = "#313244",
    bg4     = "#45475a",
    fg1     = "#585b70",
    fg2     = "#cdd6f4",
    fg3     = "#f5e0dc",
    fg4     = "#b4befe",
    red     = "#f38ba8",
    orange  = "#fab387",
    yellow  = "#f9e2af",
    green   = "#a6e3a1",
    cyan    = "#94e2d5",
    blue    = "#89b4fa",
    magenta = "#cba6f7",
    pink    = "#f2cdcd",
}
color.accent1 = color.blue
color.accent2 = color.fg4

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/yosemite.png"

return {
    color = color,
    mods = mods,
}