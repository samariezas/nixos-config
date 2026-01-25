{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grub-theme = {
      url = "github:Lxtharia/minegrub-world-sel-theme/1b26faa8698dd352934bb2d8e5e1c8312e95e624";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, grub-theme }: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machine-configs/laptop
          home-manager.nixosModules.home-manager
          grub-theme.nixosModules.default
          ./configuration.nix
        ];
      };

      tabletop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machine-configs/tabletop
          home-manager.nixosModules.home-manager
          grub-theme.nixosModules.default
          ./configuration.nix
        ];
      };
    };
  };
}

