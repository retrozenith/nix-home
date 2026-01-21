{
  imports = [

    # Packages
    ./packages.nix

    # Services
    ./services/smb.nix
    ./services/arr.nix
    ./services/jellyfin.nix
  ];
}