local gears = require("gears")

local color = {
    '#282828',
    '#3c3836',
    '#504945',
    '#665c54',
    '#bdae93',
    '#d5c4a1',
    '#ebdbb2',
    '#fbf1c7',
    '#fb4934',
    '#fe8019',
    '#fabd2f',
    '#b8bb26',
    '#8ec07c',
    '#83a598',
    '#d3869b',
    '#d65d0e'
}

local mods = {}
mods.wallpaper = gears.filesystem.get_configuration_dir().."/wallpapers/satellite.png"

return {
    color = color,
    mods = mods,
}
