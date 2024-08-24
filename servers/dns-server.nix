{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.cloud.dns = {
    domain = mkOption {
      type = types.str;
      default = "example.com";
      description = "The domain name to use for the DNS zone.";
    };
  };

  config = { };
}
