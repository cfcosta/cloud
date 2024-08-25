{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (config.cloud.dns) fqdn;
in
{
  options.cloud.dns = {
    fqdn = mkOption {
      type = types.str;
      default = "cloud.local";
      description = "The domain name to use for the DNS zone.";
    };
  };

  config = {
    users.users.unbound = {
      isNormalUser = false;
    };
    services.unbound = {
      enable = true;

      settings = {
        server = {
          local-zone = ''"${fqdn}." redirect'';
          local-data = ''"${fqdn}. A 192.168.9.2"'';
        };
      };
    };
  };
}
