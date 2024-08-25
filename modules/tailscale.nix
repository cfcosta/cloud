{ config, ... }:
let
  inherit (config) age;
in
{
  config = {
    networking.firewall = {
      checkReversePath = true;
      trustedInterfaces = [ "tailscale0" ];
    };

    services.tailscale = {
      enable = true;

      authKeyFile = age.secrets.tailscale.path;
      extraUpFlags = [ "--ssh" ];
    };
  };
}
