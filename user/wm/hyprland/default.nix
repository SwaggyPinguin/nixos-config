{
  config,
  lib,
  pkgs,
  hyprland,
  ...
}:
with lib; {
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [];
  };
}
