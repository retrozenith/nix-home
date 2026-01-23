{ config, ... }:

{
  services.tailscale = {
    authKeyFile = config.age.secrets.tailscale-key.path;
    extraUpFlags = [ "--advertise-routes=192.168.0.0/24" "--ssh" ];
  };
}
