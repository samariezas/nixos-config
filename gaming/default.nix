{ config, pkgs, lib, ... }:
let
  cfg = config.pevcas;
in
{
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
  };

  users.users.gaming = {
    isNormalUser = true;
    description = "Gaming";
    extraGroups = [ "networkmanager" ];
    useDefaultShell = true;
    packages = lib.mkIf (cfg.systemType == "tabletop")
        [ pkgs.prismlauncher ];
  };

  home-manager.users.gaming = { pkgs, ... }:
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
  ];
}
