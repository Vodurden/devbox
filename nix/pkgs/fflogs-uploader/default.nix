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

appimageTools.wrapType2 {
  name = "fflogs-uploader";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-fflogs/releases/download/v6.0.2/FF-Logs-Uploader-6.0.2.AppImage";
    hash = "sha256-BmG3s9JVicWM1DdEbK+BPeIawMKJ9fdU3yV9NtRNfuc=";
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
