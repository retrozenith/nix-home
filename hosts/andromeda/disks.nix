{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ mergerfs ];

  fileSystems."/mnt/disk1" = {
    device = "/dev/disk/by-id/ata-WDC_WD10EZEX-22MFCA0_WD-WCC6Y3HENFP8";
    fsType = "ext4";
  };

  fileSystems."/mnt/disk2" = {
    device = "/dev/disk/by-id/ata-WDC_WD5000AADS-00L4B1_WD-WCAUH1494019";
    fsType = "ext4";
  };

  fileSystems."/mnt/disk3" = {
    device = "/dev/disk/by-id/usb-Seagate_Expansion_HDD_00000000NT17CTL3-0:0";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/mnt/storage" = {
    device = "/mnt/disk1:/mnt/disk2:/mnt/disk3";
    fsType = "mergerfs";
    options = [ "defaults" "allow_other" "use_ino" "minfreespace=50G" "fsname=mergerfs" "nofail" ];
  };

  ## NOTE: Ensure services stop when the mount is stopping/restarting
  # sudo systemctl stop jellyfin prowlarr radarr sonarr flaresolverr jellyseerr docker-qbittorrent samba-smbd
}
