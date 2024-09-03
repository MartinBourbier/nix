{ pkgs, pkgs-unstable, ... }:
let
  mkAlias = pkgsName: aliasName: pkgs.writeShellScriptBin "${aliasName}" ''
    ${pkgsName}
  '';
  chrome = mkAlias "${pkgs.google-chrome}/bin/google-chrome-stable" "chrome";
  teams = mkAlias "${pkgs.google-chrome}/bin/google-chrome-stable --app=\"https://teams.microsoft.com/v2\"" "teams";
  gitlab = mkAlias "${pkgs.google-chrome}/bin/google-chrome-stable --app=\"https://gitlab.cri.epita.fr\"" "gitlab";
  light = mkAlias ''${pkgs.brightnessctl}/bin/brightnessctl -q "$@"'' "light";
  grh = mkAlias ''git filter-branch --index-filter 'git rm -rf --cached --ignore-unmatch $1' HEAD'' "grh";
in
{
  home.packages = with pkgs;
    [
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
      grh
      htop
      light
      meslo-lgs-nf
      nixpkgs-fmt
      pkgs-unstable.jetbrains.idea-ultimate
      scrot
      spotify
      teams
      tree
      unzip
      xsel
      zsh
      zsh-powerlevel10k
    ];
}
