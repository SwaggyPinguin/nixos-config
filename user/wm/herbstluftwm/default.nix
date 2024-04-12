{
  config,
  lib,
  pkgs,
  hyprland,
  ...
}:
with lib; {
  xsession.windowManager.herbstluftwm = {
    enable = true;
    tags = ["1"];
  };
}
