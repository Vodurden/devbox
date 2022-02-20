{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "xivModdingFramework";
  version = "2.3.7.1";

  src = fetchFromGitHub {
    owner = "TexTools";
    repo = "xivModdingFramework";
    rev = "v${version}";
    sha256 = "sha256-KvYBJVVZFgQHR5Lerh91ExAe+tqN7rYHh9/5+38zEu0=";
  };

  # Generated with `nix-build -E "with import <nixpkgs> {}; (callPackage ./xiv-modding-framework.nix {}).passthru.fetch-deps"`
  nugetDeps = ./xivModdingFramework-deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-runtime = dotnetCorePackages.runtime_5_0;

  projectFile = [
    "xivModdingFramework/xivModdingFramework.csproj"
  ];

  packNupkg = true;
}
