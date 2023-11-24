{ pkgs, ...}:
let
  mkAlias = pkgsName: aliasName: pkgs.writeShellScriptBin "${aliasName}" ''
    ${pkgsName}
  '';
  chrome = mkAlias "google-chrome-stable" "chrome";
in
{
  home.packages = with pkgs; [
    bat
    chrome
    discord
    git
    google-chrome
    htop
    jetbrains.idea-ultimate
    meslo-lgs-nf
    nixpkgs-fmt
    xsel
    zsh
    zsh-powerlevel10k
  ];
}
