{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mynixos";
  networking.networkmanager.enable = true;

  # Hyprland
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    btop
    waybar        # status bar
    wofi          # app launcher
    hyprpaper     # wallpaper
    dunst         # notifications
    grim          # screenshots
    slurp         # select screen region for screenshots
    wl-clipboard  # clipboard
  ];

  users.users.cameron = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    initialPassword = "864235";
  };

  system.stateVersion = "24.11";
}
