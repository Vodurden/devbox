{ config, lib, pkgs, buildLinux, fetchgit, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.13.0-2021-06-30";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = "5.13.0-rc7";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/agd5f/linux.git";
    rev = "93c5bcd4eaaafd7c25c062089806c86d9b7890dd";
    sha256 = "1h3l4gc6y6qnxjc23lbkihl8p7vn1nhs82b6hcdwap36qxg4bg45";
  };

  ignoreConfigErrors = true;

  extraMeta = {
    branch = "amd-staging-drm-next";
    hydraPlatforms = [];
  };
} // (args.argsOverride or {}))
