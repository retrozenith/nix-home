{ config, lib, pkgs, ... }:
let
  hardwareConfig = ./hardware-configuration.nix;
in
{
  imports = lib.optional (builtins.pathExists hardwareConfig) hardwareConfig;

  fileSystems."/mnt/HDD" =
    { device = "/dev/disk/by-uuid/f695f143-79be-44bc-917d-7f549deb0964";
      fsType = "ext4";
      options = ["nofail"];
    };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "Mars";
  networking.networkmanager.enable = true;

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

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  swapDevices = [ ];

  users.users.cvictor = {
    isNormalUser = true;
    description = "Cristea Florian Victor";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    sbctl
    vscode.fhs
    git
    gparted
    google-chrome
    go
  ] ++ lib.optionals (pkgs ? lon) [
    lon
  ];

  system.stateVersion = "25.11";
}