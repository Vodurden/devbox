{ stdenv, makeDesktopItem,

  dpkg, autoPatchelfHook,

  glib, glibc, gnome3, gcc-unwrapped, nss, libX11, xorg, libXScrnSaver, alsaLib, nspr
}:

let
  baseName = "tuxedo-control-center";
  version = "1.0.1";

  desktopItem = makeDesktopItem {
    name = "tuxedo-control-center";
    exec = "tuxedo-control-center %U";
    comment = "TUXEDO Control Center Application";
    desktopName = "TUXEDO Control Center";
    icon = "tuxedo-control-center";
    categories = "System;";
  };

in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = builtins.fetchurl {
    url = "http://deb.tuxedocomputers.com/ubuntu/pool/main/t/tuxedo-control-center/tuxedo-control-center_${version}_amd64.deb";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  # Required at running time
  buildInputs = [
    glib
    glibc
    gcc-unwrapped
    gnome3.gtk
    xorg.libXtst
    nss # libnss3
    alsaLib # libasound
    libX11
    libXScrnSaver # libXss
    nspr
  ];

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    chmod go-w $out

    mv $out/usr/share $out/share
    rm -rf $out/usr

    mkdir -p $out/bin
    ln -s $out/bin/tuxedo-control-center $out/opt/tuxedo-control-center/tuxedo-control-center

    ${desktopItem.buildCommand}

    # cp -av $out/opt/Wolfram/WolframScript/* $out
    # rm -rf $out/opt
  '';

  meta = with stdenv.lib; {
    description = "Tuxedo Control Center";
    # homepage = https://www.wolfram.com/wolframscript/;
    # license = licenses.mit;
    # maintainers = with stdenv.lib.maintainers; [ ];
    # platforms = [ "x86_64-linux" ];
  };
}
