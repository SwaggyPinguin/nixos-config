{
  config,
  pkgs,
  systemSettings,
  userSettings,
  hyprland,
  ...
}: let
  # nvchad = pkgs.callPackage ../../user/app/terminal/nvim/nvchad.nix {};
  # nvimKickstart = pkgs.callPackage ../../user/app/terminal/nvim/nvim.nix {};
  nvimKickstart = pkgs.fetchFromGitHub {
    owner = "SwaggyPinguin";
    repo = "kickstart-modular.nvim";
    rev = "rev/heads/master";
    sha256 = "2efQCfeuHW14eO5fRakQz73yMm0/quFz8meVvTuW7JY=";
  };
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  home.stateVersion = systemSettings.stateVersion;
  home.enableNixpkgsReleaseCheck = false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    hyprland.homeManagerModules.default
    ../../user/wm/hyprland
    ../../user/wm/herbstluftwm
    ../../user/shell/sh.nix # shell configurations (zsh, bash)
    ../../user/app/terminal/kitty/kitty.nix
    # ../../user/app/terminal/tmux/tmux.nix
    # ../../user/app/terminal/alacritty/alacritty.nix # TODO
    ../../user/app/git/git.nix
    # ../../user/app/flatpak/flatpak.nix
    # (./. + "../../../user/app/browser" + ("/" + userSettings.browser) + ".nix") # Default browser selected from flake
  ];

  home.packages = with pkgs; [
    # Core
    zsh
    neovim
    alacritty
    vscode
    google-chrome
    firefox
    # librewolf # Firefox Fork
    qutebrowser
    dmenu
    rofi
    git

    # Office
    libreoffice-fresh
    xournalpp # Notetaking app with PDF support
    gnome.nautilus
    gnome.gnome-calendar
    openvpn
    wireguard-tools
    wg-netmanager
    # texliveSmall

    # Media
    gimp
    # gimp-with-plugins
    # pinta
    krita
    # inkscape
    vlc
    mpv
    obs-studio
    ffmpeg

    # Development
    python3
    php
    yarn
    nodePackages_latest.nodejs
    rustup
    unzip
    # vimPlugins.nvchad

    # Other
    plocate
    texinfo
    findutils

    libgcc
    zig

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_DEVELOPMENT_DIR = "${config.home.homeDirectory}/dev";
    };
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  # xdg.configFile.nvim = {
  #   source = nvchad;
  #   recursive = true;
  # };

  xdg.configFile.nvim = {
    source = nvimKickstart;
    recursive = true;
  };
}
