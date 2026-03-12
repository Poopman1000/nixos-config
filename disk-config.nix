{ lib, ... }:

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";     # ← CHANGE to your drive from lsblk

        content = {
          type = "gpt";

          partitions = {

            # ── EFI Boot Partition ──────────────────────────────────────
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            # ── Swap Partition ──────────────────────────────────────────
            swap = {
              size = "16G";           # ← CHANGE to match your RAM size
              content = {
                type = "swap";
                discardPolicy = "both";   # good for SSD health
                resumeDevice = true;      # enables hibernation
              };
            };

            # ── Root Partition (Btrfs, rest of disk) ────────────────────
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" "-L" "nixos" ];  # force format, label nixos

                subvolumes = {

                  # System root
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" "discard=async" ];
                  };

                  # User home directories
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" "discard=async" ];
                  };

                  # Nix store — separate so snapshots don't include it
                  # (the store is huge and NixOS already manages generations)
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" "discard=async" ];
                  };

                  # Snapper will manage snapshots here
                  "/.snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };

                  # Logs — kept outside root so they survive rollbacks
                  "/var/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };

                };
              };
            };

          };
        };
      };
    };
  };
}
