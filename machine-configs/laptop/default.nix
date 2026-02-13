{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../bluetooth.nix
  ];

  config = {
    networking.hostName = "laptop";
    system.stateVersion = "25.05";

    boot.loader.grub.useOSProber = false;
    boot.initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-uuid/ae98b94b-9bb0-426d-bf0f-15b10f7b48dc";
        preLVM = true;
        allowDiscards = true;
      };
    };

    home-manager.users.joris = { ... }:
    {
      programs.ssh.matchBlocks.tabletop-zt = {
        hostname = config.pevcas.zerotier.tabletop-ip;
        user = "joris";
        port = 22;

        forwardAgent = true;
        controlMaster = "auto";
        controlPersist = "10m";
      };
    };

    pevcas = {
      systemType = "laptop";
      battery.enabled = true;
      bluetooth.enabled = true;
    };
  };
}
