{ stdenv, fetchurl, unzip, jdk11, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "minion";
    exec = "minion";
    comment = "MMO Addon manager for Elder Scrolls Online and World of Warcraft";
    desktopName = "Minion";
    categories = "Game;Application;";
  };
in

stdenv.mkDerivation rec {
  version = "3.0.5";
  baseName = "minion";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "https://cdn.mmoui.com/minion/v3/Minion3.0.5-java.zip";
    sha256 = "06xwjdq5mpyn24b9kkg0gznqwjqwnzvfrrj5rkg9jfvfrqy63600";
  };

  nativeBuildInputs = [ unzip ];

  phases = ["unpackPhase" "installPhase"];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib/${baseName}"
    cp ./Minion-jfx.jar "$out/lib/${baseName}/${name}.jar"
    cp -r ./lib "$out/lib/${baseName}/lib"

    cat > "$out/bin/${baseName}" << EOF
    #!${stdenv.shell}
    CLASSPATH="$out/lib"
    exec ${jdk11}/bin/java -cp "$CLASSPATH ./lib" -jar "$out/lib/${baseName}/${name}.jar" "\$@"
    EOF

    chmod a+x "$out/bin/${baseName}"

    ${desktopItem.buildCommand}
  '';

  meta = with stdenv.lib; {
    description = "MMO Addon manager";
    homepage = https://www.mmoui.com/;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
