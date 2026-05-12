-----------------
---- HELPERS ----
-----------------

local function hostname()
  local file = io.open("/etc/hostname", "r")
  if not file then return "unknown" end
  local content = file:read "*a"
  file:close()
  return content:match "^%s*(.-)%s*$"
end

local function lidOpen()
  local file = io.open("/proc/acpi/button/lid/LID/state", "r")
  if not file then return false end
  local content = file:read "*a"
  file:close()
  return not string.find(content, "closed")
end

------------------
---- MONITORS ----
------------------

if hostname() == "azathoth" then
  hl.monitor({
    output   = "DP-1",
    mode     = "preferred",
    position = "-1920x0",
    scale    = "auto",
  })

  hl.monitor({
    output   = "DP-2",
    mode     = "preferred",
    position = "0x0",
    scale    = "auto",
  })

  hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "1920x0",
    scale    = "auto",
  })
end

if hostname() == "nyarlathothep" then
  hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "-1920x0",
    scale    = "1",
    disabled = not lidOpen(),
  })

  hl.monitor({
    output   = "DP-8",
    mode     = "preferred",
    position = "0x0",
    scale    = "auto",
  })

  hl.monitor({
    output   = "DP-9",
    mode     = "preferred",
    position = "1920x0",
    scale    = "auto",
  })

  hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl reload"), { locked = true })
  hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl reload"), { locked = true })
end

hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = "auto",
})


------------------
---- PROGRAMS ----
------------------

local terminal         = "uwsm app -- kitty"
local menu             = "axiom launcher"
local screenlock       = "axiom lock"
local workspaceManager = "axiom workspace-manager"
local screenshotOutput = "hyprshot -m output"
local screenshotRegion = "hyprshot -m region"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
  hl.exec_cmd("uwsm app -- udiskie -s --appindicator")
  hl.exec_cmd("uwsm app -- nm-applet --indicator")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME", "catppuccin-cursors")
hl.env("HYPRCURSOR_THEME", "catppuccin-cursors")
hl.env("XCURSOR_SIZE", "22")
hl.env("HYPRCURSOR_SIZE", "22")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

if hostname() == "azathoth" then
  hl.env("LIBVA_DRIVER_NAME", "nvidia")
  hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
  hl.env("NVD_BACKEND", "direct")
end


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    gaps_in  = 4,
    gaps_out = 4,

    border_size = 2,

    col = {
      active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    layout = "dwindle",
  },

  decoration = {
    rounding       = 10,
    rounding_power = 2,

    -- Change transparency of focused and unfocused windows
    active_opacity   = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },

    blur = {
      enabled   = true,
      size      = 3,
      passes    = 1,
      vibrancy  = 0.1696,
    },
  },

  animations = {
    enabled = true,
  },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",           enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",           enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",          enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",        enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",       enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",           enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",          enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",             enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",           enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",         enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",        enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",     enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",       enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesIn",     enabled = true,  speed = 1.21, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesOut",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slidefadevert -100%" })
hl.animation({ leaf = "zoomFactor",       enabled = true,  speed = 7,    bezier = "quick" })

hl.config({
  dwindle = {
    preserve_split = true,
  },
})

hl.config({
  master = {
    new_status = "master",
  },
})

hl.config({
  scrolling = {
    fullscreen_on_one_column = true,
  },
})


----------------
----  MISC  ----
----------------

hl.config({
  misc = {
    enable_swallow = true,
    swallow_regex  = "kitty",
  },
})


---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout  = "us",
    kb_variant = "altgr-intl",
    kb_model   = "",
    kb_options = "",
    kb_rules   = "",
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(screenlock))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + tab", hl.dsp.exec_cmd(workspaceManager))
hl.bind("print", hl.dsp.exec_cmd(screenshotOutput))
hl.bind("SHIFT + print", hl.dsp.exec_cmd(screenshotRegion))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = "m~" .. i }))
  hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = "m~" .. i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- Move between workspaces with mainMod + alt + left/right
hl.bind(mainMod .. " + ALT + left",  hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.focus({ workspace = "m+1" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------
---- WORKSPACES ----
--------------------

if hostname() == "azathoth" then
  for i = 1, 6 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true, monitor = "DP-1" })
  end
  for i = 7, 12 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true, monitor = "DP-2" })
  end
  for i = 13, 18 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true, monitor = "HDMI-A-1" })
  end
end

if hostname() == "nyarlathothep" then
  for i = 1, 6 do
    hl.workspace_rule({ workspace = tostring(i), persistent = lidOpen(), monitor = "eDP-1" })
  end
  for i = 7, 12 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true, monitor = "DP-8" })
  end
  for i = 13, 18 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true, monitor = "DP-9" })
  end
end

hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = terminal .. " -- nvim ~/Notes/todo.md" })
hl.workspace_rule({ workspace = "HALLO", persistent = true, monitor = "DP-9" })


----------------
---- LAYERS ----
----------------

-- Shell
hl.layer_rule({
  match = { namespace = "axiom:powermenu" },
  blur = true,
})

hl.layer_rule({
  match = { namespace = "axiom:workspace-manager" },
  blur = true,
})

hl.layer_rule({
  match = { namespace = "axiom:launcher" },
  blur = true,
})

-----------------
---- WINDOWS ----
-----------------

-- Ignore maximize requests from all apps.
hl.window_rule({
  name  = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
  name  = "fix-xwayland-drags",
  match = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})

-- Keepassxc
hl.window_rule({
  match = { class = "org.keepassxc.KeePassXC", title = "Unlock Database - KeePassXC" },
  float = true,
})

hl.window_rule({
  match = { class = "org.keepassxc.KeePassXC", title = "KeePassXC - Browser Access Request" },
  float = true,
})

-- Steam
hl.window_rule({
  match = { class = "steam", title = "Friends List" },
  float = true,
})

hl.window_rule({
  match = { class = "steam", title = "Steam Settings" },
  float = true,
})

-- Zoom (enable "Use system title bars and borders" in Settings -> "Accessibility" -> "Miscellaneous")
hl.window_rule({
  match = { class = "zoom" },
  no_follow_mouse = true,
  no_blur = true,
})

hl.window_rule({
  match = { class = "zoom", title = "negative:Meeting" },
  float = true,
})

hl.window_rule({
  match = { class = "zoom", title = "menu window" },
  stay_focused = true,
})

hl.window_rule({
  match = { class = "zoom", title = "as_toolbar" },
  pin = true,
})

hl.window_rule({
  match = { class = "zoom", title = "zoom_linux_float_video_window" },
  pin = true,
})

hl.window_rule({
  match = { class = "zoom", title = "annotate_toolbar" },
  decorate = false,
})

