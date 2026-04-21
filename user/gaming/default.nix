{ config, pkgs, lib, ... }:
let
  cfg = config.pevcas.gaming;
in
{
  options.pevcas = with lib; {
    gaming = {
      enable = mkEnableOption
        "gaming user";
      steam = mkEnableOption
        "Whether to install Steam launcher";
      heroic = mkEnableOption
        "Whether to install Heroic game launcher";
      prism = mkEnableOption
        "Whether to install Prism launcher for Minecraft";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      pevcas.wm.users = [ "gaming" ];
      users.users.gaming = {
        isNormalUser = true;
        description = "Gaming";
        extraGroups = [ "networkmanager" ];
        useDefaultShell = true;
        packages =
            (lib.optionals (cfg.prism) [ pkgs.prismlauncher ]) ++
            (lib.optionals (cfg.heroic) [ pkgs.heroic ]);
      };

      home-manager.users.gaming = { ... }:
      {
        home.stateVersion = config.system.stateVersion;
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      environment.systemPackages = with pkgs; [
        clinfo
        mangohud
        gamescope
      ];
    })
    (lib.mkIf cfg.steam {
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];

      programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        installSystemWide = false;
        installForUsers = [ "gaming" ];
      };
    })
  ];
}
