let
  big = str: "<big>" + str + "</big>";
in
{
  mainBar = {
    layer = "top";
    position = "top";
    modules-left = [ "hyprland/workspaces" ];
    modules-center = [ "clock" ];
    modules-right = [ "tray" "bluetooth" "hyprland/language" "battery" "custom/battery_capacity" "pulseaudio" "network" ];

    "hyprland/workspaces" = {
      disable-scroll = true;
      format = "{id}";
      active-only = false;
      all-outputs = true;
    };

    "hyprland/language" = {
        format = "${big ""} {short}";
        max-length = 5;
        min-length = 5;
    };

    tray = {
        spacing = 5;
    };

    clock = {
        format = "{:%b %e %H:%M}";
        tooltip-format = "<tt><big>{calendar}</big></tt>";
        today-format = "<b>{}</b>";
        on-click = "gnome-calendar";
    };

    battery = {
      bat = "BAT0";
      adapter = "AC";
      format = "${big "󰁹"} {capacity}%";
      format-charging = "${big "󰂄"} {capacity}%";
    };

    network = {
        format-wifi = "${big " "} {essid}";
        format-ethernet = "${big " "} {ipaddr}";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = big "󰖪 ";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        family = "ipv4";
        tooltip-format-wifi = "  {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\n {bandwidthUpBits}  {bandwidthDownBits}";
        tooltip-format-ethernet = " {ifname}\nIP: {ipaddr}/{cidr}\n {bandwidthUpBits}  {bandwidthDownBits}";
    };

    pulseaudio = {
        scroll-step = 3;
        format = "{icon}  {volume}% {format_source}";
        # format-bluetooth = "{volume}% {icon} {format_source}";
        # format-bluetooth-muted = " {icon} {format_source}";
        format-muted = "${big " "} {format_source}";
        format-source = big "";
        format-source-muted = big " ";
        format-icons = {
            headphone = big " ";
            hands-free = big " ";
            headset = big " ";
            phone = big " ";
            portable = big " ";
            default = [(big "") (big " ") (big " ")];
        };
        on-click = "pavucontrol";
        on-click-right = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
    };

    "custom/battery_capacity" = {
      format = "CAP {text}";
      exec = "cat /var/tmp/current_battery_limit";
      interval = 1;
    };

    bluetooth = {
      format = big "󰂲";
      format-on = big "󰂯";
      format-connected = "${big "󰂯"} {device_alias}";
      format-connected-battery = "${big "󰂯"} {device_alias} {device_battery_percentage}%";
      on-click = "blueman-manager";
    };
  };
}
