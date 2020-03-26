{ stdenv, jdk, jre, coursier, makeWrapper }:

let
  baseName = "metals-emacs";
  version = "0.8.3";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier fetch org.scalameta:metals_2.12:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "1l196glr7rbsvrqmq6i7iw532jkz8d1w5m9nh0kh5z12visc7bkk";
  };
in stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk deps ];

  doCheck = true;

  phases = [ "installPhase" ];

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-Xss4m" \
      --add-flags "-Xms100m" \
      --add-flags "-Dmetals.client=emacs" \
      --add-flags "-cp $CLASSPATH scala.meta.metals.Main"
  '';

  meta = with stdenv.lib; {
    homepage = https://scalameta.org/metals/;
    description = "Scala language server with rich IDE features";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
