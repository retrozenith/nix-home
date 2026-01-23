{ ... }:

{
  age = {
    identityPaths = [ "/home/cvictor/.config/age/h610-key.txt" ];
    secrets = {
      tailscale-key.file = ../../secrets/tailscale-key.age;
    };
  };
}
