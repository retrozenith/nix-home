{ ... }:

{
  imports = [ 

    # Common hosts configuration
    ../common.nix

    # Common modules
    ../../modules/default.nix

    # Specific modules
    ../../modules/andromeda/default.nix

    # Hardware configuration
    ./hardware-configuration.nix
    ./disks.nix
  ];

  nix.settings.trusted-users = [ "cvictor" ];

  networking.hostName = "andromeda";

  networking.networkmanager.enable = false;
  networking.interfaces.enp1s0.ipv4.addresses = [{
    address = "192.168.0.26";
    prefixLength = 24;
  }];
  networking.defaultGateway = "192.168.0.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  users.users.cvictor = {
    isNormalUser = true;
    description = "Cristea Florian Victor";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgcVpS5l0uCXoI+FB/wVjSVE22ZM4o9ZqxU9C6GEkmw cvictor@h610-2026-01-21"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];

  # Enable Docker
  virtualisation.docker.enable = true;

  system.stateVersion = "25.11";
}
