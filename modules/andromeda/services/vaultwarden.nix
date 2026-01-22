{ config, ... }:

{
  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden-env.path;
    config = {
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
  };

  # Add Caddy reverse proxy
  services.caddy.virtualHosts."vault.{$DOMAIN}" = {
    extraConfig = ''
      import security_headers
      reverse_proxy http://localhost:8222
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
    '';
  };
}
