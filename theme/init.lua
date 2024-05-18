local beautiful = require("beautiful")
local gears = require("gears")

local function load_theme(theme)
    local base = require("theme.base")
    local theme = require("theme.themes."..theme)

    local THEME = base.get_theme(theme.color)
    gears.table.crush(THEME, theme.mods)

    beautiful.init(THEME)
end

return {
    load = load_theme
}