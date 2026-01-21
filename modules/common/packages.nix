{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    github-cli
    gnupg
    htop
    fastfetch
    nano
    wget
    curl
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
