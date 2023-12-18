{ config, pkgs, ... }:

{
  imports = [
    ./sound.nix
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc.options = "--delete-older-than 10d";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Paris";

  users.users.martin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$ngilX9AlW9fg2kaR8rDlb/$i8laymiLD2lRPwO2is6pRwlCpGC/NO0V7cZZ8A/.cz0";
  };

  programs.neovim.vimAlias = true;
  programs.zsh.enable = true;
  services.xserver.libinput.enable = true;

  services.gvfs.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true;
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
  };

  environment.systemPackages = with pkgs; [
    file
  ];
}
