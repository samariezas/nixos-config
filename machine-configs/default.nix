{ lib, ... }:
with lib;
{
  options.pevcas = {
    systemHostname = mkOption {
      type = types.enum [ "helium" "lithium" ];
    };

    battery.enabled = mkOption {
      type = types.bool;
      default = false;
    };

    bluetooth.enabled = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
