{ pkgs, lib, ... }:
let
  folder = ./.;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key && key != "default.nix";
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));
in
{
  inherit imports;
  nix.settings.substituters = [ "https://cache.nixos.org/" ];
  #nix.binaryCaches = [ "https://cache.nixos.org/" ];
}
