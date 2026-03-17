{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ── Locale & Time ─────────────────────────────────────────────────────────
  time.timeZone = "America/Kentucky/Louisville";
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Intel GPU ─────────────────────────────────────────────────────────────
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver   # VAAPI for hardware video decode (Broadwell+)
      intel-compute-runtime
    ];
  };

  # ── Power Management ──────────────────────────────────────────────────────
  powerManagement.enable = true;
  services.thermald.enable = true;  # Intel thermal daemon
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # ── Audio (PipeWire) ──────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ── Hyprland ──────────────────────────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # ── Login / Auto-login ────────────────────────────────────────────────────
  services.getty.autologinUser = "cameron";

  # ── Users ─────────────────────────────────────────────────────────────────
  users.users.cameron = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  # ── System Packages ───────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    brightnessctl   # backlight control
    playerctl       # media key control
    networkmanagerapplet
  ];

  # ── Programs ──────────────────────────────────────────────────────────────
  programs.firefox.enable = true;

  # ── Nix Settings ──────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}
