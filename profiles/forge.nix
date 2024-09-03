{ config, pkgs, ... }:

{
  imports = [
    ./docker.nix
    ./yubikey.nix
  ];

  environment.systemPackages = with pkgs; [
    apache-directory-studio
    jdk17
    maven
    nodejs_21
    openldap
    openssl
    yarn
  ];
}
