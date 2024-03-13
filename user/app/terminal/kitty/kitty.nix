{ pkgs, userSettings, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = userSettings.font;
      size = 11;
    };
    # See all available kitty themes at: https://github.com/kovidgoyal/kitty-themes/blob/master/themes.json
    # theme = "Gruvbox Dark";
    theme = "Gruvbox Material Dark Medium";
    shellIntegration.enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    kitty
    kitty-themes
  ];
}
