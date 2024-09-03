{ pkgs, lib, config, nixos-hardware, ... }:
{
  imports = [
    ../../profiles/assistant.nix
    ../../profiles/core.nix
    ../../profiles/docker.nix
    ../../profiles/forge.nix
    ../../profiles/gistre.nix
    ../../profiles/laptop.nix
    ../../profiles/rust.nix
    ../../profiles/yubikey.nix
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.dell-xps-13-9310
    nixos-hardware.nixosModules.dell-xps-13-9370
  ];

  networking = { hostName = "dell-xps"; };

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2d0aa30c-7765-46a3-b3e2-d46cfe0a3a97";
    fsType = "ext4";
  };

  boot.initrd.luks.devices = {
    "luks-a7fca84c-d266-4a04-ab45-646989ed8610".device = "/dev/disk/by-uuid/a7fca84c-d266-4a04-ab45-646989ed8610";
    # swap
    "luks-d744a323-7961-43f1-8a8f-5a76c47ce80d".device = "/dev/disk/by-uuid/d744a323-7961-43f1-8a8f-5a76c47ce80d";
  };


  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/1E72-6AAF";
      fsType = "vfat";
    };
  swapDevices =
    [{ device = "/dev/disk/by-uuid/5878b4c1-8fc1-4f84-80a1-5860dcc98dbb"; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = lib.mkForce true;

  environment.systemPackages = with pkgs; [
    # webcam firmware
    ivsc-firmware
  ];

  system.stateVersion = "23.11";
}
