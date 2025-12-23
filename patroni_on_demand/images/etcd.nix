{ config, pkgs, lib, ... }:
{
  system.stateVersion = "25.05";
  
#  boot.loader.grub.device = "/dev/vda";
  
#  networking.hostName = "etcd";
  
  # Désactiver tout le réseau automatique
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  
  # Configuration réseau manuelle (vous configurerez après le boot)
#  networking.interfaces.eth0.useDHCP = lib.mkForce false;
  
#  networking.firewall.enable = false;
  
  environment.systemPackages = with pkgs; [ etcd ];
  services.dbus.enable = true;
  services.etcd.enable = true;
}
