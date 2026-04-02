{ pkgs, ... }:
{
  home.username = "cvictor";
  home.homeDirectory = "/home/cvictor";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      key = "07E4A9035B2FBB5F";
      signByDefault = true;
    };
    settings = {
      user.name = "Cristea Florian Victor";
      user.email = "florianvictorcristea@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      tag.gpgSign = true;
      gpg.format = "openpgp";
    };
  };

  programs.gh.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-qt;
  };
}
