{ pkgs, ... }:
# let
#   # installation of plugins not in nixpkgs
#   tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin {
#     pluginName = "tmux-super-fingers";
#     version = "";
#     src = pkgs.fetchFromGitHub {
#       owner = "artemave";
#       repo = "tmux-super-fingers";
#       rev = "master";
#       sha256 = "";
#     };
#   };
# in
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    shell = "${pkgs.zsh}/bin/zsh";
    term = "screen-256color";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 10000;

    plugins = with pkgs; [
      tmuxPlugins.tpm
      tmuxPlugins.sensible
      tmuxPlugins.gruvbox
      tmuxPlugins.tmux-fzf
      tmuxPlugins.better-mouse-mode

      {
	plugin = tmuxPlugins.resurrect;
	extraConfig = ''
	  set -g @resurrect-strategy-vim "session"
	  set -g @resurrect-strategy-nvim "session"
	  set -g @resurrect-capture-pane-contents 'on'
	'';
      }
      {
	plugin = tmuxPlugins.continuum;
	extraConfig = ''
	  set -g @continuum-restore 'on'
	  set -g @continuum-save-interval '10'
	  set -g @continuum-boot 'on'
	'';
      }

      # installation of plugins not in nixpkgs
 #      {
	# plugin = tmux-super-fingers;
	# extraConfig = "set -g @super-fingers-key f";
 #      }
    ];

    extraConfig = ''
    '';
  };

  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };

  home.packages = with pkgs; [
    tmux
  ];
}
