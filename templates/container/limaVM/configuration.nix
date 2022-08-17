{ config, modulesPath, pkgs, lib, ... }:
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    ./lima-init.nix
  ];

  # system mounts
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  fileSystems."/boot" = {
    device = lib.mkForce "/dev/vda1";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
    options = [ "noatime" "nodiratime" "discard" ];
  };

  # misc
  boot.kernelPackages = pkgs.linuxPackages_latest;

  users.users.root.password = "nixos";
  services.openssh = {
    enable = true;
    settings = {
      permitRootLogin = "yes";
      passwordAuthentication = "yes";
    };
  };
  
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };
  networking = {
    hostName = "nixos-podman";
  };
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      sandbox = false;
    };
  };
  system = {
    stateVersion = "23.05";
  };
}
