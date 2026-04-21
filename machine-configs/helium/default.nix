{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    system.stateVersion = "24.05";

    boot.loader.grub.useOSProber = true;
    boot.initrd.kernelModules = [ "amdgpu" ];
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    hardware.graphics = {
      extraPackages = [ pkgs.rocmPackages.clr.icd ];
    };

    pevcas = {
      shell.color = "blue";
      gaming = {
        enable = true;
        steam = true;
        prism = true;
        heroic = true;
      };
    };
  };
}
