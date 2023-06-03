{ pkgs, fetchurl, appimageTools }:

appimageTools.wrapType2 {
  name = "fflogs-uploader";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-fflogs/releases/download/v6.0.2/FF-Logs-Uploader-6.0.2.AppImage";
    hash = "sha256-BmG3s9JVicWM1DdEbK+BPeIawMKJ9fdU3yV9NtRNfuc=";
  };
}
