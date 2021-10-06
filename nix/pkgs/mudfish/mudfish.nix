{ stdenv, lib, fetchurl, bbe, e9patch }:

stdenv.mkDerivation rec {
  pname = "mudfish";
  version = "5.4.7";

  src = fetchurl {
    url = "https://mudfish.net/releases/mudfish-${version}-linux-x86_64.sh";
    sha256 = "sha256-6x0lVT4IZ3mPHacpKU0ME7ELanTQ0ve92r/bsWZUI9c=";
  };

  # mudfish is a self-extracting makeself package
  unpackPhase = ''
    sh $src --keep --noexec
    # mv ./${version}/* .
    # rm -rf ./${version}
  '';

  dontPatch = true;
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ bbe e9patch ];

  buildPhase = ''
    e9tool -M '"/opt/mudfish/${version}/bin"' -A print ./${version}/bin/mudrun

    # mudfish has several hardcoded paths that can't be changed by a flag.
    # We can't use libredirect since it doesn't work on static binaries, so instead we use `bbe` to rewrite the hardcoded
    # strings in the binary file.
    #
    # Limitation: The new string MUST be shorter or equal to the old string
    #
    # Rewrites:
    # - /opt/mudfish/${version}/bin -> $out/bin
    # - /opt/mudfish/${version}/sbin -> $out/bin
    # - /opt/mudfish/5.4.7/var -> /run/mudfish/5.4.7
    #
    # bbe -e 's/\/opt\/mudfish\/\/run\/mudfish\//' $out/bin/mudrun > $out/bin/mudrun-bbe
    # chmod +x $out/bin/mudrun-bbe
  '';

  installPhase = ''
    mkdir -p $out/{bin,etc}

    # mv ./${version} $out/opt/${version}

    # ln -s $out/opt/${version}/bin/mudadm $out/bin/mudadm
    # ln -s $out/opt/${version}/bin/muddiag $out/bin/muddiag
    # ln -s $out/opt/${version}/bin/mudfish $out/bin/mudfish
    # ln -s $out/opt/${version}/bin/mudflow $out/bin/mudflow
    # ln -s $out/opt/${version}/bin/mudrun $out/bin/mudrun
    # ln -s $out/opt/${version}/sbin/mudovpn $out/bin/mudovpn

    # ln -s $out/opt/${version}/etc/htdocs-lan-${version}.tar $out/etc/htdocs-lan-${version}.tar
    # ln -s $out/opt/${version}/etc/htdocs-www-${version}.tar $out/etc/htdocs-www-${version}.tar
    # ln -s $out/opt/${version}/etc/mudrun_cert.pem $out/etc/mudrun_cert.pem
    # ln -s $out/opt/${version}/etc/mudrun_pkey.pem $out/etc/mudrun_pkey.pem

    install -m 755 ./${version}/bin/mudadm $out/bin
    install -m 755 ./${version}/bin/muddiag $out/bin
    install -m 755 ./${version}/bin/mudfish $out/bin
    install -m 755 ./${version}/bin/mudflow $out/bin
    install -m 755 ./${version}/bin/mudrun $out/bin
    install -m 755 ./${version}/sbin/mudovpn $out/bin

    install -m 644 ./${version}/etc/htdocs-lan-${version}.tar $out/etc
    install -m 644 ./${version}/etc/htdocs-www-${version}.tar $out/etc
    install -m 644 ./${version}/etc/mudrun_cert.pem $out/etc
    install -m 644 ./${version}/etc/mudrun_pkey.pem $out/etc
  '';
}
