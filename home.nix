{ config, pkgs, ... }:

{
  home.username = "cameron";
  home.homeDirectory = "/home/cameron";
  home.stateVersion = "25.05";

  # ── Packages ──────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    kitty        # terminal emulator
    waybar       # status bar
    wofi         # app launcher
    dunst        # notification daemon
    grim         # screenshot
    slurp        # screen region selector
    wl-clipboard # clipboard for wayland
  ];

  # ── Git ───────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    # userName  = "Your Name";
    # userEmail = "your@email.com";
  };

  # ── Shell (Bash) ──────────────────────────────────────────────────────────
  programs.bash = {
    enable = true;
    shellAliases = {
      ll  = "ls -lah";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };

  # ── Kitty Terminal ────────────────────────────────────────────────────────
  programs.kitty = {
    enable = true;
    font.name = "monospace";
    font.size = 12;
    settings = {
      confirm_os_window_close = 0;
    };
  };
}
