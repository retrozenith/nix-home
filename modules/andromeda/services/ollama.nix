{ pkgs, ... }:

{
  virtualisation.oci-containers.containers.ollama = {
    image = "ollama/ollama:latest";
    ports = [ "11434:11434" ];
    volumes = [
      "ollama_data:/root/.ollama"
    ];
    extraOptions = [
      "--memory=24g"
      "--cpus=4"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 11434 ];
}
