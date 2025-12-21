{ config, pkgs, ... }:
let
  secrets = import ../secrets.nix;
in
{
  fileSystems."/mnt/nfs" = {
    device = "/dev/disk/by-uuid/6ee83677-4096-4a6f-8795-dc23a16dfb4b";
    fsType = "ext4";
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "joris" ];
      PermitRootLogin = "no";
    };
  };

  home-manager.users.joris = { ... }:
  {
    programs.ssh.matchBlocks.storage = {
      hostname = secrets.backup.hostname;
      user = secrets.backup.username;
      port = secrets.backup.port;
      extraOptions = {
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlMaster = "auto";
        ControlPersist = "10m";
      };
    };
  };
}
