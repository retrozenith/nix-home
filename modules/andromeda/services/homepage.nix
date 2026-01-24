{ config, lib, ... }:

{
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    environmentFile = config.age.secrets.homepage-env.path;


    settings = {
      title = "Andromeda";
      favicon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/home-assistant.png";
      theme = "dark";
      color = "slate";
      headerStyle = "boxed";
      layout = {
        Media = {
          style = "row";
          columns = 3;
        };
        Downloads = {
          style = "row";
          columns = 4;
        };
        Management = {
          style = "row";
          columns = 2;
        };
        Monitoring = {
          style = "row";
          columns = 2;
        };
        AI = {
          style = "row";
          columns = 1;
        };
      };
    };

    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
        };
      }
      {
        resources = {
          label = "Root";
          disk = "/";
        };
      }
      {
        resources = {
          label = "Storage";
          disk = "/mnt/storage";
        };
      }
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
    ];

    services = [
      {
        Media = [
          {
            Jellyfin = {
              icon = "jellyfin.png";
              href = "{{HOMEPAGE_VAR_DOMAIN_PREFIX}}jf.{{HOMEPAGE_VAR_DOMAIN}}";
              description = "Media streaming";
              widget = {
                type = "jellyfin";
                url = "http://localhost:8096";
                key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
                enableBlocks = true;
                enableNowPlaying = true;
              };
            };
          }
          {
            Jellyseerr = {
              icon = "jellyseerr.png";
              href = "{{HOMEPAGE_VAR_DOMAIN_PREFIX}}request.{{HOMEPAGE_VAR_DOMAIN}}";
              description = "Media requests";
              widget = {
                type = "jellyseerr";
                url = "http://localhost:5055";
                key = "{{HOMEPAGE_VAR_JELLYSEERR_API_KEY}}";
              };
            };
          }
          {
            Streamystats = {
              icon = "tautulli.png";
              href = "{{HOMEPAGE_VAR_DOMAIN_PREFIX}}streamys.{{HOMEPAGE_VAR_DOMAIN}}";
              description = "Streaming statistics";
            };
          }
        ];
      }
      {
        Downloads = [
          {
            qBittorrent = {
              icon = "qbittorrent.png";
              href = "http://192.168.0.26:8080";
              description = "Torrent client";
              widget = {
                type = "qbittorrent";
                url = "http://localhost:8080";
                username = "{{HOMEPAGE_VAR_QBITTORRENT_USERNAME}}";
                password = "{{HOMEPAGE_VAR_QBITTORRENT_PASSWORD}}";
              };
            };
          }
          {
            Sonarr = {
              icon = "sonarr.png";
              href = "http://192.168.0.26:8989";
              description = "TV series management";
              widget = {
                type = "sonarr";
                url = "http://localhost:8989";
                key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
                enableQueue = true;
              };
            };
          }
          {
            Radarr = {
              icon = "radarr.png";
              href = "http://192.168.0.26:7878";
              description = "Movie management";
              widget = {
                type = "radarr";
                url = "http://localhost:7878";
                key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
                enableQueue = true;
              };
            };
          }
          {
            Prowlarr = {
              icon = "prowlarr.png";
              href = "http://192.168.0.26:9696";
              description = "Indexer management";
              widget = {
                type = "prowlarr";
                url = "http://localhost:9696";
                key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
              };
            };
          }
        ];
      }
      {
        Management = [
          {
            Profilarr = {
              icon = "sonarr.png";
              href = "http://192.168.0.26:6868";
              description = "Profile management";
            };
          }
          {
            Vaultwarden = {
              icon = "bitwarden.png";
              href = "{{HOMEPAGE_VAR_DOMAIN_PREFIX}}vault.{{HOMEPAGE_VAR_DOMAIN}}";
              description = "Password manager";
            };
          }
        ];
      }
      {
        Monitoring = [
          {
            Grafana = {
              icon = "grafana.png";
              href = "{{HOMEPAGE_VAR_DOMAIN_PREFIX}}monitoring.{{HOMEPAGE_VAR_DOMAIN}}";
              description = "Dashboards & metrics";
              widget = {
                type = "grafana";
                url = "http://localhost:3000";
                username = "{{HOMEPAGE_VAR_GRAFANA_USERNAME}}";
                password = "{{HOMEPAGE_VAR_GRAFANA_PASSWORD}}";
              };
            };
          }
          {
            Prometheus = {
              icon = "prometheus.png";
              href = "http://192.168.0.26:9090";
              description = "Metrics collection";
              widget = {
                type = "prometheus";
                url = "http://localhost:9090";
              };
            };
          }
        ];
      }
      {
        AI = [
          {
            Ollama = {
              icon = "ollama.png";
              href = "http://192.168.0.26:11434";
              description = "Local LLM";
            };
          }
        ];
      }
    ];
  };

  # Generator for Homepage environment (DOMAIN from secret)
  systemd.services.homepage-env-generator = {
    description = "Generate Homepage Environment File";
    wantedBy = [ "multi-user.target" ];
    before = [ "homepage-dashboard.service" ];
    after = [ "run-agenix.d.mount" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Wait for secrets to be available
      for i in $(seq 1 30); do
        if [[ -f ${config.age.secrets.domain.path} ]]; then
          break
        fi
        sleep 1
      done

      # Read secret and create env file
      DOMAIN=$(cat ${config.age.secrets.domain.path})
      
      echo "HOMEPAGE_VAR_GENERATED_DOMAIN=$DOMAIN" > /run/homepage-env-generated
      echo "HOMEPAGE_ALLOWED_HOSTS=localhost,127.0.0.1,$DOMAIN,home.$DOMAIN" >> /run/homepage-env-generated
      chmod 600 /run/homepage-env-generated
    '';
  };

  # Ensure homepage starts after the env generator
  systemd.services.homepage-dashboard.after = [ "homepage-env-generator.service" ];
  systemd.services.homepage-dashboard.requires = [ "homepage-env-generator.service" ];
  systemd.services.homepage-dashboard.serviceConfig.EnvironmentFile = [ "/run/homepage-env-generated" ];
  
  # Forcefully unset the Environment variable if the module sets it, so our EnvironmentFile takes precedence
  systemd.services.homepage-dashboard.environment.HOMEPAGE_ALLOWED_HOSTS = lib.mkForce null;
}
