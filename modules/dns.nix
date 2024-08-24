{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (config.cloud.dns) domain;
in
{
  options.cloud.dns = {
    domain = mkOption {
      type = types.str;
      default = "cloud.local";
      description = "The domain name to use for the DNS zone.";
    };
  };

  config = {
    services.unbound = {
      enable = true;
      settings = {
        server = {
          local-zone = ''"${domain}." redirect'';
          local-data = ''"${domain}. A 192.168.9.2"'';
        };
      };
    };
  };
}
