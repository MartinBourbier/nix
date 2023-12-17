{ pkgs, ... }:

{
  # wifi
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;
  users.users.martin.extraGroups = [ "networkmanager" ];

  # bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # touchpad natural scrolling
  services.xserver.libinput.touchpad.naturalScrolling = true;
}
