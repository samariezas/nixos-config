{ config, pkgs, lib, ... }:
let
  cfg = config.pevcas.backup;
in {
  options.pevcas.backup = with lib; {
    port = mkOption {
      type = types.int;
    };

    username = mkOption {
      type = types.str;
    };

    hostname = mkOption {
      type = types.str;
    };
  };

  config = {
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

    users.users.joris.packages = [
      (pkgs.writeShellScriptBin
        "run-backup"
        "restic -r sftp:storage:/home/restic backup /mnt/nfs")
    ];

    home-manager.users.joris = { ... }:
    {
      programs.ssh.matchBlocks.storage = {
        hostname = cfg.hostname;
        user = cfg.username;
        port = cfg.port;
        extraOptions = {
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlMaster = "auto";
          ControlPersist = "10m";
        };
      };
    };
  };
}
