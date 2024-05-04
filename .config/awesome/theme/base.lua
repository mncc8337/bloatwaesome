local gears        = require("gears")
local naughty      = require("naughty")

local beautiful   = require('beautiful')
local dpi         = beautiful.xresources.apply_dpi
local awesome_dir = gears.filesystem.get_configuration_dir()

local function get_theme(color)
    local theme = {}
    theme.color = color

    theme.font_type = {
        standard = "Roboto",
        mono     = "CaskaydiaMono NF",
        icon     = "Symbols Nerd Font",
    }
    theme.font_size = 12

    --[[ icons ]]--
    theme.mem_icon_color            = theme.color.yellow
    theme.cpu_icon_color            = theme.color.blue
    theme.temp_icon_color           = theme.color.red
    theme.filesys_icon_color        = theme.color.green

    theme.music_icon_color_inactive = theme.color.fg1
    theme.music_icon_color_active   = theme.color.accent1

    --[[ widgets ]]--
    theme.volumebar_bg = theme.color.bg2
    theme.volumebar_fg = theme.color.accent1

    theme.music_progressbar_bg = theme.color.bg2
    theme.music_progressbar_fg = theme.color.accent1

    theme.musicplayer_primary_button_normal   = theme.color.bg4
    theme.musicplayer_secondary_button_normal = theme.color.bg3
    theme.musicplayer_button_focus            = theme.color.fg2

    theme.button_normal   = theme.color.bg3
    theme.button_focus    = theme.color.bg2
    theme.button_selected = theme.color.accent2

    theme.shutdown_button = theme.color.red
    theme.reboot_button   = theme.color.green
    theme.logout_button   = theme.color.fg3
    theme.sleep_button    = theme.color.blue

    theme.profile_distro  = theme.color.blue
    theme.profile_version = theme.color.yellow
    theme.profile_package = theme.color.green
    theme.profile_wm      = theme.color.red

    theme.launcher_bg = theme.color.accent2
    theme.launcher_fg = theme.color.bg2

    theme.separator = theme.color.bg3

    theme.arc_bg = theme.color.bg2

    --[[ calendar ]]--
    theme.calendar_normal_bg = theme.color.bg1
    theme.calendar_normal_fg = theme.color.subfg20

    theme.calendar_focus_bg = theme.color.accent2
    theme.calendar_focus_fg = theme.color.bg2

    theme.calendar_header_bg = theme.color.bg1
    theme.calendar_header_fg = theme.color.fg2

    theme.calendar_weekday_bg = theme.color.bg1
    theme.calendar_weekday_fg = theme.color.fg2

    theme.calendar_day_normal_bg = theme.color.bg1
    theme.calendar_day_hover_bg  = theme.color.bg3

    theme.calendar_button_bg = theme.color.bg3
    theme.calender_button_fg = theme.color.fg2

    --[[ panel ]]--
    theme.dashboard_width   = 450
    theme.timeweather_width = 400
    theme.panel_bg     = theme.color.bg2
    theme.panel_border = theme.color.bg3

    --[[ notification panel ]]--
    theme.notification_title_bg = theme.color.bg3

    --[[ titlebar ]]--
    theme.titlebar_close_button    = theme.color.red
    theme.titlebar_minimize_button = theme.color.yellow
    theme.titlebar_ontop_button    = theme.color.blue
    theme.titlebar_sticky_button   = theme.color.green
    theme.titlebar_button_inactive = theme.color.bg3

    --[[ idk ]]--
    theme.font = theme.font_type.standard..' '..theme.font_size

    -- theme.bg_focus      = theme.color.subfg20
    theme.bg_normal     = theme.color.bg1
    theme.bg_urgent     = theme.color.accent1
    -- theme.bg_minimize   = theme.color.fg1
    theme.bg_systray    = theme.color.bg1

    theme.fg_normal     = theme.color.fg2
    theme.fg_invert     = theme.color.bg2
    theme.fg_focus      = theme.fg_normal
    theme.fg_urgent     = theme.fg_normal
    theme.fg_minimize   = theme.fg_normal

    theme.tooltip_bg = theme.color.bg1
    theme.layoutlist_bg_selected = theme.color.bg4

    theme.tasklist_bg_normal   = theme.color.bg4
    theme.tasklist_bg_focus    = theme.color.accent2
    theme.tasklist_bg_minimize = theme.color.bg1
    theme.tasklist_bg_urgent   = theme.color.magenta

    theme.hotkeys_modifiers_fg     = theme.color.accent1
    theme.hotkeys_font             = theme.font_type.mono..' '..theme.font_size
    theme.hotkeys_description_font = theme.font_type.mono..' '..theme.font_size

    theme.useless_gap   = dpi(10)
    theme.border_width  = dpi(2)
    theme.border_normal = theme.color.bg2
    theme.border_focus  = theme.color.fg1
    theme.border_marked = theme.color.yellow

    theme.popup_roundness = 5

    --[[ image icon ]]--
    theme.layout_tile       = awesome_dir.."icon/layout/tile.png"
    theme.layout_tileleft   = awesome_dir.."icon/layout/tileleft.png"
    theme.layout_floating   = awesome_dir.."icon/layout/floating.png"
    theme.layout_centered   = awesome_dir.."icon/layout/centered.png"

    theme.wallpaper = awesome_dir.."/wallpapers/squares.png"

    theme.icon_theme = "Papirus"

    --[[ taglist ]]--
    theme.taglist_bg_focus     = theme.color.bg1
    theme.taglist_fg_not_focus = theme.color.fg1
    theme.taglist_bg_urgent    = theme.color.accent1
    theme.taglist_spacing      = dpi(2)

    -- each tag has a unique color
    theme.tag_color = {
        theme.color.blue,
        theme.color.red,
        theme.color.green,
        theme.color.yellow,
        theme.color.pink,
        theme.color.fg4,
        theme.color.fg3,
        theme.color.magenta,
        theme.color.cyan,
        theme.color.orange,
       -------
        theme.color.fg2,
        theme.color.blue,
    }

    --[[ bling ]]--
    -- prioritize mpd, deprioritize chromium
    theme.playerctl_player  = {"mpd", "%any", "chromium"}

    -- theme.flash_focus_start_opacity = 0.8
    -- theme.flash_focus_step = 0.01

    --[[ notification ]]--
    theme.notification_font = theme.font_type.standard..' '..theme.font_size
    theme.notification_bg = theme.color.bg1
    theme.notification_shape = rounded_rect(theme.popup_roundness)
    theme.notification_border_color = theme.border_focus
    -- theme.notification_max_width = 500
    -- change theme.notification_border_width does nothing
    naughty.config.defaults.border_width = theme.border_width

    return theme
end

return {
    get_theme = get_theme,
}