{ pkgs, lib, config, ... }:
let
  cfg = config.pevcas.zerotier;
in {
  options.pevcas.zerotier = {
    enable = lib.mkEnableOption "Zerotier network enabling";
    network-name = lib.mkOption {
      type = lib.types.str;
    };
  };

  config.services.zerotierone = {
    enable = cfg.enable;
    joinNetworks = [ cfg.network-name ];
  };
}
