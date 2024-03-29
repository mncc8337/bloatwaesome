local beautiful = require("beautiful")
local gears = require("gears")

-- cursed
local function reload_color(theme, color)
    theme.mem_icon_color = color[11]
    theme.cpu_icon_color = color[14]
    theme.temp_icon_color = color[9]
    theme.filesys_icon_color = color[12]
    theme.music_icon_color_inactive = color[5]
    theme.music_icon_color_active = color[14]
    theme.volumebar_bg = color[2]
    theme.volumebar_fg = color[14]
    theme.music_progressbar_bg = color[2]
    theme.music_progressbar_fg = color[14]
    theme.musicplayer_primary_button_normal = color[5]
    theme.musicplayer_secondary_button_normal = color[3]
    theme.musicplayer_button_focus = color[6]
    theme.button_normal = color[3]
    theme.button_focus = color[2]
    theme.button_selected = color[8]
    theme.shutdown_button = color[9]
    theme.reboot_button   = color[12]
    theme.logout_button   = color[7]
    theme.sleep_button    = color[14]

    theme.profile_distro  = color[14]
    theme.profile_version = color[11]
    theme.profile_package = color[12]
    theme.profile_wm      = color[9]

    theme.launcher_bg = color[8]
    theme.launcher_fg = color[2]

    theme.separator = color[3]

    theme.arc_bg = color[2]

    theme.calendar_normal_bg = color[1]
    theme.calendar_normal_fg = color[5]
    theme.calendar_focus_bg = color[8]
    theme.calendar_focus_fg = color[2]
    theme.calendar_header_bg = color[1]
    theme.calendar_header_fg = color[6]
    theme.calendar_weekday_bg = color[1]
    theme.calendar_weekday_fg = color[6]
    theme.calendar_day_normal_bg = color[1]
    theme.calendar_day_hover_bg = color[3]
    -- theme.calendar_day_focus_bg = color.overlay1
    theme.panel_bg     = color[2]
    theme.panel_border = color[3]

    theme.titlebar_close_button    = color[9]
    theme.titlebar_minimize_button = color[11]
    theme.titlebar_ontop_button   = color[14]
    theme.titlebar_sticky_button    = color[12]
    theme.titlebar_button_inactive = color[3]
    -- theme.bg_focus = color.subtext0
    theme.bg_normal = color[1]
    theme.bg_urgent = color[14]
    -- theme.bg_minimize = color.overlay0
    theme.bg_systray = color[1]
    theme.fg_normal = color[6]
    theme.fg_invert = color[2]
    theme.fg_focus = theme.fg_normal
    theme.fg_urgent = theme.fg_normal
    theme.fg_minimize = theme.fg_normal
    theme.tooltip_bg = color[1]
    theme.layoutlist_bg_selected = color[4]
    theme.tasklist_bg_normal = color[4]
    theme.tasklist_bg_focus = color[8]
    theme.tasklist_bg_minimize = color[1]
    theme.tasklist_bg_urgent = color[15]
    theme.hotkeys_modifiers_fg = color[14]
    theme.border_normal = color[2]
    theme.border_focus = color[8]
    theme.border_marked = color[11]
    theme.taglist_bg_focus = color[1]
    theme.taglist_fg_not_focus = color[5]
    theme.taglist_bg_urgent = color[14]
    theme.tag_color = {
        color[14],
        color[9],
        color[12],
        color[11],
        color[16],
        color[8],
        color[7],
        color[15],
        color[13],
        color[10],
        -------
        color[6],
        color[14],
    }
    theme.notification_bg = color[1]
    theme.notification_border_color = theme.border_focus
end

local function load_theme(theme)
    local base = require("theme.base")
    local modifications = require("theme.themes."..theme)
    local final = {}

    gears.table.crush(final, base)

    if modifications.color then
        reload_color(final, modifications.color)
    end

    gears.table.crush(final, modifications)

    beautiful.init(final)
end
local function load_base()
    local base = require("theme.base")
    beautiful.init(base)
end

return {
    load = load_theme,
    load_base = load_base,
}