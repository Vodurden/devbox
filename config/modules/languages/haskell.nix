# IDE Support tools for haskell. The actual language should be installed with a project-specific shell.nix
{ config, pkgs, ... }:

let
  sources = import ../../../nix/sources.nix;
  all-hies = import sources.all-hies {};
in

{
  primary-user.home-manager.home.packages = [
    (all-hies.selection { selector = p: { inherit (p) ghc864 ghc844; }; })
  ];
}
