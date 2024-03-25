{ pkgs, pkgs-unstable, ... }:
let
  mkAlias = pkgsName: aliasName: pkgs.writeShellScriptBin "${aliasName}" ''
    ${pkgsName}
  '';
  chrome = mkAlias "${pkgs.google-chrome}/bin/google-chrome-stable" "chrome";
  teams = mkAlias "${pkgs.google-chrome}/bin/google-chrome-stable --app=\"https://teams.microsoft.com/v2\"" "teams";
  gitlab = mkAlias "${pkgs.google-chrome}/bin/google-chrome-stable --app=\"https://gitlab.cri.epita.fr\"" "gitlab";
in
{
  home.packages = with pkgs; [
    arandr
    bat
    ccls
    chrome
    discord
    feh
    font-awesome
    git
    gitlab
    google-chrome
    htop
    meslo-lgs-nf
    nixpkgs-fmt
    pkgs-unstable.jetbrains.idea-ultimate
    python3
    scrot
    spotify
    teams
    tree
    xsel
    zsh
    zsh-powerlevel10k
  ];
}
