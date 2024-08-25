{
  description = "CFCC: Cainã Costa's Cloud Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@{ nixpkgs, flake-utils, ... }:
    (import ./nixos.nix inputs)
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "cloud";
          packages = [ ];
        };
      }
    );
}
