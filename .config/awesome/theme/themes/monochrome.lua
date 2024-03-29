local gears = require("gears")

local theme = {}

theme.color = {
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

    -- pink      = "#ffffff",
    -- maroon    = "#ffffff",
    -- sky       = "#ffffff",
    -- sapphire  = "#ffffff",
    -- subtext1  = "#a1a1a1",
    -- subtext0  = "#858585",
    -- overlay2  = "#737373",
    -- overlay1  = "#636363",
    -- overlay0  = "#525252",
    -- mantle    = "#1f1f1f",
}

theme.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/wind-turbine.png"

return theme