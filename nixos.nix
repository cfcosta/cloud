{ nixpkgs, ... }:
let
  inherit (builtins)
    attrNames
    filter
    map
    readDir
    listToAttrs
    ;
  inherit (nixpkgs.lib) hasSuffix removeSuffix nixosSystem;

  isTarget = n: (hasSuffix ".nix" n) && !(hasSuffix "default.nix" n);
in
{
  nixosConfigurations =
    let
      files = filter isTarget (attrNames (readDir ./targets));

      toSystem = n: {
        name = removeSuffix ".nix" n;

        value = nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./targets/${n}
            ./common
            ./modules
          ];
        };
      };
    in
    listToAttrs (map toSystem files);
}
