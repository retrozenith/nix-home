{ pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "media-management";
  };

  # Enable hardware acceleration for Jellyfin
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
}
