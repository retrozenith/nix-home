{ pkgs, antigravity-nix, ... }:

{
  environment.systemPackages = with pkgs; [
    antigravity-nix.packages.x86_64-linux.default
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