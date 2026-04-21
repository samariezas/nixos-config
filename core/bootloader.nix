{ ... }:
{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      minegrub-world-sel = {
        enable = true;
        customIcons = [{
          name = "nixos";
          lineTop = "NixOS (18/06/2025, 09:23)";
          lineBottom = "Survival Mode, No Cheats";
          imgName = "nixos";
        }];
      };
    };
  };
}
