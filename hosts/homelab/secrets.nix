{ config, ... }:
{
  imports = [ ];
  options = { };
  config = {
    sops.defaultSopsFile = ../../secrets/homelab-secrets.yaml;
    sops.defaultSopsFormat = "yaml";

    sops.secrets."forgejo/user1/name" = {
      owner = config.server.forgejo.user;
    };
    sops.secrets."forgejo/user1/password" = {
      owner = config.server.forgejo.user;
    };
    sops.secrets."forgejo/user1/email" = {
      owner = config.server.forgejo.user;
    };

    /*
      sops.secrets."nextcloud/user1/name" = {
      owner = config.homelab.nextcloud.user;
      };
      sops.secrets."nextcloud/user1/password" = {
      owner = config.homelab.nextcloud.user;
      };
      sops.secrets."nextcloud/user1/email" = {
      owner = config.homelab.nextcloud.user;
      };
    */

    sops.age.keyFile = "/home/guz/.config/sops/age/keys.txt";
  };
}

