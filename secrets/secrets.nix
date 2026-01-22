let
  andromeda = "age12x7vsvde5fu088c4jc064ga7uzm3lgdr7g0l9za2v4w94d5y9gfsv9u7fq";
  h610 = "age1kn3gruywztpgyfdxlzfss6l9lff5v87tseqw3kpwjjxq8wdd8vasc62laf";
in
{
  "cloudflare_api_token.age".publicKeys = [ andromeda h610 ];
  "cloudflare_api_email.age".publicKeys = [ andromeda h610 ];
  "domain.age".publicKeys = [ andromeda h610 ];
  "vaultwarden-env.age".publicKeys = [ andromeda h610 ];
  "gluetun-env.age".publicKeys = [ andromeda h610 ];
}
