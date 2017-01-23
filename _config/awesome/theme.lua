themepath = "/usr/share/awesome/themes/zenburn/theme.lua"
theme = dofile(themepath)

-- {{{ Main
theme.wallpaper = home .. "/.wallpaper"
-- }}}

-- {{{ Styles
theme.font = "sans 7"

-- {{{ Colors
theme.fg_normal = "#d0d0d0"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ff8700"
theme.fg_shaded = "#a0a0a0"
theme.bg_normal = "#0c0c0c"
theme.bg_focus = "#0c0c0c"
theme.bg_urgent = "#0c0c0c"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width = 1
theme.border_normal = "#202020"
theme.border_focus = "#404040"
theme.border_marked = "#f0f0f0"
theme.taglist_fg_focus = "#ff8700"
-- }}}

-- {{{ Titlebars
theme.statusbar_height = 14
theme.titlebar_height = 12
-- }}}

-- {{{ Tasklist
theme.tasklist_bg_focus = "#0c0c0c"
theme.tasklist_fg_focus = "#f0f0f0"
-- }}}

return theme
