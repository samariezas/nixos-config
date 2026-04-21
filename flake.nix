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
    thirdparty = {
      url = "path:./thirdparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, grub-theme, thirdparty }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    patchedSteam =
      pkgs.runCommand "steam-module-patched" { } ''
        mkdir -p $out
        cp ${nixpkgs}/nixos/modules/programs/steam.nix $out/steam.nix
        patch $out/steam.nix ${./user/gaming/steam-multiuser.patch}
      '';
    common-modules = [
      home-manager.nixosModules.home-manager
      grub-theme.nixosModules.default
      ({ pkgs, ... }: {
        environment.systemPackages = with thirdparty; [
          blackbox-tools
          minesddm
          pidscope
        ];
      })
      ./configuration.nix
      "${patchedSteam}/steam.nix"
    ];
  in
  {
    nixosConfigurations = {
      lithium = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machine-configs/lithium
          ({ ... }: { pevcas.systemHostname = "lithium"; })
        ] ++ common-modules;
      };

      helium = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machine-configs/helium
          ({ ... }: { pevcas.systemHostname = "helium"; })
        ] ++ common-modules;
      };
    };
  };
}

