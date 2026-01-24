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
    ./services/ollama.nix
    ./services/vaultwarden.nix
    ./services/tailscale.nix
    ./services/homepage.nix
    ./secrets.nix
  ];
}