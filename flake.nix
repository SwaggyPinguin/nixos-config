{
	description = "Flake of SwaggyPinguin";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "nixpkgs/nixos-23.11";

		home-manager = {
			# url = "github:nix-community/home-manager/release-23.11";
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }:
	let 
		# ---- SYSTEM SETTINGS ---- #
		systemSettings = {
			stateVersion = "23.11";
			system = "x86_64-linux";
			hostname = "nixos";
			profile = "work";
			timezone = "Europe/Berlin";
			locale = "de_DE.UTF-8";
			defaultLocale = "en_US.UTF-8";
		};

		# ---- USER SETTINGS ---- #
		userSettings = {
			username = "noah";
			name = "Noah";
			email = "ndahms.dev@gmail.com";
			dotfilesDir = "~/.dotfiles";
			theme = "";
			# wm = "hyperland";
			# wmType = if (wm == "hyperland") then "wayland" else "x11";
			browser = "qutebrowser"; # Default browser; must selext one from ./user/app/browser/
			term = "alacritty";
			font = "JetBrains Mono Nerd Font";
			fontPkg = pkgs.jetbrains-mono;
			editor = "nvim";
		};

		# configure pkgs
		pkgs = import nixpkgs {
			system = systemSettings.system;
			config = {
				allowUnfree = true;
				allowUnfreePredicate = (_: true);
			};
		};

		pkgs-stable = import nixpkgs-stable {
			system = systemSettings.system;
			config = {
				allowUnfree = true;
				allowUnfreePredicate = (_: true);
			};
		};

		# configure lib
		lib = nixpkgs.lib;
	in {
		homeConfigurations = {
			user = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [ 
					(./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") # load home.nix from selected PROFILE
				];
				extraSpecialArgs = {
					# pass config variables from above
					inherit pkgs-stable;
					inherit systemSettings;
					inherit userSettings;
				};
			};
		};

		nixosConfigurations = {
			system = lib.nixosSystem {
				system = systemSettings.system;
				modules = [
					(./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix") # load configuration.nix from selected PROFILE 
				];
				specialArgs = {
					# pass config variables from above
					inherit pkgs-stable;
					inherit systemSettings;
					inherit userSettings;
				};
			};
		};
	};
}
