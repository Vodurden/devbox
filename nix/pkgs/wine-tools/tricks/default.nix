{ pkgs, ... }:

{
  dotnet40 = pkgs.callPackage ./dotnet40.nix {};
  dotnet48 = pkgs.callPackage ./dotnet48.nix {};
}
