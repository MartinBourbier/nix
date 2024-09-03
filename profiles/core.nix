{ config, pkgs, lib, ... }:

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

  programs.zsh.enable = true;

  services.gvfs.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true;
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    libinput.enable = true;
    xkb.options = "caps:swapescape";
    xautolock.enable = true;
  };

  environment.systemPackages = with pkgs; [
    arandr
    evince
    file
    git-sizer
    linux-manual
    lsof
    man-pages
    man-pages-posix
    unzip
    usbutils
    zip
    zoxide
  ];

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  # Allows ccls to work with system headers without compile db
  environment.variables = {
    CPATH = lib.mkForce (builtins.concatStringsSep ":" [
      (lib.makeSearchPathOutput "dev" "include" [ pkgs.stdenv.cc.cc.lib ])
    ]);
  };
}
