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
  ];

  # Accept Android SDK license
  nixpkgs.config.android_sdk.accept_license = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
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