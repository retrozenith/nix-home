{ config, ... }:

{
  users.groups.media-management = {
    gid = 2000;
  };

  users.users.cvictor.extraGroups = [ "media-management" ];

  # -------------------------------------------------------------------------- #
  # Sonarr + Radarr + Prowlarr + Flarresolverr + Jellyseerr
  # -------------------------------------------------------------------------- #

  services.sonarr = {
    enable = true;
    group = "media-management";
    openFirewall = true;
  };

  services.radarr = {
    enable = true;
    group = "media-management";
    openFirewall = true;
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.flaresolverr = {
    enable = true;
    openFirewall = true;
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
  };
    
  # -------------------------------------------------------------------------- #
  # qBittorrent + Gluetun VPN + Profilarr + Streamystats
  # -------------------------------------------------------------------------- #

  # Open firewall for qBittorrent web UI, Profilarr web UI and Streamystats web UI
  networking.firewall.allowedTCPPorts = [ 8080 6868 3001 ];

  # OCI Containers (Docker)
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      gluetun = {
        image = "qmcgaw/gluetun:latest";
        environment = {
          VPN_SERVICE_PROVIDER = "nordvpn";
          VPN_TYPE = "wireguard";
          TZ = "Europe/Bucharest";
        };
        environmentFiles = [ config.age.secrets.gluetun-env.path ];
        ports = [ "8080:8080" ];
        volumes = [ "/var/lib/gluetun:/gluetun" ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--device=/dev/net/tun:/dev/net/tun"
        ];
      };

      qbittorrent = {
        image = "linuxserver/qbittorrent:latest";
        dependsOn = [ "gluetun" ];
        environment = {
          PUID = "1000";
          PGID = "2000";
          TZ = "Europe/Bucharest";
          WEBUI_PORT = "8080";
        };
        volumes = [
          "/var/lib/qbittorrent:/config"
          "/mnt/storage/downloads:/mnt/storage/downloads"
        ];
        extraOptions = [ "--network=container:gluetun" ];
      };

      profilarr = {
        image = "santiagosayshey/profilarr:latest";
        environment = {
          PUID = "1000";
          PGID = "2000";
          TZ = "Europe/Bucharest";
        };
        volumes = [
          "/var/lib/profilarr:/config"
        ];
        ports = [ "6868:6868" ];
      };

      streamystats = {
        image = "fredrikburmester/streamystats-v2-aio:latest";
        environment = {
          POSTGRES_USER = "postgres";
          POSTGRES_DB = "streamystats";
          # POSTGRES_PASSWORD and SESSION_SECRET loaded from env file
          NODE_ENV = "production";
          SKIP_STARTUP_FULL_SYNC = "false";
        };
        environmentFiles = [ config.age.secrets.streamystats-env.path ];
        volumes = [
          "/var/lib/streamystats:/var/lib/postgresql/data"
        ];
        ports = [ "3001:3000" ]; # Port mapped to 3001 to distinguish from Grafana
      };
    };
  };

  # Ensure directories exist
  systemd.tmpfiles.rules = [
    "d /var/lib/gluetun 0755 root root -"
    "d /var/lib/qbittorrent 0755 1000 2000 -"
    "d /var/lib/profilarr 0755 1000 2000 -"
    "d /var/lib/streamystats 0755 1000 2000 -"
  ];
}