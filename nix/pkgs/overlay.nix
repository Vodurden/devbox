self: super: {
  tuxedo-cc-wmi = self.callPackage ../pkgs/tuxedo-cc-wmi {};
  tuxedo-control-center = self.callPackage ../pkgs/tuxedo-control-center {};
  g810-led = self.callPackage ../pkgs/g810-led {};

  scalastyle = self.callPackage ../pkgs/scalastyle {};
  bash-my-aws = self.callPackage ../pkgs/bash-my-aws {};

  kotlin-language-server = self.unstable.callPackage ../pkgs/kotlin-language-server {};

  minion = self.callPackage ../pkgs/minion {};
  clevo-indicator = self.callPackage ../pkgs/clevo-indicator {};

  linux_testing_drm_next = self.callPackage ../pkgs/os-specific/linux/linux-testing-drm-next.nix {
    kernelPatches = [
      self.kernelPatches.bridge_stp_helper
    ];
  };
  linuxPackages_testing_drm_next =
    self.recurseIntoAttrs (self.linuxPackagesFor self.linux_testing_drm_next);

  linux_testing_amd_staging_drm_next = self.callPackage ../pkgs/os-specific/linux/linux-testing-amd-staging-drm-next.nix {
    kernelPatches = [
      self.kernelPatches.bridge_stp_helper
    ];
  };
  linuxPackages_testing_amd_staging_drm_next =
    self.recurseIntoAttrs (self.linuxPackagesFor self.linux_testing_amd_staging_drm_next);

  code-shim = self.callPackage ../pkgs/code-shim {};
  mesa-latest = self.callPackage ../pkgs/mesa.nix {};

  ffmt = self.callPackage ../pkgs/ffmt {};

  sunshine = self.callPackage ../pkgs/sunshine {};

  gamenix = self.callPackage ../pkgs/gamenix {};

  plymouth-adi1090x = self.callPackage ./plymouth-adi1090x {};
}
