themepath = "/usr/share/awesome/themes/zenburn/theme.lua"

theme = dofile(themepath)

theme.wallpaper         = home .. "/.wallpaper"
theme.font              = "sans 7"
theme.border_width      = 1

theme.statusbar_height  = 14
theme.titlebar_height   = 12

theme.fg_shaded         = "#a0a0a0"
theme.fg_normal         = "#d0d0d0"
theme.fg_focus          = "#ffffff"
theme.fg_urgent         = "#ff8700"
theme.bg_normal         = "#0c0c0c"
theme.bg_focus          = "#0c0c0c"
theme.bg_urgent         = "#0c0c0c"
theme.border_normal     = "#202020"
theme.border_focus      = "#404040"
theme.border_marked     = "#f0f0f0"
theme.taglist_fg_focus  = "#ff8700"
theme.tasklist_bg_focus = "#0c0c0c"
theme.tasklist_fg_focus = "#f0f0f0"

return theme
