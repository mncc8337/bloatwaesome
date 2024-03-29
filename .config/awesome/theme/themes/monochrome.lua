local gears = require("gears")

local color = {
    "#1c1c1c",
    "#000000",
    "#292929",
    "#363636",
    "#424242",
    "#bfbfbf",
    "#ffffff",
    "#ffffff",
    "#ffffff",
    "#ffffff",
    "#ffffff",
    "#ffffff",
    "#ffffff",
    "#ffffff",
    "#ffffff",
    "#ffffff",
}

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/wind-turbine.png"

return {
    color = color,
    mods = mods,
}