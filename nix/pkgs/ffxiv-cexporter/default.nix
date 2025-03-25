{ pkgs, buildDotnetModule, fetchFromGitHub, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "FFXIVClientStructs-CExporter";
  version = "1.0.1";

  src = pkgs.fetchgit {
    url = "https://github.com/aers/FFXIVClientStructs.git";
    rev = "87b2ccfdd68242d51eaa179c6c38537489a0184d";
    sha256 = "sha256-zuewHRqn9nj0hqPsTboTazIQtDY7z6Rf+Mk1E9If7XI=";

    # We need to use leaveDotGit because FFXIVClientStructs uses GitInfo which breaks without .git
    leaveDotGit = true;
  };

  buildInputs = [
    pkgs.git
  ];

  # Generated with `nix-build -E "with import <nixpkgs> {}; (callPackage ./default.nix {}).passthru.fetch-deps" && ./result`
  nugetDeps = ./ffxiv-cexporter-deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = "./CExporter/CExporter.csproj";
}
