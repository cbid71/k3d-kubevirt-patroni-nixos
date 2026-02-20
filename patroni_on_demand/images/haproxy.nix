{ config, pkgs, lib, ... }:
{
  system.stateVersion = "25.05";
  
#  boot.loader.grub.device = "/dev/vda";
  
#  networking.hostName = "etcd";

  # to name the image and the qcow file
  networking.hostName = "haproxy";
  system.name = "haproxy";

  # Disable all automatic network configuration
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  

  # Disable manual network configuration, to be done after the boot
  # networking.interfaces.eth0.useDHCP = lib.mkForce false;
  
  # networking.firewall.enable = false;
  
  environment.systemPackages = with pkgs; [ haproxy ];
  services.haproxy.enable = true;
  services.haproxy.config = "
     # TODO
  ";
}
