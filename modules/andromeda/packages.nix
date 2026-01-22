{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # System - GPU
    intel-gpu-tools
  ];
}