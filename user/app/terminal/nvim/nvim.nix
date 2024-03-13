# { fetchFromGitHub }:
# let
#   nvimKickstart = fetchFromGitHub {
#     owner = "SwaggyPinguin";
#     repo = "kickstart-modular.nvim";
#     # rev = "af034e374f76a32331e33ab7e86b249cd0f6416f";
#     rev = "rev/heads/master";
#     sha256 = "";
# 		# leaveDotGit = true;
#   };
# in
# {
# 	xdg.configFile.nvim = {
# 		source = nvimKickstart;
# 		recursive = true;
# 	};
# }

# { stdenv, fetchFromGitHub }:
#
# stdenv.mkDerivation {
# 	name = "nvimKickstart";
#
# 	src = fetchFromGitHub {
#     owner = "SwaggyPinguin";
#     repo = "kickstart-modular.nvim";
#     # rev = "af034e374f76a32331e33ab7e86b249cd0f6416f";
#     rev = "rev/heads/master";
#     sha256 = "2efQCfeuHW14eO5fRakQz73yMm0/quFz8meVvTuW7JY=";
# 		# leaveDotGit = true;
#   };
#
# 	# xdg.configFile.nvim = {
# 	# 	source = nvimKickstart;
# 	# 	recursive = true;
# 	# };
#
# 	installPhrase = ''
# 		cp -r . $out
# 	'';
# }
