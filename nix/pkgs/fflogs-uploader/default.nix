{ pkgs, fetchurl, appimageTools, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "fflogs-uploader";
    exec = "fflogs-uploader";
    comment = "A tool for uploading Final Fantasy 14 combat logs to the fflogs website";
    desktopName = "FF Logs Uploader";
    categories = ["Game"];
  };
in

appimageTools.wrapType2 rec {
  name = "fflogs-uploader";
  version = "8.12.19";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-fflogs/releases/download/v${version}/fflogs-v${version}.AppImage";
    sha256 = "sha256-/TGmUHMNowQFIw09OGw1ybiYE7ADPLbsZpAMPw3G5NE=";
  };

  extraInstallCommands = ''
    mkdir -p $out/share
    cp --recursive "${desktopItem}/share" "$out/"
  '';

  meta = with pkgs.lib; {
    homepage = "https://www.fflogs.com/";
    description = "A tool for uploading Final Fantasy 14 combat logs to the fflogs website";
    platforms = [ "x86_64-linux" ];
    license = "unknown";
  };
}
