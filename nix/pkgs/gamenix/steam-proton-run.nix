{ config, lib, pkgs, ... }:

pkgs.writeShellScriptBin "steam-proton-run" ''
  exec steam-run ${./proton-run.sh} "$@"
''
