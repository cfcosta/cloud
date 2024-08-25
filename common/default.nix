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
      root-password.file = ../secrets/root-password.age;
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Disable all default NixOS packages
    environment.defaultPackages = mkForce [ ];

    environment.persistence."/nix/persist" = {
      directories = [
        "/srv"
        "/var/lib"
        "/var/log"
      ];
    };

    # Force SSH Keys to be saved to the persistent store
    environment.etc."ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
    environment.etc."ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
    environment.etc."ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
    environment.etc."ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";

    # Force Machine ID to be consistent
    environment.etc."machine-id".source = "/nix/persist/etc/machine-id";

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

    users.users.root.initialPassword = age.secrets.root-password.path;
  };
}
