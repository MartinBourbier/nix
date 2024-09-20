{ pkgs, lib, config, nixos-hardware, ... }:
{
  imports = [
    ../../profiles/assistant.nix
    ../../profiles/core.nix
    ../../profiles/docker.nix
    ../../profiles/gistre.nix
    ../../profiles/rust.nix
    ../../profiles/yubikey.nix
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  networking = { hostName = "thor"; };

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

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

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.resolutions = [
    {
      x = 1920;
      y = 1080;
    }
  ];

  hardware = {
    opengl.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false;
      nvidiaSettings = false;

      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "560.35.03"; # Matching with cudaPackage version on unstable
        sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
        openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
        settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
        persistencedSha256 = "";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    alsa-scarlett-gui
  ];

  time.hardwareClockInLocalTime = true;

  system.stateVersion = "24.05";
}
