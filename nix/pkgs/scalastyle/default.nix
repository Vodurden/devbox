{ stdenv, lib, fetchurl, jre }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  baseName = "scalastyle";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "https://oss.sonatype.org/content/repositories/releases/org/scalastyle/scalastyle_2.12/${version}/scalastyle_2.12-${version}-batch.jar";
    sha256 = "1jzdb9hmvmhz3niivm51car74l8f3naspz4b3s6g400dpsbzvnp9";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"

    cp "${src}" "$out/lib/${name}.jar"

    cat > "$out/bin/${baseName}" << EOF
    #!${stdenv.shell}
    exec ${jre}/bin/java -jar "$out/lib/${name}.jar" "\$@"
    EOF

    chmod a+x "$out/bin/${baseName}"
  '';

  meta = with lib; {
    description = "Scalastyle examines your Scala code and indicates potential problems with it.";
    homepage = http://scalastyle.org;
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
