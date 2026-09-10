{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    system.stateVersion = "26.05";

    boot.initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-uuid/3b0c9eaf-e25d-4edb-9c0f-d7be0fb5a380";
        preLVM = true;
        allowDiscards = true;
      };
    };
    boot.loader.limine.secureBoot.enable = true;

    home-manager.users.joris = {
      services.easyeffects.enable = true;
    };

    pevcas = {
      battery.enabled = true;
      bluetooth.enabled = true;
      shell.color = "red";
      gaming = {
        enable = true;
        steam = true;
        prism = true;
      };
    };
  };
}
