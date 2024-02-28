{ pkgs, stdenv, fetchFromGitHub }:
let
  pname = "nvchad";
  version = "2.0";

  nvchad = fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "refs/heads/v${version}";
    sha256 = "N+Ftw/Poylv2+9QKoteDbKzjB5aOy7NjDRICEmSvsAw=";
  };

  customSrc = fetchFromGitHub {
    owner = "SwaggyPinguin";
    repo = "nvchad_custom";
    rev = "master";
    # sha256 = "R0OTobP46BeHwI7k4oaGkZFiKD3TgYa64uuCc7xDoeA=";
    sha256 = "1C/KQwq2z6rkvNfZmCvks6S667z2wGPAhsgWUwtr9Ls=";
  };

	# launcher = pkgs.writeScript "nvchad" ''
	# 	export XDG_CONFIG_HOME=$(mktmp -d)
	#
	# 	mkdir -p $HOME/.config/nvchad
	# 	chmod u+w $XDG_CONFIG_HOME/nvim/lua 
	# 	ln -s $HOME/.config/nvchad $XDG_CONFIG_HOME/nvim/lua/custom
	#
	# 	cp -r "${customSrc}/." $HOME/.config/nvchad
	# '';
in
stdenv.mkDerivation rec {
  name = pname;
  src = nvchad;

  installPhase = ''
    cp -r . $out
    mkdir -p $out/lua/custom
    cp -r "${customSrc}/." $out/lua/custom
  '';
    # chmod -R u+w $out/lua

  #meta = with lib; {
  #  description = "NvChad";
  #  homepage = "https://github.com/NvChad/NvChad";
  #  platforms = platforms.all;
  #  license = licenses.gpl3;
  #};
}
