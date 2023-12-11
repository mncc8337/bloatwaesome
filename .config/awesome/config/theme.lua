local gears        = require("gears")
local naughty      = require("naughty")

local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")
local dpi          = xresources.apply_dpi
local themes_path  = awesome_dir.."/config/theme.lua"
-- local sys_themes_path = require("gears.filesystem").get_themes_dir()

-- machiatto
-- color_rosewater = "#f4dbd6"
-- color_flamingo  = "#f0c6c6"
-- color_pink      = "#f5bde6"
-- color_mauve     = "#c6a0f6"
-- color_red       = "#ed8796"
-- color_maroon    = "#ee99a0"
-- color_peach     = "#f5a97f"
-- color_yellow    = "#eed49f"
-- color_green     = "#a6da95"
-- color_teal      = "#8bd5ca"
-- color_sky       = "#91d7e3"
-- color_sapphire  = "#7dc4e4"
-- color_blue      = "#8aadf4"
-- color_lavender  = "#b7bdf8"
-- color_text      = "#cad3f5"
-- color_subtext1  = "#b8c0e0"
-- color_subtext0  = "#a5adcb"
-- color_overlay2  = "#939ab7"
-- color_overlay1  = "#8087a2"
-- color_overlay0  = "#6e738d"
-- color_surface2  = "#5b6078"
-- color_surface1  = "#494d64"
-- color_surface0  = "#363a4f"
-- color_base      = "#24273a"
-- color_mantle    = "#1e2030"
-- color_crust     = "#181926"

local theme = {}

-- mocha
theme.color = {
    rosewater = "#f5e0dc",
    flamingo  = "#f2cdcd",
    pink      = "#f5c2e7",
    mauve     = "#cba6f7",
    red       = "#f38ba8",
    maroon    = "#eba0ac",
    peach     = "#fab387",
    yellow    = "#f9e2af",
    green     = "#a6e3a1",
    teal      = "#94e2d5",
    sky       = "#89dceb",
    sapphire  = "#74c7ec",
    blue      = "#89b4fa",
    lavender  = "#b4befe",
    text      = "#cdd6f4",
    subtext1  = "#bac2de",
    subtext0  = "#a6adc8",
    overlay2  = "#9399b2",
    overlay1  = "#7f849c",
    overlay0  = "#6c7086",
    surface2  = "#585b70",
    surface1  = "#45475a",
    surface0  = "#313244",
    base      = "#1e1e2e",
    mantle    = "#181825",
    crust     = "#11111b",
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

theme.font          = theme.font_type.standard.." 12"

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
theme.hotkeys_font = theme.font_type.mono.." 10"
theme.hotkeys_description_font = theme.font_type.mono.." 10"

theme.useless_gap   = dpi(10)
theme.border_width  = dpi(2)
theme.border_normal = theme.color.surface1
theme.border_focus  = theme.color.lavender
theme.border_marked = theme.color.yellow

theme.layout_tile       = awesome_dir.."/layouts/tile.png"
theme.layout_tileleft   = awesome_dir.."/layouts/tileleft.png"
theme.layout_dwindle    = awesome_dir.."/layouts/dwindle.png"
--theme.layout_max        = awesome_dir.."/layouts/max.png"
theme.layout_floating   = awesome_dir.."/layouts/floating.png"
theme.layout_centered   = awesome_dir.."/layouts/centered.png"
theme.layout_mstab      = awesome_dir.."/layouts/mstab.png"

theme.awesome_icon      = awesome_dir.."/awesome-icon.png"
-- theme.menu_submenu_icon = awesome_dir.."/submenu.png"

theme.wallpaper             = awesome_dir.."/wallpapers/dmc_lcd1.png"
theme.taglist_squares       = false
theme.titlebar_close_button = true

-- theme.menu_height = dpi(25)
-- theme.menu_width  = dpi(250)
-- theme.menu_border_color = theme.border_focus
-- theme.menu_bg_focus = theme.bg_minimize

theme.taglist_font  = "sans 18"
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
    theme.color.peach,
    theme.color.teal,
    theme.color.sky,
    theme.color.sapphire,
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
theme.tabbar_font = theme.font_type.standard.." 12"

-- theme.icon_theme = "Papirus"

theme.round_corner_radius = 0

theme.notification_font = theme.font_type.standard.." 12"
theme.notification_bg = theme.color.base
theme.notification_shape = rounded_rect(theme.round_corner_radius)
theme.notification_border_color = theme.border_focus
-- change theme.notification_border_width does nothing
naughty.config.defaults.border_width = theme.border_width
naughty.config.padding = theme.useless_gap * 2

return theme