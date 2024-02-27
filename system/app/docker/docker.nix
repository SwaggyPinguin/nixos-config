{ pkgs, lib, userSettings, storageDriver ? null, ... }:

assert lib.asserts.assertOneOf "storageDriver" storageDriver [
  null
  "aufs"
  "btrfs"
  "devicemapper"
  "overlay"
  "overlay2"
  "zfs"
];

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver = storageDriver;
    # storageDriver = "btrfs";
    autoPrune.enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.users.${userSettings.username}.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
}
