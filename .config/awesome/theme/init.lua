local beautiful = require("beautiful")
local gears = require("gears")

-- cursed
local function reload_color(theme, color)
    theme.mem_icon_color = color.yellow
    theme.cpu_icon_color = color.blue
    theme.temp_icon_color = color.red
    theme.filesys_icon_color = color.green
    theme.music_icon_color_inactive = color.overlay0
    theme.music_icon_color_active = color.blue
    theme.volumebar_bg = color.crust
    theme.volumebar_fg = color.blue
    theme.music_progressbar_bg = color.crust
    theme.music_progressbar_fg = color.blue
    theme.musicplayer_primary_button_normal = color.surface2
    theme.musicplayer_secondary_button_normal = color.surface0
    theme.musicplayer_button_focus = color.text
    theme.button_normal = color.surface0
    theme.button_focus = color.crust
    theme.button_selected = color.lavender
    theme.calendar_normal_bg = color.base
    theme.calendar_normal_fg = color.subtext0
    theme.calendar_focus_bg = color.lavender
    theme.calendar_focus_fg = color.crust
    theme.calendar_header_bg = color.base
    theme.calendar_header_fg = color.text
    theme.calendar_weekday_bg = color.base
    theme.calendar_weekday_fg = color.text
    theme.calendar_day_normal_bg = color.base
    theme.calendar_day_hover_bg = color.surface0
    theme.calendar_day_focus_bg = color.overlay1
    theme.dashboard_bg = color.crust
    theme.bg_focus = color.subtext0
    theme.bg_normal = color.base
    theme.bg_urgent = color.blue
    theme.bg_minimize = color.overlay0
    theme.bg_systray = color.base
    theme.fg_normal = color.text
    theme.fg_invert = color.crust
    theme.fg_focus = theme.fg_normal
    theme.fg_urgent = theme.fg_normal
    theme.fg_minimize = theme.fg_normal
    theme.tooltip_bg = color.base
    theme.layoutlist_bg_selected = color.surface1
    theme.tasklist_bg_normal = color.surface1
    theme.tasklist_bg_focus = color.lavender
    theme.tasklist_bg_minimize = color.base
    theme.tasklist_bg_urgent = color.mauve
    theme.hotkeys_modifiers_fg = color.blue
    theme.border_normal = color.surface1
    theme.border_focus = color.lavender
    theme.border_marked = color.yellow
    theme.taglist_bg_focus = color.base
    theme.taglist_fg_not_focus = color.surface2
    theme.taglist_bg_urgent = color.blue
    theme.tag_color = {
        color.blue,
        color.red,
        color.green,
        color.yellow,
        color.flamingo,
        color.lavender,
        color.rosewater,
        color.pink,
        color.mauve,
        color.maroon,
        color.sky,
        color.teal,
    }
    theme.tabbar_bg_focus = color.lavender
    theme.tabbar_bg_normal = color.base
    theme.tabbar_fg_focus = color.base
    theme.tabbar_fg_normal = color.text
    theme.notification_bg = color.base
end

local function load_theme(theme)
    local base = require("theme.base")
    local modifications = require("theme.themes."..theme)
    local final = {}

    gears.table.crush(final, base)
    gears.table.crush(final, modifications)

    if modifications.color then
        reload_color(final, modifications.color)
    end

    beautiful.init(final)
end

return {
    load = load_theme
}