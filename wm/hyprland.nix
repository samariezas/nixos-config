{ pkgs }:
{
  monitor = [
    ",highrr,auto,1"
    "HDMI-A-1, 1920x1080@60, auto, 1"
  ];

  "$terminal" = "kitty";
  "$menu" = "wofi --show drun";
  "$batterycap" = "wofi -d | batterylimit";

  exec-once = [
    "waybar"
    "${pkgs.swaybg}/bin/swaybg -i ${./wallpaper.png}"
  ];

  env = [
    "XCURSOR_SIZE,24"
    "HYPRCURSOR_SIZE,24"
  ];

  general = {
    gaps_in = "3";
    gaps_out = "6";
    border_size = "2";
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    resize_on_border = "false";
    allow_tearing = true;
    layout = "dwindle";
  };

  decoration = {
    rounding = "10";
    active_opacity = "1.0";
    inactive_opacity = "1.0";

    shadow = {
      enabled = "true";
      range = "4";
      render_power = "3";
      color = "rgba(1a1a1aee)";
    };

    blur = {
      enabled = "true";
      size = "3";
      passes = "1";
      vibrancy = "0.1696";
    };
  };

  animations = {
    enabled = "true";
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    animation = [
      "windows, 1, 2, myBezier"
      "windowsOut, 1, 2, default, popin 80%"
      "layers, 1, 2, myBezier, default"
      "fade, 1, 2, default"
      "border, 1, 1, default"
      "borderangle, 1, 1, default"
      "workspaces, 1, 2, default"
      "zoomFactor, 0"
      "monitorAdded, 0"
    ];
  };

  dwindle = {
    pseudotile = "true";
    preserve_split = "true";
  };

  master = {
    new_status = "master";
  };

  misc = {
    force_default_wallpaper = 0;
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
  };

  input = {
    kb_layout = "us,lt";
    kb_options = "grp:alt_space_toggle";
    follow_mouse = "1";
    sensitivity = "0";
    accel_profile = "flat";
    touchpad = {
      natural_scroll = "false";
    };
  };

  "$mainMod" = "SUPER";

  bind = [
    "$mainMod, RETURN, exec, $terminal"
    "$mainMod SHIFT, Q, killactive,"
    "$mainMod, M, exit,"
    "$mainMod, SPACE, togglefloating,"
    "$mainMod, D, exec, $menu"
    "$mainMod, Y, exec, $batterycap"
    "$mainMod, P, pseudo, # dwindle"
    "$mainMod, V, togglesplit, # dwindle"
    "$mainMod, F, fullscreen"
    "$mainMod, U, exec, hyprlock"
    ", Print, exec, hyprshot -m region -o ~/Pictures"

    "$mainMod, h, movefocus, l"
    "$mainMod, l, movefocus, r"
    "$mainMod, k, movefocus, u"
    "$mainMod, j, movefocus, d"

    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"

    "$mainMod SHIFT, 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, movetoworkspace, 4"
    "$mainMod SHIFT, 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, movetoworkspace, 6"
    "$mainMod SHIFT, 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, movetoworkspace, 9"

    "$mainMod, S, togglespecialworkspace, magic"
    "$mainMod SHIFT, S, movetoworkspace, special:magic"

    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"

    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

    "$mainMod, E, togglegroup"
  ];

  bindle = [
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1"
    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1"
    ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
    ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
  ];

  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  windowrulev2 = [
    "suppressevent maximize, class:.*"
    "float, class:^(qalculate-gtk)$"
    "size 700 550, class:^(qalculate-gtk)$"
  ];
}
