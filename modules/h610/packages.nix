{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    antigravity-fhs
    pinentry-qt
    nil
    direnv
    wgnord
    wireguard-tools
    python3
    python3Packages.pip
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
}