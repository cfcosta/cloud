{
  description = "CFCC: Cainã Costa's Cloud Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
    hanko = {
      url = "github:teamhanko/hanko";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-utils,
      agenix,
      ...
    }:
    (import ./nixos.nix inputs)
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import ./packages inputs)
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "cloud";
          packages = [
            agenix.packages.${system}.default
          ];
        };
      }
    );
}
