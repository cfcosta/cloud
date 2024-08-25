{ hanko, ... }:
final: prev:
let
  inherit (prev) buildGoModule;
in
{
  hanko = buildGoModule {
    pname = "hanko";
    version = "0.0.1";
    src = hanko;
    doCheck = false;
  };
}
