{ pkgs, lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages }:

let
  xivModdingFramework = pkgs.callPackage ./xivModdingFramework.nix {};
in

buildDotnetModule rec {
  pname = "ffmt";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "fosspill";
    repo = "FFXIV_Modding_Tool";
    rev = "v${version}";
    sha256 = "sha256-5At4KSl2Y6qyQ+AqaZeLBIuS4k9SgdqfzuUFTbY8zyw=";
  };

  # Generated with `nix-build -E "with import <nixpkgs> {}; (callPackage ./. {}).passthru.fetch-deps"`
  nugetDeps = ./ffmt-deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-runtime = dotnetCorePackages.runtime_3_1;

  projectFile = "FFXIV_Modding_Tool/FFXIV_Modding_Tool.csproj";
  projectReferences = [
    xivModdingFramework
  ];

  # As per the nixpkgs manual we need FFXIV_Modding_Tool.csproj to include the line:
  #
  #   <PackageReference Include="xivModdingFramework" Version="*" Condition=" '$(ContinuousIntegrationBuild)'=='true' "/>
  #
  # For `projectReferences` to work. So we patch it in!
  #
  # To generate the patch:
  #
  #     git clone https://github.com/fosspill/FFXIV_Modding_Tool
  #     vim FFXIV_Modding_Tool/FFXIV_Modding_Tool.csproj
  #     # ... modify the file to include the line ...
  #     git diff > ../ffmt-csproj-references.patch
  #
  # For more information see https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/dotnet.section.md
  patches = [
    ./ffmt-csproj-references.patch
  ];

  # For some reason ffmt expects xivModdingTools's resources to be available under `Resources` at runtime,
  # `buildDotnetModule` doesn't do this by default so we do it ourselves
  postInstall = ''
    mkdir -p $out/lib/ffmt/Resources
    cp -r ${xivModdingFramework}/lib/xivModdingFramework/Resources/* $out/lib/ffmt/Resources
  '';

  meta = {
    homepage = https://github.com/fosspill/FFXIV_Modding_Tool;
    description = "FFXIV Modding Tool (FFMT) is a crossplatform CLI alternative to the Windows-Only Textools for Mac, Windows and Linux!";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
