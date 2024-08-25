{ nixpkgs, agenix, ... }:
let
  inherit (builtins)
    attrNames
    filter
    listToAttrs
    map
    readDir
    ;
  inherit (nixpkgs.lib)
    hasSuffix
    nixosSystem
    removeSuffix
    ;

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
            agenix.nixosModules.default
            ./targets/${n}
            ./common
            ./modules
          ];
        };
      };
    in
    listToAttrs (map toSystem files);
}
