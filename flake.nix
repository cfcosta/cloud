{
  description = "CFCC: Cainã Costa's Cloud Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        pylon = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./common
            ./modules/dns.nix

            ./targets/pylon.nix
          ];
        };
      };
    };
}
