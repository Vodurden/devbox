{ stdenv, fetchurl, jre, coursier }:

stdenv.mkDerivation rec {
  version = "0.7.0";
  baseName = "metals-emacs";
  name = "${baseName}-${version}";

  buildInputs = [ coursier ];

  phases = "installPhase";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"
    mkdir -p "$out/cache"

    export COURSIER_CACHE="$out/cache"

    coursier bootstrap \
      --java-opt -Xss4m \
      --java-opt -Xms100m \
      --java-opt -Dmetals.client=emacs \
      org.scalameta:metals_2.12:${version} \
      -r bintray:scalacenter/releases \
      -r sonatype:snapshots \
      -o $out/bin/metals-emacs -f
  '';

  meta = with stdenv.lib; {
    homepage = https://scalameta.org/metals/;
    description = "Scala language server with rich IDE features";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
