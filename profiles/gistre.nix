{ config, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.martin.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    (rstudioWrapper.override { packages = with rPackages; [ corrplot FactoMineR MASS ]; })
    arduino
    heptagon
    kicad
    quartus-prime-lite
  ];
}
