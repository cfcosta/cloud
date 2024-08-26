{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault mkForce;

  locale = "en_US.UTF-8";
in
{
  config = {
    age = {
      identityPaths = [ "/nix/persist/etc/ssh/ssh_host_ed25519_key" ];

      secrets = {
        tailscale.file = ../secrets/tailscale.age;
        root-password.file = ../secrets/root-password.age;
      };
    };

    # Boot and bootloader config
    boot.extraModulePackages = [ ];
    boot.initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
        "thunderbolt"
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    boot.kernelModules = [ "kvm-amd" ];
    boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    documentation.man.enable = true;
    documentation.doc.enable = true;
    documentation.info.enable = true;

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

    # Make partitions that shouldn't have executables noexec
    fileSystems."/".options = [ "noexec" ];
    fileSystems."/srv".options = [ "noexec" ];
    fileSystems."/var/log".options = [ "noexec" ];

    hardware = {
      enableRedistributableFirmware = true;
      cpu.amd.updateMicrocode = true;
    };

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

    networking.useDHCP = mkDefault true;

    security = {
      auditd.enable = true;

      audit = {
        enable = mkDefault true;
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

    time.timeZone = "America/Sao_Paulo";

    users.users.operator = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
