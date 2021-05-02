# Stolen from https://github.com/NixOS/nixpkgs/pull/118348/
# Delete this one merged into nixos

{ lib, writeText, stdenv, fetchFromGitHub, jdk11, gradle, perl, kotlin, unzip }:

let
  version = "1.1.1";
  deps = stdenv.mkDerivation {
    name = "kotlin-language-server-deps";
    src = fetchFromGitHub {
      owner = "fwcd";
      repo = "kotlin-language-server";
      rev = version;
      sha256 = "4z6rpu3FYQRLNYeDo3NvTGTrV2/CMzUvQ+X3ZGNqszc=";
    };
    nativeBuildInputs = [ jdk11 gradle perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d);
      gradle --no-daemon -Porg.gradle.java.installations.auto-download=false -Dorg.gradle.java.home=${jdk11.home} jar
    '';
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0skHvaLiU8Vj/9UHsgIBF16Wfx3vPSmE6hQ7bRbF78E=";
  };

  gradleInit = writeText "init.gradle" ''
    logger.lifecycle 'Replacing Maven repositories with ${deps}...'

    allprojects {
      repositories {
        maven { url "${deps}" }
      }
    }

    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          maven { url "${deps}" }
        }
      }
    }
  '';
in stdenv.mkDerivation rec {
  pname = "kotlin-language-server";
  inherit version;
  src = fetchFromGitHub {
    owner = "fwcd";
    repo = "kotlin-language-server";
    rev = version;
    sha256 = "4z6rpu3FYQRLNYeDo3NvTGTrV2/CMzUvQ+X3ZGNqszc=";
  };

  nativeBuildInputs = [ jdk11 gradle kotlin unzip ];
  buildInputs = [ jdk11 kotlin ];
  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d);
    gradle --no-daemon --offline --init-script ${gradleInit} -Porg.gradle.java.installations.auto-download=false -Dorg.gradle.java.home=${jdk11.home} :server:distZip
  '';

  installPhase = ''
    mkdir $out
    unzip server/build/distributions/server.zip -d $out
    mv $out/server/* $out
    rmdir $out/server
    rm $out/bin/kotlin-language-server.bat
  '';

  meta = with lib; {
    description = "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol";
    homepage = "https://github.com/fwcd/kotlin-language-server";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
