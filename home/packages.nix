{ pkgs, ...}:
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
  ];
}
