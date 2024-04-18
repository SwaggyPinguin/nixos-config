# { userSettings, authorizedKeys ? [], ... }:
{
  config,
  userSettings,
  authorizedKeys ? [],
  ...
}:
# let
#     cfg = config.services.openssh;
# in mkId cfg.enable
{
  # Enable incoming ssh
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.ssh-agent.enable = true;

  users.users.${userSettings.username}.openssh.authorizedKeys.keys = authorizedKeys;

  programs.ssh.askForPassword = "";
}
