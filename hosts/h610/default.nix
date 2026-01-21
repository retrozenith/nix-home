{ pkgs, ... }:

{
  imports = [

    # Common hosts configuration
    ../common.nix
    
    # Common modules
    ../../modules/default.nix
    
    # Specific modules
    ../../modules/h610/packages.nix

    # Hardware configuration
    ./hardware-configuration.nix
  ];
  networking.hostName = "h610";
  
  networking.wireless.enable = true;

  networking.networkmanager.enable = true;

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  users.users.cvictor = {
    isNormalUser = true;
    description = "Cristea Florian Victor";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;

  system.stateVersion = "25.11";
}
