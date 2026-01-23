{ config, ... }:

{
  services.tailscale = {
    authKeyFile = config.age.secrets.tailscale-key.path;
  };
}
