{ config, pkgs, ... }:

{
  imports = [
    ./docker.nix
    ./yubikey.nix
  ];

  environment.systemPackages = with pkgs; [
    jdk17
    maven
    nodejs_21
  ];
}
