{ pkgs, ... }:

{
  networking.networkManager = {
    enable = true;
    dns = "default";
  };

  programs.nm-applet.enable = true;
  users.users.martin.extraGroups = [ "networkManager" ];

  services.hardware.bolt.enable = true;
  services.blueman.enable = true;

  hardware.bluetooth.enable = true;
}
