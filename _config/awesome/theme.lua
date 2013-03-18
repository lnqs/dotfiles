themepath = "/usr/share/awesome/themes/zenburn/theme.lua"

theme = dofile(themepath)

-- theme.wallpaper_cmd = { "awsetbg -l" }
theme.wallpaper_cmd = { "/bin/true" }
theme.font          = "sans 7"
theme.border_width  = 1

return theme
