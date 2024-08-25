{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) age;
  inherit (lib) mkForce;

  locale = "en_US.UTF-8";
in
{
  config = {
    age.secrets = {
      tailscale.file = ../secrets/tailscale.age;
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Disable all default NixOS packages
    environment.defaultPackages = mkForce [ ];

    # PCI Compliance lmao
    environment.systemPackages = [ pkgs.clamav ];

    i18n.defaultLocale = locale;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = locale;
      LC_MONETARY = locale;
      LC_NAME = locale;
      LC_NUMERIC = locale;
      LC_PAPER = locale;
      LC_TELEPHONE = locale;
      LC_TIME = locale;
    };

    security = {
      auditd.enable = true;

      audit = {
        enable = true;
        rules = [
          "-a exit,always -F arch=b64 -S execve"
        ];
      };
    };

    services.openssh = {
      enable = true;

      settings = {
        PermitRootLogin = mkForce "no";
        PasswordAuthentication = false;
        ChallengeResponseAuthentication = false;
        GSSAPIAuthentication = false;
        KerberosAuthentication = false;
        X11Forwarding = false;
        PermitUserEnvironment = false;
        AllowAgentForwarding = false;
        AllowTcpForwarding = false;
        PermitTunnel = false;
      };
    };

    system.stateVersion = "24.11";

    users.users.root.initialPasswordFile = age.secrets.root-password.path;
  };
}
