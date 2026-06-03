local terminal = "kitty";
local menu = "wofi --show drun";
local batterycap = "wofi -d | batterylimit";
local locker = "hyprlock";
local mainMod = "SUPER";

hl.bind(mainMod .. " + M", hl.dsp.exit())

hl.monitor({
    output = "",
    mode = "highrr",
    position = "auto",
    scale = 1,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    local wallpaper = os.getenv("WINDOWMANAGER_WALLPAPER");
    if wallpaper ~= nil then
        hl.exec_cmd("swaybg -i " .. wallpaper)
    end
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 6,
        border_size = 2,
        col = {
            active_border = {
                colors = { "rgba(33ccffee)", "rgba(00ff99ee)", },
                angle = 45,
            },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = true,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

  animations = {
    enabled = true,
  };

})


hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } });

hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier="myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier="default", style="popin 80%" })
hl.animation({ leaf = "layers", enabled = true, speed = 2, bezier="myBezier" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier="default" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier="default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 1, bezier="default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier="default" })
hl.animation({ leaf = "zoomFactor", enabled = false })
hl.animation({ leaf = "monitorAdded", enabled = false })

hl.config({
  dwindle = {
    force_split = 2,
    preserve_split = true,
  },
  master = {
    new_status = "master",
  },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
  input = {
    kb_layout = "us,lt";
    kb_options = "grp:alt_space_toggle";
    follow_mouse = 1;
    sensitivity = 0;
    accel_profile = "flat";
    touchpad = {
      natural_scroll = false;
    },
  },
})

local function mmBind(key, funct)
    hl.bind(mainMod .. " + " .. key, funct)
end

mmBind("RETURN", hl.dsp.exec_cmd(terminal))
mmBind("SHIFT + Q", hl.dsp.window.close())
mmBind("SPACE", hl.dsp.window.float({ action = "toggle" }))
mmBind("D", hl.dsp.exec_cmd(menu))
mmBind("Y", hl.dsp.exec_cmd(batterycap))
mmBind("U", hl.dsp.exec_cmd(locker))
mmBind("F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle", }))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures"))

mmBind("h", hl.dsp.focus({ direction = "left" }))
mmBind("l", hl.dsp.focus({ direction = "right" }))
mmBind("k", hl.dsp.focus({ direction = "up" }))
mmBind("j", hl.dsp.focus({ direction = "down" }))

for i = 1, 9 do
    mmBind(i, hl.dsp.focus({ workspace = i}))
    mmBind("SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

mmBind("S", hl.dsp.workspace.toggle_special("magic"))
mmBind("SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

mmBind("mouse:272", hl.dsp.window.drag(), { mouse = true })
mmBind("mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true })

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "qualculate-floats",
    match = {
        class = "^(qalculate-gtk)$",
    },
    size = "{800, 600}",
    float = true,
})
