{
  imports = [

    # Packages
    ./packages.nix

    # Services
    ./services/smb.nix
    ./services/arr.nix
    ./services/jellyfin.nix
    ./services/monitoring.nix
    ./services/caddy.nix
    ./services/ddns.nix
    ./services/vaultwarden.nix
    ./secrets.nix
  ];
}