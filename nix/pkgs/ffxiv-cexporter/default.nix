{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "FFXIVClientStructs-CExporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "aers";
    repo = "FFXIVClientStructs";
    rev = "f84ba85e87976b711c1ff4795da0a5217cd9dc1f";
    sha256 = "sha256-K8oY9DD7w9Y/2lQFcFpqz8GkPcdGedRT3JrB8ybxq+I=";
  };

  # Generated with `nix-build -E "with import <nixpkgs> {}; (callPackage ./default.nix {}).passthru.fetch-deps"`
  nugetDeps = ./ffxiv-cexporter-deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  projectFile = [
    "ida/CExporter/CExporter.csproj"
  ];
}
