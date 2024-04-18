{pkgs, ...}: let
  # ALIASES
  myAliases = {
    nv = "nvim";
    ls = "eza --icons -l -T -L=1";
    la = "eza --icons -agl -s type";
    cat = "bat";
    gitfetch = "onefetch";
    nixos-rebuild-flake = "sudo nixos-rebuild switch --flake ~/.dotfiles#system";
    home-manager-flake = "home-manager switch --flake ~/.dotfiles#user";
  };
in {
  imports = [
    ./p10k.nix # add powerlevel10k to zsh plugins
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # initExtra = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      # theme = "powerlevel10k";
      plugins = [
        "git"
        "aliases"
        "docker"
        "aliases"
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  home.packages = with pkgs; [
    oh-my-zsh
    zoxide
    eza
    bat
    btop
    neofetch
    onefetch
    direnv
    nix-direnv
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
