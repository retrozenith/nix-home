{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # System - GPU
    intel-gpu-tools

    # System - Network
    wireguard-tools
  ];
}