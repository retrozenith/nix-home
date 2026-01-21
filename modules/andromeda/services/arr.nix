{ ... }:

{
  users.groups.media-management = { };

  users.users.cvictor.extraGroups = [ "media-management" ];

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
}