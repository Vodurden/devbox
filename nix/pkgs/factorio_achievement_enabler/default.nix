{ lib, stdenv, fetchFromGitHub, cmake, ninja }:

# see: https://github.com/NixOS/nixpkgs/blob/1891a995fb10e846b39e93704533fed24586bdda/pkgs/by-name/fa/factorio_achievement_enabler/package.nix
#
# Replace when available
stdenv.mkDerivation rec {
  pname = "fae_linux";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "UnlegitSenpaii";
    repo = "FAE_Linux";
    rev = "refs/tags/v${version}";
    hash = "sha256-6+5ooYFYRImOJKrTApUCrpKiSYXbEugnG6rZeKmaGsY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 out/bin/FAE_Linux $out/bin/fae_linux

    runHook postInstall
  '';

  meta = {
    description = "Factorio Achievement Enabler for Linux";
    homepage = "https://github.com/UnlegitSenpaii/FAE_Linux";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ henriquelay ];
    platforms = [ "x86_64-linux" ];
  };
}
