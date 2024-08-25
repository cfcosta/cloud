{ config, pkgs, ... }:
{
  services.authelia.instances."${config.cloud.dns.fqdn}" = {
    enable = true;
  };
}
