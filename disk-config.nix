{ ... }:
{
  disko.devices = {
    disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          swap = {
            size = "16G";
            type = "8200";
            content = {
              type = "swap";
              randomEncryption = false;
              resumeDevice = true;
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/rootfs" = {
                  mountpoint = "/";
                };
                "/home" = {
                  mountpoint = "/home";
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "noatime" ];
                };
                "/swap" = {
                  mountpoint = "/swap";
                };
              };
            };
          };
        };
      };
    };
  };
}
