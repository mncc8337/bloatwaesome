local gears        = require("gears")
local naughty      = require("naughty")

local beautiful = require('beautiful')
local dpi       = beautiful.xresources.apply_dpi
local awesome_dir = gears.filesystem.get_configuration_dir()

local theme = {}

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
theme.font_type = {
    standard = "Roboto",
    mono = "CaskaydiaCove NF",
    icon = "Symbols Nerd Font",
}
theme.font_size = 12

--[[ sysres ]]--
theme.mem_icon_color            = theme.color.yellow
theme.cpu_icon_color            = theme.color.blue
theme.temp_icon_color           = theme.color.red
theme.filesys_icon_color        = theme.color.green
theme.music_icon_color_inactive = theme.color.overlay0
theme.music_icon_color_active   = theme.color.blue

--[[ popups ]]--
theme.volumebar_bg = theme.color.crust
theme.volumebar_fg = theme.color.blue

theme.music_progressbar_bg = theme.color.crust
theme.music_progressbar_fg = theme.color.blue

theme.musicplayer_primary_button_normal   = theme.color.surface2
theme.musicplayer_secondary_button_normal = theme.color.surface0
theme.musicplayer_button_focus            = theme.color.text

theme.button_normal   = theme.color.surface0
theme.button_focus    = theme.color.crust
theme.button_selected = theme.color.lavender

--[[ calendar ]]--
theme.calendar_normal_bg = theme.color.base
theme.calendar_normal_fg = theme.color.subtext0

theme.calendar_focus_bg = theme.color.lavender
theme.calendar_focus_fg = theme.color.crust

theme.calendar_header_bg = theme.color.base
theme.calendar_header_fg = theme.color.text

theme.calendar_weekday_bg = theme.color.base
theme.calendar_weekday_fg = theme.color.text

theme.calendar_day_normal_bg = theme.color.base
theme.calendar_day_hover_bg  = theme.color.surface0
theme.calendar_day_focus_bg  = theme.color.overlay1

--[[ panel ]]--
theme.dashboard_width = 450
theme.timeweather_width = 400
theme.panel_bg = theme.color.crust

theme.font          = theme.font_type.standard..' '..theme.font_size

--[[ idk ]]--
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

theme.popup_roundness = 5

--[[ image icon ]]--
theme.layout_tile       = awesome_dir.."/layouts_icons/tile.png"
theme.layout_tileleft   = awesome_dir.."/layouts_icons/tileleft.png"
theme.layout_dwindle    = awesome_dir.."/layouts_icons/dwindle.png"
theme.layout_floating   = awesome_dir.."/layouts_icons/floating.png"
theme.layout_centered   = awesome_dir.."/layouts_icons/centered.png"
theme.layout_mstab      = awesome_dir.."/layouts_icons/mstab.png"

theme.awesome_icon = awesome_dir.."/awesome-icon.png"

theme.wallpaper = awesome_dir.."/wallpapers/squares.png"

theme.icon_theme = "Papirus"

--[[ taglist ]]--
theme.taglist_bg_urgent   = theme.color.blue
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
-- prioritize mpd, deprioritize chromium
theme.playerctl_player  = {"mpd", "%any", "chromium"}

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


--[[ notification ]]--
theme.notification_font = theme.font_type.standard..' '..theme.font_size
theme.notification_bg = theme.color.base
theme.notification_shape = rounded_rect(theme.popup_roundness)
theme.notification_border_color = theme.border_focus
-- change theme.notification_border_width does nothing
naughty.config.defaults.border_width = theme.border_width

return theme