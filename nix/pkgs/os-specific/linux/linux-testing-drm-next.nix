{ config, lib, pkgs, buildLinux, fetchgit, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.11.0-2020-08-06";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = "5.11.0-rc5";

  # Earliest "Navy Flounder" commit: 8186749621ed6b8fc42644c399e8c755a2b6f630
  # Earliest 5.11 commit: b10733527bfd864605c33ab2e9a886eec317ec39
  src = ../../../../../Code/drm;
  # src = fetchgit {
  #   url = "git://anongit.freedesktop.org/drm/drm";
  #   rev = "b322a50d17ede5cff6622040f345228afecdcc45";
  #   sha256 = "0c713qx56wpl5c342ssjsh85f2gdzy13rnc4wwfzybcg2lj9n118";
  # };
  ignoreConfigErrors = true;

  extraMeta = {
    branch = "drm-next";
    hydraPlatforms = [];
  };
} // (args.argsOverride or {}))
