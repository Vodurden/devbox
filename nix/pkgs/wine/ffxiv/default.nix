{ fetchurl, wine-tools }:

wine-tools.mkWinePrefix {
  baseName = "ffxiv";
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
