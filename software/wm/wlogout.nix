{ pkgs, ... }:
let
  layout = [
    {
      label = "lock";
      action = "hyprlock";
      text = "(L)ock";
      keybind = "l";
    }
    {
      label = "hibernate";
      action = "systemctl hibernate";
      text = "(H)ibernate";
      keybind = "h";
    }
    {
      label = "logout";
      action = "${pkgs.hyprshutdown}/bin/hyprshutdown";
      text = "L(o)gout";
      keybind = "o";
    }
    {
      label = "shutdown";
      action = "${pkgs.hyprshutdown}/bin/hyprshutdown --post-cmd 'systemctl poweroff'";
      text = "(P)oweroff";
      keybind = "p";
    }
    {
      label = "suspend";
      action = "systemctl suspend";
      text = "(S)uspend";
      keybind = "s";
    }
    {
      label = "reboot";
      action = "${pkgs.hyprshutdown}/bin/hyprshutdown --post-cmd 'systemctl reboot'";
      text = "(R)eboot";
      keybind = "r";
    }
  ];
  format-one =
    item:
    pkgs.lib.strings.concatStrings (
      [ "{\n" ]
      ++ (pkgs.lib.mapAttrsToList (name: value: "    \"${name}\" : \"${value}\",\n") item)
      ++ [ "}\n" ]
    );
  layout-full = pkgs.lib.concatStrings (map format-one layout);
  layout-file = pkgs.writeText "wlogout-layout" layout-full;
in
pkgs.writeShellScriptBin "wlogout-wrapped" ''
  ${pkgs.wlogout}/bin/wlogout --layout ${layout-file}
''
