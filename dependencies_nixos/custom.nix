{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  imports =
    [
      (import "${home-manager}/nixos")
    ];

  users.users.user.isNormalUser = true;
  users.users.user.extraGroups = [
    "docker"
  ];

  home-manager.users.user = { pkgs, ... }: {
    home.packages = with pkgs; [
         k3d		# k3d
         kubevirt	# virtctl
         git		# git
         kubectl
       ];
    programs.bash.enable = true;
  
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
  virtualisation.docker.enable = true;   # whole docker ecosystem
}
