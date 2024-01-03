local config       = require("config")
local gears        = require("gears")
local naughty      = require("naughty")

local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")
local dpi          = xresources.apply_dpi
local themes_path  = config.awesome_dir.."themes/catppuccin.lua"
-- local sys_themes_path = require("gears.filesystem").get_themes_dir()

local theme = {}

-- mocha
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

theme.mem_icon_color = theme.color.yellow
theme.cpu_icon_color = theme.color.blue
theme.temp_icon_color = theme.color.red
theme.filesys_icon_color = theme.color.maroon
theme.music_icon_color_inactive = theme.color.overlay0
theme.music_icon_color_active = theme.color.blue

theme.volumebar_bg = theme.color.crust
theme.volumebar_fg = theme.color.blue

theme.music_progressbar_bg = theme.color.crust
theme.music_progressbar_fg = theme.color.blue

theme.musicplayer_primary_button_normal = theme.color.surface2
theme.musicplayer_secondary_button_normal = theme.color.surface0
theme.musicplayer_button_focus = theme.color.text

theme.button_normal = theme.color.surface0
theme.button_focus = theme.color.crust
theme.button_selected = theme.color.lavender

theme.calendar_month_bg = theme.color.base

theme.calendar_normal_bg = theme.color.crust
theme.calendar_normal_fg = theme.color.text

theme.calendar_focus_bg = theme.color.lavender
theme.calendar_focus_fg = theme.color.crust

theme.calendar_header_bg = theme.color.surface0

theme.calendar_weekday_fg = theme.color.text
theme.calendar_weekday_bg = theme.color.surface2
theme.calendar_weekend_bg = theme.color.surface0

theme.dashboard_bg = theme.color.crust


theme.font_type = {
    standard = "Roboto",
    mono = "CaskaydiaCove NF",
    icon = "Symbols Nerd Font",
}
theme.font_size = 12

theme.font          = theme.font_type.standard..' '..theme.font_size

theme.bg_focus      = theme.color.subtext0
theme.bg_normal     = theme.color.base
theme.bg_urgent     = theme.color.blue
theme.bg_minimize   = theme.color.overlay0
theme.bg_systray    = theme.color.base

theme.fg_normal     = theme.color.text
theme.fg_invert     = theme.color.crust
theme.fg_focus      = theme.fg_normal
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

theme.tooltip_bg = theme.color.base
theme.layoutlist_bg_selected = theme.color.surface1

theme.tasklist_bg_normal   = theme.color.surface1
theme.tasklist_bg_focus    = theme.color.lavender
theme.tasklist_bg_minimize = theme.color.base
theme.tasklist_bg_urgent   = theme.color.mauve

theme.hotkeys_modifiers_fg = theme.color.blue
theme.hotkeys_font = theme.font_type.mono..' '..theme.font_size
theme.hotkeys_description_font = theme.font_type.mono..' '..theme.font_size

theme.useless_gap   = dpi(10)
theme.border_width  = dpi(2)
theme.border_normal = theme.color.surface1
theme.border_focus  = theme.color.lavender
theme.border_marked = theme.color.yellow

theme.layout_tile       = config.awesome_dir.."/layouts/tile.png"
theme.layout_tileleft   = config.awesome_dir.."/layouts/tileleft.png"
theme.layout_dwindle    = config.awesome_dir.."/layouts/dwindle.png"
--theme.layout_max        = config.awesome_dir.."/layouts/max.png"
theme.layout_floating   = config.awesome_dir.."/layouts/floating.png"
theme.layout_centered   = config.awesome_dir.."/layouts/centered.png"
theme.layout_mstab      = config.awesome_dir.."/layouts/mstab.png"

theme.awesome_icon      = config.awesome_dir.."/awesome-icon.png"
-- theme.menu_submenu_icon = config.awesome_dir.."/submenu.png"

theme.wallpaper             = config.awesome_dir.."/wallpapers/wind-turbine.png"
theme.taglist_squares       = false
theme.titlebar_close_button = true

-- theme.menu_height = dpi(25)
-- theme.menu_width  = dpi(250)
-- theme.menu_border_color = theme.border_focus
-- theme.menu_bg_focus = theme.bg_minimize

-- theme.taglist_font  = "sans 20"
theme.taglist_bg_focus    = theme.color.base
theme.taglist_fg_not_focus = theme.color.surface2
--theme.taglist_fg_occupied = theme.color.overlay1
theme.taglist_bg_urgent   = theme.color.blue
--theme.taglist_fg_urgent   = theme.color.surface2
--theme.taglist_fg_empty    = theme.color.overlay0
theme.taglist_spacing     = dpi(2)

-- each tag has a unique color
theme.tag_color = {
    theme.color.blue,
    theme.color.red,
    theme.color.green,
    theme.color.yellow,
    theme.color.flamingo,
    theme.color.lavender,
    theme.color.rosewater,
    theme.color.pink,
    theme.color.mauve,
    theme.color.maroon,
    theme.color.sky,
    theme.color.teal,
}

--[[ bling ]]--
-- prioritize vlc, deprioritize chromium
theme.playerctl_player  = {"vlc", "%any", "chromium"}

theme.flash_focus_start_opacity = 0.8
theme.flash_focus_step = 0.01

theme.mstab_bar_padding = dpi(5)
theme.mstab_dont_resize_slaves = false
theme.tabbar_style = "default"
theme.tabbar_bg_focus = theme.color.lavender
theme.tabbar_bg_normal = theme.color.base
theme.tabbar_fg_focus = theme.color.base
theme.tabbar_fg_normal = theme.color.text
theme.tabbar_position = "top"
theme.tabbar_size = dpi(30)
theme.tabbar_font = theme.font_type.standard..' '..theme.font_size

-- theme.icon_theme = "Papirus"

theme.round_corner_radius = 0

theme.notification_font = theme.font_type.standard..' '..theme.font_size
theme.notification_bg = theme.color.base
theme.notification_shape = rounded_rect(theme.round_corner_radius)
theme.notification_border_color = theme.border_focus
-- change theme.notification_border_width does nothing
naughty.config.defaults.border_width = theme.border_width

return theme