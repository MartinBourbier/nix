{ ... }:
{
  imports = [
    ./alacritty.nix
    ./git.nix
    ./i3.nix
    # ./hyprland.nix
    ./neovim/neovim.nix
    ./packages.nix
    # ./vscode.nix
    ./zsh.nix
  ];

  home.username = "martin";
  home.homeDirectory = "/home/martin";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
