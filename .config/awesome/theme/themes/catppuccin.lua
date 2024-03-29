-- contain modifications of `base.lua`

local gears = require("gears")

local color = {
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

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/yosemite.png"

return {
    color = color,
    mods = mods,
}