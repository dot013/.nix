{
  config,
  lib,
  ...
}: let
  cfg = config.nih.networking;
in {
  options.nih.networking = with lib;
  with lib.types; {
    defaultGateway = mkOption {
      type = str;
      default = "192.168.1.1";
    };
    hostName = mkOption {
      type = str;
      default = config.nih.name;
    };
    interface = mkOption {
      type = nullOr str;
      default = null;
    };
    localIp = mkOption {
      type = str;
      default = config.nih.localIp;
    };
    nameservers = mkOption {
      type = listOf str;
      default = ["1.1.1.1" "8.8.8.8"];
    };
    networkmanager = mkOption {
      type = bool;
      default = true;
    };
    portForwarding = mkOption {
      type = bool;
      default = false;
    };
    wireless = mkOption {
      type = bool;
      default =
        if config.nih.type == "laptop"
        then true
        else false;
    };
  };
  config = with lib; {
    boot.kernel.sysctl."net.ipv4.ip_forward" =
      if cfg.portForwarding
      then 1
      else 0;
    boot.kernel.sysctl."net.ipv6.conf.all.forwarding" =
      if cfg.portForwarding
      then 1
      else 0;

    networking = {
      hostName = cfg.hostName;
      defaultGateway = cfg.defaultGateway;
      dhcpcd.enable = true;
      interfaces = mkIf (cfg.interface != null) {
        "${cfg.interface}".ipv4.addresses = [
          {
            address = cfg.localIp;
            prefixLength = 28;
          }
        ];
      };
      nameservers = cfg.nameservers;
      networkmanager.enable = cfg.networkmanager;
      wireless.enable = cfg.wireless;
    };
  };
}