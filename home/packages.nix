{ pkgs, ...}:
let
  mkAlias = pkgsName: aliasName: pkgs.writeShellScriptBin "${aliasName}" ''
    ${pkgsName}
  '';
  chrome = mkAlias "${pkgs.google-chrome}/bin/google-chrome-stable" "chrome";
in
{
  home.packages = with pkgs; [
    bat
    chrome
    discord
    font-awesome
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
