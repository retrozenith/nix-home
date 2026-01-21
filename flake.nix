{
  description = "nixOS flake for andromeda homelab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    antigravity-nix.url = "github:jacopone/antigravity-nix";
    antigravity-nix.inputs.nixpkgs.follows = "nixpkgs";    
  };

  outputs = { nixpkgs, home-manager, antigravity-nix, ... }: {
    nixosConfigurations.h610 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit antigravity-nix; };
      modules = [
        ./hosts/h610/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # home-manager.users.yourusername = import ./home/default.nix;
        }
      ];
    };
  };
}
