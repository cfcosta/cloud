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
        dns-server = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./common
            ./servers/dns-server.nix
          ];
        };
      };
    };
}
