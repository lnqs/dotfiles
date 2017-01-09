-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")

require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- extra libraries
local vicious = require("vicious")

-- filesystem
local lfs = require("lfs")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
home = os.getenv("HOME")
beautiful.init(home .. "/.config/awesome/theme.lua")

-- This is used later as the default software to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
screenlock = "dm-tool lock"

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.floating
}

awful.layout.inc(layouts, -1) -- floating for first tag by default
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    -- Default to floating for the first screen
    local l = layouts[1]
    if s == 1 then
        l = awful.layout.suit.floating
    end

    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6 }, s, l)
end
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Wibox
function colored(text, color)
    return "<span color='" .. color .. "'>" .. text .. "</span>"
end

-- Create the date and time widget
calendar = require('calendar')
datewidget = wibox.widget.textbox()
calendar.addCalendarToWidget(datewidget)
vicious.register(datewidget, vicious.widgets.date, colored(" | ", beautiful.fg_shaded) .. "%a, %b %d %H:%M ")

-- Create the updates widget
updateswidget = wibox.widget.textbox()
updateswidget_tooltip = awful.tooltip({ objects = { updateswidget }})
vicious.register(updateswidget, vicious.widgets.pkg,
                function(widget,args)
                    local tooltip = ""
                    local color_text = theme.fg_shaded
                    local color_count = theme.fg_normal
                    if args[1] > 0 then
                        local s = io.popen("pacman -Qu")
                        tooltip = "\n Updates available: \n\n"
                        for line in s:lines() do
                            tooltip = tooltip .. " - " .. line .. " \n"
                        end
                        s:close()
                        color_text = beautiful.fg_urgent
                        color_count = beautiful.fg_urgent
                    end
                    updateswidget_tooltip:set_text(tooltip)
                    return colored(" | ", beautiful.fg_shaded) ..
                            colored("Updates: ", color_text) ..
                            colored(args[1], color_count)
                 end, 300, "Arch")

-- Create the cpu usage widget
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, colored(" | CPU: ", beautiful.fg_shaded) .. "$1%")

-- Create the memory usage widget
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, colored(" | Mem: ", beautiful.fg_shaded) .. "$1%")

-- Create the battery widget
batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, colored(" | Bat: ", beautiful.fg_shaded) .. "$2% ($1$3)", 61, "BAT0")

-- Create the audio volume widget
volwidget = wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume, colored("Vol: ", beautiful.fg_shaded) .. "$1%", 0.3, "Master")

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = beautiful.statusbar_height })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == screen.count() then
        right_layout:add(volwidget)
        if lfs.attributes("/sys/class/power_supply/BAT0/capacity") ~= nil then
            right_layout:add(batwidget)
        end
        right_layout:add(memwidget)
        right_layout:add(cpuwidget)
        right_layout:add(updateswidget)
        right_layout:add(datewidget)
        right_layout:add(wibox.widget.systray())
    end
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- lock screen
    awful.key({ modkey,           }, "l", function () awful.util.spawn(screenlock) end),

    -- volume control
    awful.key({     }, "XF86AudioRaiseVolume", function() awful.util.spawn("amixer set Master 5%+", false) end),
    awful.key({     }, "XF86AudioLowerVolume", function() awful.util.spawn("amixer set Master 5%-", false) end),
    awful.key({     }, "XF86AudioMute", function() awful.util.spawn("amixer sset Master toggle", false) end),
    awful.key({     }, "XF86AudioMicMute", function() awful.util.spawn("amixer sset Capture toggle", false) end),
    awful.key({     }, "XF86AudioPrev", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous", false) end),
    awful.key({     }, "XF86AudioPlay", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause", false) end),
    awful.key({     }, "XF86AudioNext", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next", false) end),
    awful.key({     }, "XF86ScreenSaver", function() awful.util.spawn(screenlock) end),
    awful.key({     }, "XF86MonBrightnessDown", function() awful.util.spawn("xbacklight -dec 10") end),
    awful.key({     }, "XF86MonBrightnessUp", function() awful.util.spawn("xbacklight -inc 10") end),
    awful.key({     }, "XF86Display", function() awful.util.spawn("xset dpms force off") end),
    awful.key({     }, "XF86WebCam", function() awful.util.spawn("guvcview") end),
    awful.key({     }, "XF86Launch1", function() awful.util.spawn("playsound.sh") end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 6 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule       = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     size_hints_honor = false,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule       = { class = "Gimp" },
      properties = { floating = true } },
    { rule       = { class = "Exe" },
      properties = { floating = true, titlebar = false } },
    { rule       = { class = "Wine" },
      properties = { floating = true, border_width = 0, titlebar = false } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    -- Create titlebar
    -- Add button handling
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end))

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(awful.titlebar.widget.iconwidget(c))
    left_layout:buttons(buttons)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(awful.titlebar.widget.floatingbutton(c))
    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
    right_layout:add(awful.titlebar.widget.stickybutton(c))
    right_layout:add(awful.titlebar.widget.ontopbutton(c))
    right_layout:add(awful.titlebar.widget.closebutton(c))

    -- The title goes in the middle
    local middle_layout = wibox.layout.flex.horizontal()
    local title = awful.titlebar.widget.titlewidget(c)
    middle_layout:add(title)
    middle_layout:buttons(buttons)

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(middle_layout)

    local titlebar = awful.titlebar(c, { size = beautiful.titlebar_height })
    titlebar:set_widget(layout)
    -- For some reason we have to set the size twice. I assume this causes some kind of update
    awful.titlebar(c, { size = beautiful.titlebar_height })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Signal function to execute when a screen is rearranged
for s = 1, screen.count() do
    screen[s]:connect_signal("arrange", function ()
        -- Show the titlebar only for floating clients
        local floating = awful.layout.getname(awful.layout.get(s)) == "floating"
        for _, c in pairs(awful.client.visible(s)) do
            floating = floating or c.fullscreen or awful.client.floating.get(c)

            for _, e in pairs(awful.rules.rules) do
                if (awful.rules.match(c, e.rule) or awful.rules.match_any(c, e.rule_any)) and
                    (not awful.rules.match(c, e.except) and not awful.rules.match_any(c, e.except_any)) then
                    forced = e.properties.titlebar
                end
            end

            if forced == nil then
                if floating then
                    awful.titlebar.show(c)
                else
                    awful.titlebar.hide(c)
                end
            elseif forced then
                awful.titlebar.show(c)
            else
                awful.titlebar.hide(c)
            end
        end
    end)
end
-- }}}

-- Activate screenlock on suspend/hibernate
prepare_for_sleep = function(...)
    local data = {...}
    if data[2] == true then
        awful.util.spawn(screenlock)
    end
end

dbus.add_match("system", "type='signal',path='/org/freedesktop/login1',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'")
dbus.connect_signal("org.freedesktop.login1.Manager", prepare_for_sleep)

