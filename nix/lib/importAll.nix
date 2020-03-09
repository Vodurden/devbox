{ lib }:

folder:
  let
    importNixIf = key: value: key != "default.nix" && value == "regular" && lib.hasSuffix ".nix" key;
    importDirectoryIf = key: value: value == "directory" && builtins.pathExists (folder + ("/" + key + "/default.nix"));
    importIf = key: value: (importNixIf key value) || (importDirectoryIf key value);

    toImport = name: value: folder + ("/" + name);
  in
    lib.mapAttrsToList toImport (lib.filterAttrs importIf (builtins.readDir folder))
