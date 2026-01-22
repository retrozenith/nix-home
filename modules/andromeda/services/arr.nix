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
  # qBittorrent + Gluetun VPN + Profilarr
  # -------------------------------------------------------------------------- #

  # Open firewall for qBittorrent web UI and Profilarr web UI
  networking.firewall.allowedTCPPorts = [ 8080 6868 ];

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
    };
  };

  # Ensure directories exist
  systemd.tmpfiles.rules = [
    "d /var/lib/gluetun 0755 root root -"
    "d /var/lib/qbittorrent 0755 1000 2000 -"
    "d /var/lib/profilarr 0755 1000 2000 -"
  ];
}