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

-- mocha
color_rosewater = "#f5e0dc"
color_flamingo  = "#f2cdcd"
color_pink      = "#f5c2e7"
color_mauve     = "#cba6f7"
color_red       = "#f38ba8"
color_maroon    = "#eba0ac"
color_peach     = "#fab387"
color_yellow    = "#f9e2af"
color_green     = "#a6e3a1"
color_teal      = "#94e2d5"
color_sky       = "#89dceb"
color_sapphire  = "#74c7ec"
color_blue      = "#89b4fa"
color_lavender  = "#b4befe"
color_text      = "#cdd6f4"
color_subtext1  = "#bac2de"
color_subtext0  = "#a6adc8"
color_overlay2  = "#9399b2"
color_overlay1  = "#7f849c"
color_overlay0  = "#6c7086"
color_surface2  = "#585b70"
color_surface1  = "#45475a"
color_surface0  = "#313244"
color_base      = "#1e1e2e"
color_mantle    = "#181825"
color_crust     = "#11111b"

local theme = {}
theme.font_standard = "Roboto"
theme.font_mono = "CaskaydiaCove NF"
theme.font_icon = "Symbols Nerd Font"

theme.font          = theme.font_standard.." 12"

theme.bg_focus      = color_subtext0
theme.bg_normal     = color_base
theme.bg_urgent     = color_blue
theme.bg_minimize   = color_overlay0
theme.bg_systray    = color_base

theme.fg_normal     = color_text
theme.fg_focus      = theme.fg_normal
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

theme.tooltip_bg = color_base
theme.layoutlist_bg_selected = color_surface1

theme.tasklist_bg_normal   = color_surface1
theme.tasklist_bg_focus    = color_text
theme.tasklist_bg_minimize = color_base
theme.tasklist_bg_urgent   = color_mauve

theme.hotkeys_modifiers_fg = theme.blue
theme.hotkeys_font = theme.font_mono.." 10"
theme.hotkeys_description_font = theme.font_mono.." 10"

theme.useless_gap   = dpi(10)
theme.border_width  = dpi(2)
theme.border_normal = color_surface0
theme.border_focus  = color_lavender
theme.border_marked = color_yellow

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
theme.taglist_bg_focus    = color_base
theme.taglist_fg_not_focus= color_surface2
--theme.taglist_fg_occupied = color_overlay1
theme.taglist_bg_urgent   = color_blue
--theme.taglist_fg_urgent   = color_surface2
--theme.taglist_fg_empty    = color_overlay0
theme.taglist_spacing     = dpi(2)

-- each tag have a unique color
theme.tag_colors = {
    color_blue,
    color_red,
    color_green,
    color_yellow,
    color_flamingo,
    color_lavender,
    color_rosewater,
    color_pink,
    color_mauve,
    color_maroon,
    color_peach,
    color_teal,
    color_sky,
    color_sapphire,
}

--[[ bling ]]--
-- prioritize vlc, deprioritize chromium
theme.playerctl_player  = {"vlc", "%any", "chromium"}

theme.flash_focus_start_opacity = 0.8
theme.flash_focus_step = 0.01

theme.mstab_bar_padding = dpi(5)
theme.mstab_dont_resize_slaves = false
theme.tabbar_style = "default"
theme.tabbar_bg_focus = color_lavender
theme.tabbar_bg_normal = color_base
theme.tabbar_fg_focus = color_base
theme.tabbar_fg_normal = color_text
theme.tabbar_position = "top"
theme.tabbar_size = dpi(30)
theme.tabbar_font = theme.font_standard.." 12"

-- theme.icon_theme = "Papirus"

theme.round_corner_radius = 0

theme.notification_font = theme.font_standard.." 12"
theme.notification_bg = color_base
theme.notification_shape = rounded_rect(theme.round_corner_radius)
theme.notification_border_color = theme.border_focus
-- change theme.notification_border_width does nothing
naughty.config.defaults.border_width = theme.border_width
naughty.config.padding = theme.useless_gap * 2

return theme