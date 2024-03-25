{ config, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.martin.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    arduino
    heptagon
    quartus-prime-lite
  ];
}
