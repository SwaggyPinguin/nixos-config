{ config, pkgs, userSettings, ... }:
{
  home.packages = with pkgs; [ 
    git
    git-crypt
  ];
  
  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
    extraConfig = {
      core = {
        editor = "vim";
        fileMode = true;
      };
      credential = {
        helper = "cache --timeout=86400";
      };
    };
  };

  programs.lazygit.enable = true;
}
