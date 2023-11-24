{ pkgs, ...}:
let
  chrome = pkgs.writeShellScriptBin "chrome" ''
    ${pkgs.google-chrome}/bin/google-chrome-stable
  '';
in
{
  home.packages = with pkgs; [
    zsh
    zsh-powerlevel10k
    git
    htop
    meslo-lgs-nf
    xsel
    nixpkgs-fmt
    discord
    jetbrains.idea-ultimate
    chrome
    google-chrome
  ];
}
