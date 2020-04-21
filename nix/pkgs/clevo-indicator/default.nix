{ stdenv, pkgs, fetchgit, pkgconfig, libappindicator-gtk3 }:

stdenv.mkDerivation {
  name = "clevo-indicator";

  src = fetchgit {
    url = git://github.com/davidrohr/clevo-indicator;
    rev = "b61e880c2fd33abfb31e1f9574e8c55a47632496";
    sha256 = "1jwmfz5rnj456akkc8l29jrkd46bd5i94py1vhndzl8mqx9s8nab";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libappindicator-gtk3 ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/clevo-indicator $out/bin
  '';
}
