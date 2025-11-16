{ config, pkgs, lib, ... }:
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
    # packages = with pkgs; [ prismlauncher ];
  };

  home-manager.users.gaming = { pkgs, ... }:
  {
    home.stateVersion = "25.05";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };

  # boot.initrd.kernelModules = [ "amdgpu" ];
  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  # ];
  environment.systemPackages = with pkgs; [
    clinfo
    mangohud
  ];
}
