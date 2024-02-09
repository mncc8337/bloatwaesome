-- contain modifications of `base.lua`

local gears = require("gears")

local theme = {}

theme.color = {
    "#1e1e2e" , -- base
    "#11111b" , -- crust
    "#313244" , -- surface0
    "#45475a" , -- surface1
    "#585b70" , -- surface2
    "#cdd6f4" , -- text
    "#f5e0dc" , -- rosewater
    "#b4befe" , -- lavender
    "#f38ba8" , -- red
    "#fab387" , -- peach
    "#f9e2af" , -- yellow
    "#a6e3a1" , -- green
    "#94e2d5" , -- teal
    "#89b4fa" , -- blue
    "#cba6f7" , -- mauve
    "#f2cdcd" , -- flamingo
}
theme._color = {
    base      = theme.color[1],
    crust     = theme.color[2],
    surface0  = theme.color[3],
    surface1  = theme.color[4],
    surface2  = theme.color[5],
    text      = theme.color[6],
    rosewater = theme.color[7],
    lavender  = theme.color[8],
    red       = theme.color[9],
    peach     = theme.color[10],
    yellow    = theme.color[11],
    green     = theme.color[12],
    teal      = theme.color[13],
    blue      = theme.color[14],
    mauve     = theme.color[15],
    flamingo  = theme.color[16],
}

theme.wallpaper = gears.filesystem.get_configuration_dir().."wallpapers/yosemite.png"

return theme