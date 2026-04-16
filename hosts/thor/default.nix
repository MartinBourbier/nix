{ pkgs, lib, config, nixos-hardware, ... }:
{
  imports = [
    ../../profiles/core.nix
    ../../profiles/docker.nix
    ../../profiles/rust.nix
    ../../profiles/yubikey.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  hardware.amdgpu.initrd.enable = true;
  hardware.firmware = [ pkgs.linux-firmware ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  networking = { hostName = "thor"; };

  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-label/crypt";
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.xserver.resolutions = [
    {
      x = 3840;
      y = 2160;
    }
  ];

  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    alsa-scarlett-gui
  ];

  time.hardwareClockInLocalTime = true;

  system.stateVersion = "25.11";
}
