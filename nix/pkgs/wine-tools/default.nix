{ pkgs, ... }:

rec {
  tricks = pkgs.callPackage ./tricks {};
  mkWinePrefix = pkgs.callPackage ./mkWinePrefix.nix {};

  ffxiv = mkWinePrefix {
    wine = pkgs.wineWowPackages.full;
    baseName = "ffxiv";
    tricks = [
      tricks.dotnet40
      tricks.dotnet48
      # "dotnet48"
      # "faudio"
      # "vcrun2015"
    ];
  };
}
