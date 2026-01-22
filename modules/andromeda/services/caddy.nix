{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ]; 
      hash = "sha256-dnhEjopeA0UiI+XVYHYpsjcEI6Y1Hacbi28hVKYQURg=";
    };
  };
  
  systemd.services.caddy.serviceConfig.EnvironmentFile = [ "/run/caddy-env" ];

  # Generator for Caddy environment (DOMAIN + CF token)
  systemd.services.caddy-env-generator = {
    description = "Generate Caddy Environment File";
    wantedBy = [ "multi-user.target" ];
    before = [ "caddy.service" ];
    after = [ "run-agenix.d.mount" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Wait for secrets to be available
      for i in $(seq 1 30); do
        if [[ -f ${config.age.secrets.domain.path} ]] && [[ -f ${config.age.secrets.cloudflare_api_token.path} ]]; then
          break
        fi
        echo "Waiting for secrets... ($i)"
        sleep 1
      done

      # Read secrets
      DOMAIN=$(cat ${config.age.secrets.domain.path})
      CF_TOKEN=$(cat ${config.age.secrets.cloudflare_api_token.path})
      
      # Debug output
      echo "DOMAIN length: ''${#DOMAIN}"
      echo "CF_TOKEN length: ''${#CF_TOKEN}"
      
      # Create env file
      echo "DOMAIN=$DOMAIN" > /run/caddy-env
      echo "CLOUDFLARE_API_TOKEN=$CF_TOKEN" >> /run/caddy-env
      chmod 600 /run/caddy-env
      
      echo "Created /run/caddy-env"
      cat /run/caddy-env | head -c 50
    '';
  };

  # Ensure caddy starts after the env generator
  systemd.services.caddy.after = [ "caddy-env-generator.service" ];
  systemd.services.caddy.requires = [ "caddy-env-generator.service" ];

  services.caddy.virtualHosts."jf.{$DOMAIN}" = {
    extraConfig = ''
      reverse_proxy http://localhost:8096
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
    '';
  };

  services.caddy.virtualHosts."monitoring.{$DOMAIN}" = {
    extraConfig = ''
      reverse_proxy http://localhost:3000
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
    '';
  };
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
