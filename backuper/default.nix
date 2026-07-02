{ config, pkgs, lib, ... }:
let
  cfg = config.pevcas.backup;
in {
  options.pevcas.backup = with lib; {
    enable = mkEnableOption
      "Enables local backup HDD and pushing backups via restic";
  };

  config = lib.mkIf cfg.enable {
    users.users.joris.packages = [
      (pkgs.writeShellScriptBin
        "run-backup"
        "restic -r sftp:storage:/home/restic backup /mnt/nfs")
    ];

    home-manager.users.joris = { ... }:
    {
      programs.ssh.settings.storage = {
        HostName = "u419829.your-storagebox.de";
        User = "u419829";
        Port = 23;
        ControlMaster = "auto";
        ControlPersist = "10m";
      };
    };

    environment.systemPackages = with pkgs; [
      restic
    ];
  };
}
