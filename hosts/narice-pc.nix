{ suites, lib, pkgs, ... }:
{
  imports = suites.main;

  networking = {
    hostName = "narice-pc";
    interfaces.eno1.useDHCP = true;
    networkmanager.enable = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      # Corresponds to NixOS's first boot stage
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
    };
    kernel.sysctl = {
      "vm.swappiness" = lib.mkForce 1;
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  services = {
    fstrim.enable = true;
    xserver.videoDrivers = [ "modesetting" ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        # amdvlk
      ];
      extraPackages32 = with pkgs; [
        pkgsi686Linux.libva
        # driversi686Linux.amdvlk
      ];
    };
  };
  musnix.kernel.packages = pkgs.linuxPackages_latest; # For hardware reasons

  fileSystems = {
    "/" = {
      label = "nixos-root";
      fsType = "ext4";
    };

    "/home" = {
      label = "nixos-home";
      fsType = "ext4";
    };

    "/boot" = {
      label = "BOOT";
      fsType = "vfat";
    };

    "/nix/store" = {
      label = "nix-store";
      fsType = "ext4";
    };

    "/home/narice/vault" = {
      label = "vault-narice";
      fsType = "ext4";
    };

    "/home/narice/shared" = {
      label = "shared";
      fsType = "ext4";
    };

    "/home/narice/vault/hot-data" = {
      label = "hot-data";
      fsType = "ext4";
    };

    "/home/narice/vault/warm-data" = {
      label = "warm-data";
      fsType = "ext4";
    };

    # "/home/bonk/shared" = {
    #   device = "/home/narice/shared";
    #   fsType = "none";
    #   options = [ "bind" ];
    # };
  };

  swapDevices = [
    { label = "swap"; }
  ];

  powerManagement.cpuFreqGovernor = lib.mkForce "powersave";

  system.stateVersion = "21.11";
}
