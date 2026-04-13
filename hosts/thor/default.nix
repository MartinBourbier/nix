{ pkgs, lib, config, nixos-hardware, ... }:
{
  imports = [
    ../../profiles/core.nix
    ../../profiles/docker.nix
    ../../profiles/rust.nix
    ../../profiles/yubikey.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  networking = { hostName = "thor"; };

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/b19da865-c038-4970-bb20-433069a3c312";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-119baba5-27b9-462c-82b7-3b3d01e4def5".device = "/dev/disk/by-uuid/119baba5-27b9-462c-82b7-3b3d01e4def5";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/0F41-D6C5";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.xserver.resolutions = [
    {
      x = 3840;
      y = 2160;
    }
  ];

  environment.systemPackages = with pkgs; [
    alsa-scarlett-gui
  ];

  time.hardwareClockInLocalTime = true;

  system.stateVersion = "25.11";
}
