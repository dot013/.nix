{ config, pkgs, ... }:

{
  imports = [ ];
  config = {
    host.networking.hostName = "homex";
    networking = {
      dhcpcd.enable = true;
      interfaces.eno1.ipv4.addresses = [{
        address = "192.168.1.10";
        prefixLength = 28;
      }];
      defaultGateway = "192.168.1.1";
      nameservers = [ "100.100.100.100" "1.1.1.1" "8.8.8.8" ];
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };

    services.openssh.enable = true;
  };
}


