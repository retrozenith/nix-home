let
  andromeda = "age12x7vsvde5fu088c4jc064ga7uzm3lgdr7g0l9za2v4w94d5y9gfsv9u7fq";
  h610 = "age14xl2dpzdjmxntftnzx6smps6plcgds4xp2t8hnjuhgzc4rp8qcsqspdyc4";
in
{
  "cloudflare_api_token.age".publicKeys = [ andromeda h610 ];
  "cloudflare_api_email.age".publicKeys = [ andromeda h610 ];
  "domain.age".publicKeys = [ andromeda h610 ];
  "vaultwarden-env.age".publicKeys = [ andromeda h610 ];
  "gluetun-env.age".publicKeys = [ andromeda h610 ];
  "streamystats-env.age".publicKeys = [ andromeda h610 ];
  "tailscale-key.age".publicKeys = [ andromeda h610 ];
  "homepage-env.age".publicKeys = [ andromeda h610 ];
}
