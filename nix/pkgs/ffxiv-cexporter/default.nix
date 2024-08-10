{ pkgs, buildDotnetModule, fetchFromGitHub, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "FFXIVClientStructs-CExporter";
  version = "1.0.0";

  src = pkgs.fetchgit {
    url = "https://github.com/aers/FFXIVClientStructs.git";
    sha256 = "sha256-DEXsrtY0LXw3kxGeHhIyLL/zvkkMqiYcvazuQ22b4f0=";

    # We need to use leaveDotGit because FFXIVClientStructs uses GitInfo which breaks without .git
    leaveDotGit = true;
  };

  buildInputs = [
    pkgs.git
  ];

  # Generated with `nix-build -E "with import <nixpkgs> {}; (callPackage ./default.nix {}).passthru.fetch-deps"`
  nugetDeps = ./ffxiv-cexporter-deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = "./CExporter/CExporter.csproj";
}
