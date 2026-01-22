{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    antigravity-fhs
    pinentry-qt
    nil
    direnv
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
}