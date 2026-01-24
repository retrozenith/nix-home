{ ... }:

{
  age = {
    identityPaths = [ "/home/cvictor/.config/age/andromeda-key.txt" ];    
    
    secrets = {
      cloudflare_api_token.file = ../../secrets/cloudflare_api_token.age;
      cloudflare_api_email.file = ../../secrets/cloudflare_api_email.age;
      domain = {
        file = ../../secrets/domain.age;
        owner = "caddy";
        group = "caddy";
      };
      vaultwarden-env = {
        file = ../../secrets/vaultwarden-env.age;
        owner = "vaultwarden";
        group = "vaultwarden";
      };
      gluetun-env.file = ../../secrets/gluetun-env.age;
      streamystats-env.file = ../../secrets/streamystats-env.age;
      tailscale-key.file = ../../secrets/tailscale-key.age;
      homepage-env.file = ../../secrets/homepage-env.age;
    };
  };
}
