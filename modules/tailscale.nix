{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.cloud.tailscale = {
    api_key = mkOption {
      type = types.str;
      description = "The API key to use for automatically connecting to tailscale";
    };
  };

  config = {
    networking.firewall.trustedInterfaces = [ "tailscale0" ];

    services.tailscale.enable = true;
  };
}
