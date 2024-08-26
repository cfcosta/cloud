{ config, ... }:
let
  inherit (config.age) secrets;
  inherit (config.cloud.dns) domain;
in
{
  networking.firewall.allowedTCPPorts = [ 9091 ];

  services.authelia.instances.default = {
    enable = true;

    secrets = {
      jwtSecretFile = secrets.authelia-jwt.path;
      storageEncryptionKeyFile = secrets.authelia-storage-key.path;
    };

    settings = {
      session = {
        inherit domain;

        expiration = 3600;
        inactivity = 300;
      };

      server = {
        host = "0.0.0.0";
        port = 9091;
      };
    };
  };
}
