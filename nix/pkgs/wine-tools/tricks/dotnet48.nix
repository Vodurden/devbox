{ lib, pkgs, fetchurl }:

rec {
  src = fetchurl {
    url = https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/abd170b4b0ec15ad0222a809b761a036/ndp48-x86-x64-allos-enu.exe;
    sha256 = "sha256-lYidbePyBwwHeQrWzyAA0z2aG9/Go4FyWrgqscMU/VM=";
  };

  run = wine: ''
    ${wine}/bin/wine ${src} /q
  '';
}
