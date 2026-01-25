{ config, pkgs, lib, ... }:
{
  system.stateVersion = "25.05";
  
#  boot.loader.grub.device = "/dev/vda";
  
#  networking.hostName = "etcd";

  # to name the image and the qcow file
  networking.hostName = "haproxy";
  system.name = "haproxy";
  
  # Désactiver tout le réseau automatique
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  
  # Configuration réseau manuelle (vous configurerez après le boot)
#  networking.interfaces.eth0.useDHCP = lib.mkForce false;
  
#  networking.firewall.enable = false;
  
  environment.systemPackages = with pkgs; [ haproxy ];
  services.haproxy.enable = true;
  services.haproxy.config = "
     # TODO
  ";
}
