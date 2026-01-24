{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ]; 
      hash = "sha256-dnhEjopeA0UiI+XVYHYpsjcEI6Y1Hacbi28hVKYQURg=";
    };

    # Global options for metrics
    globalConfig = ''
      default_bind 192.168.0.26
      metrics
    '';

    # Security headers snippet (defined at top level of Caddyfile)
    extraConfig = ''
      (security_headers) {
        header {
          X-Content-Type-Options "nosniff"
          X-Frame-Options "SAMEORIGIN"
          X-XSS-Protection "1; mode=block"
          Referrer-Policy "strict-origin-when-cross-origin"
          Strict-Transport-Security "max-age=31536000; includeSubDomains"
          -Server
        }
      }
    '';
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
        sleep 1
      done

      # Read secrets and create env file
      DOMAIN=$(cat ${config.age.secrets.domain.path})
      CF_TOKEN=$(cat ${config.age.secrets.cloudflare_api_token.path})
      
      echo "DOMAIN=$DOMAIN" > /run/caddy-env
      echo "CLOUDFLARE_API_TOKEN=$CF_TOKEN" >> /run/caddy-env
      chmod 600 /run/caddy-env
    '';
  };

  # Ensure caddy starts after the env generator
  systemd.services.caddy.after = [ "caddy-env-generator.service" ];
  systemd.services.caddy.requires = [ "caddy-env-generator.service" ];

  services.caddy.virtualHosts."jf.{$DOMAIN}" = {
    extraConfig = ''
      import security_headers
      reverse_proxy http://localhost:8096
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
      log {
        output file /var/log/caddy/jf.log {
          roll_size 100MiB
          roll_keep 5
          roll_keep_for 100d
        }
        format json
      }
    '';
  };

  services.caddy.virtualHosts."monitoring.{$DOMAIN}" = {
    extraConfig = ''
      import security_headers
      reverse_proxy http://localhost:3000
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
      log {
        output file /var/log/caddy/monitoring.log {
          roll_size 100MiB
          roll_keep 5
          roll_keep_for 100d
        }
        format json
      }
    '';
  };

  services.caddy.virtualHosts."request.{$DOMAIN}" = {
    extraConfig = ''
      import security_headers
      reverse_proxy http://localhost:5055
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
      log {
        output file /var/log/caddy/request.log {
          roll_size 100MiB
          roll_keep 5
          roll_keep_for 100d
        }
        format json
      }
    '';
  };

  services.caddy.virtualHosts."streamys.{$DOMAIN}" = {
    extraConfig = ''
      import security_headers
      reverse_proxy http://localhost:3001
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
      log {
        output file /var/log/caddy/streamystats.log {
          roll_size 100MiB
          roll_keep 5
          roll_keep_for 100d
        }
        format json
      }
    '';
  };

  services.caddy.virtualHosts."home.{$DOMAIN}" = {
    extraConfig = ''
      import security_headers
      reverse_proxy http://localhost:8082
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }
      log {
        output file /var/log/caddy/homepage.log {
          roll_size 100MiB
          roll_keep 5
          roll_keep_for 100d
        }
        format json
      }
    '';
  };
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ]; # HTTP/3 support
}
