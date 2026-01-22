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
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
}