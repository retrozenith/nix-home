{ ... }:

{
  imports = [ 

    # Common modules
    ../../modules/default.nix

    # Hardware configuration
    ./hardware-configuration.nix
  ];

  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "cvictor" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "andromeda";

  networking.networkmanager.enable = false;
  networking.interfaces.enp1s0.ipv4.addresses = [{
    address = "192.168.0.26";
    prefixLength = 24;
  }];
  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  time.timeZone = "Europe/Bucharest";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.cvictor = {
    isNormalUser = true;
    description = "Cristea Florian Victor";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgcVpS5l0uCXoI+FB/wVjSVE22ZM4o9ZqxU9C6GEkmw cvictor@h610-2026-01-21"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];

  system.stateVersion = "25.11";
}
