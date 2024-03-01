local gears        = require("gears")
local naughty      = require("naughty")

local beautiful = require('beautiful')
local dpi       = beautiful.xresources.apply_dpi
local awesome_dir = gears.filesystem.get_configuration_dir()

local theme = {}

-- cappuccin mocha
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
theme.font_type = {
    standard = "Roboto",
    mono     = "CaskaydiaMono NF",
    icon     = "Symbols Nerd Font",
}
theme.font_size = 12

--[[ icons ]]--
theme.mem_icon_color            = theme._color.yellow
theme.cpu_icon_color            = theme._color.blue
theme.temp_icon_color           = theme._color.red
theme.filesys_icon_color        = theme._color.green
theme.music_icon_color_inactive = theme._color.surface2
theme.music_icon_color_active   = theme._color.blue

--[[ widgets ]]--
theme.volumebar_bg = theme._color.crust
theme.volumebar_fg = theme._color.blue

theme.music_progressbar_bg = theme._color.crust
theme.music_progressbar_fg = theme._color.blue

theme.musicplayer_primary_button_normal   = theme._color.surface2
theme.musicplayer_secondary_button_normal = theme._color.surface0
theme.musicplayer_button_focus            = theme._color.text

theme.button_normal   = theme._color.surface0
theme.button_focus    = theme._color.crust
theme.button_selected = theme._color.lavender

theme.shutdown_button = theme._color.red
theme.reboot_button   = theme._color.green
theme.logout_button   = theme._color.rosewater
theme.sleep_button    = theme._color.blue

theme.profile_distro  = theme._color.blue
theme.profile_version = theme._color.yellow
theme.profile_package = theme._color.green
theme.profile_wm      = theme._color.red

theme.launcher_bg = theme._color.lavender
theme.launcher_fg = theme._color.crust

theme.separator = theme._color.surface0

theme.arc_bg = theme._color.crust

--[[ calendar ]]--
theme.calendar_normal_bg = theme._color.base
theme.calendar_normal_fg = theme._color.subtext0

theme.calendar_focus_bg = theme._color.lavender
theme.calendar_focus_fg = theme._color.crust

theme.calendar_header_bg = theme._color.base
theme.calendar_header_fg = theme._color.text

theme.calendar_weekday_bg = theme._color.base
theme.calendar_weekday_fg = theme._color.text

theme.calendar_day_normal_bg = theme._color.base
theme.calendar_day_hover_bg  = theme._color.surface0
theme.calendar_day_focus_bg  = theme._color.surface2

theme.calendar_button_bg = theme._color.surface0
theme.calender_button_fg = theme._color.text

--[[ panel ]]--
theme.dashboard_width   = 450
theme.timeweather_width = 400
theme.panel_bg     = theme._color.crust
theme.panel_border = theme._color.surface0

--[[ titlebar ]]--
theme.titlebar_close_button    = theme._color.red
theme.titlebar_minimize_button = theme._color.yellow
theme.titlebar_ontop_button   = theme._color.blue
theme.titlebar_sticky_button    = theme._color.green
theme.titlebar_button_inactive = theme._color.surface0

--[[ idk ]]--
theme.font = theme.font_type.standard..' '..theme.font_size

theme.bg_focus      = theme._color.subtext0
theme.bg_normal     = theme._color.base
theme.bg_urgent     = theme._color.blue
theme.bg_minimize   = theme._color.surface2
theme.bg_systray    = theme._color.base

theme.fg_normal     = theme._color.text
theme.fg_invert     = theme._color.crust
theme.fg_focus      = theme.fg_normal
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

theme.tooltip_bg = theme._color.base
theme.layoutlist_bg_selected = theme._color.surface1

theme.tasklist_bg_normal   = theme._color.surface1
theme.tasklist_bg_focus    = theme._color.lavender
theme.tasklist_bg_minimize = theme._color.base
theme.tasklist_bg_urgent   = theme._color.mauve

theme.hotkeys_modifiers_fg     = theme._color.blue
theme.hotkeys_font             = theme.font_type.mono..' '..theme.font_size
theme.hotkeys_description_font = theme.font_type.mono..' '..theme.font_size

theme.useless_gap   = dpi(10)
theme.border_width  = dpi(2)
theme.border_normal = theme._color.crust
theme.border_focus  = theme._color.lavender
theme.border_marked = theme._color.yellow

theme.popup_roundness = 5

--[[ image icon ]]--
theme.layout_tile       = awesome_dir.."icon/layout/tile.png"
theme.layout_tileleft   = awesome_dir.."icon/layout/tileleft.png"
theme.layout_floating   = awesome_dir.."icon/layout/floating.png"
theme.layout_centered   = awesome_dir.."icon/layout/centered.png"

theme.wallpaper = awesome_dir.."/wallpapers/squares.png"

theme.icon_theme = "Papirus"

--[[ taglist ]]--
theme.taglist_bg_focus     = theme._color.base
theme.taglist_fg_not_focus = theme._color.surface2
theme.taglist_bg_urgent    = theme._color.blue
theme.taglist_spacing      = dpi(2)

-- each tag has a unique color
theme.tag_color = {
    theme._color.blue,
    theme._color.red,
    theme._color.green,
    theme._color.yellow,
    theme._color.flamingo,
    theme._color.lavender,
    theme._color.rosewater,
    theme._color.mauve,
    theme._color.teal,
    theme._color.peach,
    -------
    theme._color.text,
    theme._color.blue,
}

--[[ bling ]]--
-- prioritize mpd, deprioritize chromium
theme.playerctl_player  = {"mpd", "%any", "chromium"}

-- theme.flash_focus_start_opacity = 0.8
-- theme.flash_focus_step = 0.01

--[[ notification ]]--
theme.notification_font = theme.font_type.standard..' '..theme.font_size
theme.notification_bg = theme._color.base
theme.notification_shape = rounded_rect(theme.popup_roundness)
theme.notification_border_color = theme.border_focus
theme.notification_max_width = 500
-- change theme.notification_border_width does nothing
naughty.config.defaults.border_width = theme.border_width

return theme
