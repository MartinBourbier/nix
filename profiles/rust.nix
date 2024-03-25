{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    cargo
    clippy
    gcc
    rustc
    rustfmt
  ];
}
