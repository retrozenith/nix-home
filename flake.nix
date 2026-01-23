{
  description = "nixOS flake for andromeda homelab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    antigravity-nix.url = "github:jacopone/antigravity-nix";
    antigravity-nix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, agenix, ... }: {
    nixosConfigurations.h610 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit agenix; };
      modules = [
        ./hosts/h610/default.nix
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # home-manager.users.yourusername = import ./home/default.nix;
        }
      ];
    };

    nixosConfigurations.andromeda = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit agenix; };
      modules = [
        ./hosts/andromeda/default.nix
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
