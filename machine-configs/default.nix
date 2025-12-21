{ lib, ... }:
with lib;
{
  options.pevcas = {
    systemType = mkOption {
      type = types.enum [ "tabletop" "laptop" ];
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
