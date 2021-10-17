{ pkgs, fetchurl, wine-tools }:

# buildWineEnv should provide a "ffxiv-wine-run" script that runs the given exectuable using:
#
# - The wine package chosen here
# - The base prefix defined by the settings here, overlayed by the home prefix for the executing user
#
# I.e. we should be able to do `ffxiv-wine-run ffxivsetup.exe` and it should run the installer in the composed prefix
#
# The lower prefix should probably also move $HOME, since wine symlinks some folders under "My Documents" to
# $HOME by default.
wine-tools.buildWineEnv {
  name = "ffxiv-wine-run";
  wine = pkgs.wineWowPackages.full;
  tricks = with wine-tools; [
    tricks.dotnet40
    tricks.dotnet48
    # "dotnet48"
    # "faudio"
    # "vcrun2015"
  ];
}

wine-tools.buildWineEnv {
  prefix = wine-tools.buildWinePrefix {
    wine = pkgs.wineWowPackages.full;
    baseName = "ffxiv";
    tricks = with wine-tools; [
      tricks.dotnet40
      tricks.dotnet48
      # "dotnet48"
      # "faudio"
      # "vcrun2015"
    ];
  };
}


wine-tools.buildWineApp {
  name = "ffxiv";
  prefix = winePrefix;

  src = http://gdl.square-enix.com/ffxiv/inst/ffxivsetup.exe;

  installPhase = ''
  '';

  executablePath = "$prefix/drive_c/Program Files (x86)/SquareEnix"

  executePhase = ''
    ffxiv-wine-run
    $prefixUser/
  '';
}

# let
#   ffxivPrefix = mkWinePrefix {


#     winetricks = [
#       "dotnet48"
#       "faudio"
#       "vcrun2015"
#     ];
#   };
# in {
#   ffxiv =
# }

# mkWineApp {
#   prefix = ffxivPrefix;

#   installerSrc = fetchurl {
#     url = http://gdl.square-enix.com/ffxiv/inst/ffxivsetup.exe;
#     sha256 = "1md7jsfd8pa45z73bz1kszpp01yw6x5ljkjk2hx7wl800any6465";
#   };
# }
