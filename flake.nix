{
  description = "The Observatory";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lon = {
      url = "path:./lon";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, lon, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      sources = import "${lon}/lon.nix";
      lanzaboote = import sources.lanzaboote {
        inherit pkgs;
      };
    in
    {
      formatter.${system} = pkgs.nixfmt;

      nixosConfigurations.Mars = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          ./hosts/Mars
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cvictor = import ./users/cvictor.nix;
          }
        ];
      };
    };
}
