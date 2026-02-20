{ config, pkgs, lib, ... }:
{
  system.stateVersion = "25.05";
  
#  boot.loader.grub.device = "/dev/vda";

  # to name the image and the qcow file  
  networking.hostName = "etcd";
  system.name = "etcd";
  
  # Disable all automatic network configuration
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  
  # Disable manual network configuration, to be done after the boot
  # networking.interfaces.eth0.useDHCP = lib.mkForce false;
  
#  networking.firewall.enable = false;
  
  environment.systemPackages = with pkgs; [ etcd ];
  services.dbus.enable = true;
  services.etcd.enable = true;
}
