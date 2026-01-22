{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # Git
    git
    git-lfs
    github-cli

    # Security
    gnupg
    age

    # System
    htop
    fastfetch
    nano
    wget
    curl
    jq
  ];

  programs.git = {
    enable = true;
    config = {
      user = {
        name  = "Cristea Florian Victor";
        email = "80767544+retrozenith@users.noreply.github.com";
        signingkey = "6DE0B697429D1BE6ABB31DB607E4A9035B2FBB5F";
      };
      commit = {
        gpgsign = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
