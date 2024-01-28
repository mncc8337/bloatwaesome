local gears = require("gears")

local theme = {}

theme.color = {
    rosewater = "#ffffff",
    flamingo  = "#ffffff",
    pink      = "#ffffff",
    mauve     = "#ffffff",
    red       = "#ffffff",
    maroon    = "#ffffff",
    peach     = "#ffffff",
    yellow    = "#ffffff",
    green     = "#ffffff",
    teal      = "#ffffff",
    sky       = "#ffffff",
    sapphire  = "#ffffff",
    blue      = "#ffffff",
    lavender  = "#ffffff",
    text      = "#bfbfbf",
    subtext1  = "#a1a1a1",
    subtext0  = "#858585",
    overlay2  = "#737373",
    overlay1  = "#636363",
    overlay0  = "#525252",
    surface2  = "#424242",
    surface1  = "#363636",
    surface0  = "#292929",
    base      = "#1c1c1c",
    mantle    = "#1f1f1f",
    crust     = "#000000",
}

theme.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/wind-turbine.png"

return theme