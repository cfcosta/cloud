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
    users.users.unbound = {
      isNormalUser = false;
    };

    services.unbound = {
      enable = true;
      user = "unbound";

      settings = {
        server = {
          local-zone = ''"${domain}." redirect'';
          local-data = ''"${domain}. A 192.168.9.2"'';

          # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
          harden-glue = true;
          harden-dnssec-stripped = true;
          use-caps-for-id = false;
          prefetch = true;
          edns-buffer-size = 1232;
          hide-identity = true;
          hide-version = true;

          private-address = [
            "192.168.0.0/16"
            "172.16.0.0/12"
            "fd00::/8"
            "fe80::/10"
            # Tailscale subnets
            "100.16.0.0/10"
            "fd7a:115c:a1e0::/48"
          ];
        };
      };
    };
  };
}
