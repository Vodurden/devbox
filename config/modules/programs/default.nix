{ lib, ... }:

let
  folder = ./.;

  importNixIf = key: value: key != "default.nix" && value == "regular" && lib.hasSuffix ".nix" key;
  importDirectoryIf = key: value: value == "directory" && builtins.pathExists (./. + key + ./default.nix);
  importIf = key: value: (importNixIf key value) || (importDirectoryIf key value);

  toImport = name: value: folder + ("/" + name);
  imports = lib.mapAttrsToList toImport (lib.filterAttrs importIf (builtins.readDir folder));
in

{
  inherit imports;
}
