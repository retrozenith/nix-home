{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # IDE
    antigravity-fhs

    # Security
    pinentry-qt

    # Nix-DEV
    nil
    direnv

    # Wireguard
    wgnord
    wireguard-tools

    # Python
    python3
    python3Packages.pip

    # Node
    bun
    nodejs_22

    # Android
    android-studio
    android-tools

    # Java
    openjdk21

    # Make
    gnumake
    cmake

    # C++
    gcc
    gdb

    # Go
    go

    # Canon Printer
    cnijfilter2
    simple-scan
    xsane
    gscan2pdf
    sane-backends
    sane-airscan

    # Kwallet
    kdePackages.ksshaskpass
    kdePackages.kwallet-pam
    kdePackages.kwalletmanager
    kdePackages.kgpg

    # Networking
    nmap
  ];

  # KWallet integration for SSH keys
  environment.sessionVariables = {
    SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    SSH_ASKPASS_REQUIRE = "prefer";
    GIT_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
  };

  # Accept Android SDK license
  nixpkgs.config.android_sdk.accept_license = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
    settings = {
      default-cache-ttl = 86400;      # 24 hours
      max-cache-ttl = 86400;          # 24 hours
      default-cache-ttl-ssh = 86400;  # 24 hours for SSH keys
      max-cache-ttl-ssh = 86400;      # 24 hours for SSH keys
      allow-preset-passphrase = true;
    };
    enableExtraSocket = true;
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.sane.enable = true;
  services.udev.packages = [ pkgs.sane-airscan ];

}