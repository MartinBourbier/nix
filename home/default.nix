{ config, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./git.nix
    ./neovim.nix
    ./packages.nix
    ./zsh.nix
  ];

  home.username = "martin";
  home.homeDirectory = "/home/martin";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;
}
