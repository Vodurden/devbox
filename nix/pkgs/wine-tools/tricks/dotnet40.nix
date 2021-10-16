{ lib, pkgs, fetchurl }:

rec {
  src = fetchurl {
    url = https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe;
    sha256 = "sha256-ZeBkJY8uQYgWswT2Rv+eh68QHkyVUqsGS7dNKBw4ZZ8=";
  };

  run = wine: ''
    ${wine}/bin/wine ${src} /q
  '';
}
