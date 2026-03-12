{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  # ── Bootloader ────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Networking ────────────────────────────────────────────────────────
  networking.hostName = "nixos-framework";           # ← CHANGE to whatever you want
  networking.networkmanager.enable = true;

  # ── Timezone & Language ───────────────────────────────────────────────
  time.timeZone = "America/Kentucky/Louisville";      # ← CHANGE to your timezone
  i18n.defaultLocale = "en_US.UTF-8";

  # ── KDE Plasma 6 on Wayland ───────────────────────────────────────────
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  # ── Audio ─────────────────────────────────────────────────────────────
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.pulse.enable = true;

  # ── Printing ──────────────────────────────────────────────────────────
  services.printing.enable = true;

  # ── Fonts ─────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
  ];

  # ── Packages ──────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    neovim
    firefox
    kdePackages.kcalc
    kdePackages.partitionmanager
    wl-clipboard
    snapper             # snapshot CLI tool
    snap-pac            # hooks into pacman-style hooks — triggers on rebuild
  ];

  # ── Btrfs & SSD ───────────────────────────────────────────────────────
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";     # checks filesystem integrity monthly
    fileSystems = [ "/" ];
  };

  # ── Snapper — Automatic Snapshots ─────────────────────────────────────
  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";

    configs = {

      # Snapshots of your root filesystem
      root = {
        SUBVOLUME = "/";
        ALLOW_USERS = [ "cameron" ];    # ← CHANGE to your username
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;

        # How many snapshots to keep
        TIMELINE_MIN_AGE = "1800";
        TIMELINE_LIMIT_HOURLY = "10";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "4";
        TIMELINE_LIMIT_MONTHLY = "6";
        TIMELINE_LIMIT_YEARLY = "2";
      };

      # Snapshots of your home directory (separately)
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "cameron" ];    # ← CHANGE to your username
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;

        TIMELINE_MIN_AGE = "1800";
        TIMELINE_LIMIT_HOURLY = "10";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "4";
        TIMELINE_LIMIT_MONTHLY = "3";
        TIMELINE_LIMIT_YEARLY = "1";
      };

    };
  };

  # snap-pac triggers a snapshot automatically before+after nixos-rebuild
  programs.snapper.snapshotRootOnBoot = true;

  # ── Your User Account ─────────────────────────────────────────────────
  users.users.cameron = {               # ← CHANGE "yourname"
    isNormalUser = true;
    description = "Cameron";           # ← CHANGE this
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.bash;
  };

  security.sudo.enable = true;
  networking.firewall.enable = true;

  # ── Keep at your install version, never change later ──────────────────
  system.stateVersion = "24.11";
}
