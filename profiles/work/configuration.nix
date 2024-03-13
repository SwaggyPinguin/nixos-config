{ pkgs, lib, systemSettings, userSettings, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ../../system/hardware-configuration.nix
      # (import ../../system/app/docker/docker.nix { storageDriver = "btrfs"; inherit userSettings pkgs lib; })
    ];

  # System
  system =  {
    stateVersion = systemSettings.stateVersion;
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };

  nix = {
    # Fix nix path
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=$HOME/dotfiles/system/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    # Ensure nix flakes are enabled
    package = pkgs.nixFlakes;
    settings.experimental-features = [ "nix-command" "flakes" ];
    # extraOptions = ''
    # 	experimental-features = nix-xommand flakes
    # ''

    # Garbage collect
    settings.auto-optimise-store = true;
		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 7d";
		};
  };

  nixpkgs.config.allowUnfree = true;

  # Kernal modules
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" "cpufreq_powersave" ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Networking
  networking.hostName = systemSettings.hostname; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Timezone and locale
  time.timeZone = systemSettings.timezone;
  # i18n.defaultLocale = "en_US.UTF-8";
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [];
    uid = 1000;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    zsh
    git
		fzf
		gnugrep
		ripgrep
    cryptsetup # used for disk encryption
    home-manager
    alacritty
  ];

  # Default shell
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true; # zsh is configured in ../../user/shell/zsh.nix

  fonts = {
    packages = with pkgs; [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
    fontDir.enable = true;
  };

  #xdg.portal = {
  #  enable = true;
  #  config.common.default = "*";
  #  extraPortals = [
  #    pkgs.xdg-desktop-portal
  #    pkgs.xdg-desktop-portal-gtk
  #  ];
  #};

  # Configure console keymap
  console.keyMap = "de";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
		xkb = {
			layout = "de";
			variant = "";
		};
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}