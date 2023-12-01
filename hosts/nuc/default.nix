{ pkgs, lib, config, nixos-hardware, ... }:

{
  imports = [
    ../../profiles/core.nix
    ../../profiles/docker.nix
    ../../profiles/yubikey.nix
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
  ];
  networking = {
    hostName = "nuc";
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" "alx" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "dm-mod" "dm-crypt" "dm-thin-pool" "i915" ];
  boot.initrd.luks.devices.cryptlvm.device = "/dev/disk/by-uuid/d4e5ff80-cdfc-42f9-afef-2c8345b45ac8";
  boot.kernelModules = [ "kvm-intel" "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    intel-media-driver
  ];

  environment.variables = {
    VDPAU_DRIVER = lib.mkDefault "va_gl";
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/f14dc7ee-30d4-4711-a6c0-a687789f1015";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/DF7D-E15B";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/b0fc5194-aa9d-48d1-959f-baaca743a2f8"; }];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "23.05";
}
