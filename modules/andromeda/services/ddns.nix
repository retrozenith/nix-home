{ config, ... }:

{
  # DDClient for dynamic DNS updates
  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    zone = "cristeavictor.xyz";
    username = "token";  # Use "token" for API token auth
    passwordFile = config.age.secrets.cloudflare_api_token.path;
    domains = [
      "cristeavictor.xyz"
      "*.cristeavictor.xyz"
    ];
    use = "web, web=https://api.ipify.org";
    interval = "5min";
  };
}
