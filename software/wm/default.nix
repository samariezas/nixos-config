{ config, pkgs, lib, ... }:
let
  hyprconfig = builtins.readFile ./hyprland.lua;
  waybarconfig = import ./waybar { inherit lib; inherit config; };
  woficonfig = import ./wofi;
  hyprlockconfig = import ./hyprlock.nix;
  battery = pkgs.callPackage ./battery {};
in
{
  options.pevcas.wm = {
    users = lib.options.mkOption { type = with lib.types; listOf str; };
  };

  config = {
    nixpkgs.overlays = [(final: prev: {
      waybar = prev.waybar.overrideAttrs {
        src = assert (prev.waybar.version == "0.15.0");
          prev.fetchFromGitHub {
            owner = "Alexays";
            repo = "Waybar";
            rev = "0594574";
            hash = "sha256-51R3mIt8cLNvh/X5qe9vOqeJCj0U9KRyemVE5y+OhiU=";
          };
        preConfigure = ''
          mv subprojects/cava-0.10.7-beta/ subprojects/cava-0.10.7/
        '';
      };
    })];

    security.wrappers = lib.mkIf config.pevcas.battery.enabled {
      batterylimit = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${battery}";
      };
    };

    environment.systemPackages = with pkgs; [
      hyprshot
      mako
      brightnessctl
      gammastep
      swaybg
    ];

    environment.sessionVariables = {
      WINDOWMANAGER_WALLPAPER = ./wallpaper.png;
    };

    fonts.packages = with pkgs; [
      font-awesome
      noto-fonts
      nerd-fonts.symbols-only
      nerd-fonts.hack
    ];

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    home-manager.users = with builtins; listToAttrs (map
      (username: {
        name = username;
        value = { pkgs, ... }:
        {
          wayland.windowManager.hyprland = {
            enable = true;
            extraConfig = hyprconfig;
            configType = "lua";
          };

          programs.waybar = {
            enable = true;
            package = pkgs.waybar;
            settings = waybarconfig;
            style = ./waybar/style.css;
          };

          programs.wofi = {
            enable = true;
            settings = woficonfig;
            style = builtins.readFile ./wofi/style.css;
          };

          programs.hyprlock = {
            enable = true;
            settings = hyprlockconfig;
          };

          home.pointerCursor = {
            gtk.enable = true;
            package = pkgs.bibata-cursors;
            name = "Bibata-Original-Ice";
            size = 26;
          };

          gtk = {
            enable = true;
            gtk4.theme = null;
            theme = {
              package = pkgs.flat-remix-gtk;
              name = "Flat-Remix-GTK-Blue-Darkest";
            };
            iconTheme = {
              package = pkgs.kdePackages.breeze-icons;
              name = "BreezeIcons";
            };
            font = {
              name = "Sans";
              size = 10;
            };
          };
        };
      }) config.pevcas.wm.users);
    };
}
