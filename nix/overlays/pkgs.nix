self: _: {
  tuxedo-cc-wmi = self.callPackage ../pkgs/tuxedo-cc-wmi {};
  tuxedo-control-center = self.callPackage ../pkgs/tuxedo-control-center {};
  g810-led = self.callPackage ../pkgs/g810-led {};
  hid-nintendo = self.callPackage ../pkgs/hid-nintendo {};

  scalastyle = self.callPackage ../pkgs/scalastyle {};
  bash-my-aws = self.callPackage ../pkgs/bash-my-aws {};

  minion = self.callPackage ../pkgs/minion {};
  clevo-indicator = self.callPackage ../pkgs/clevo-indicator {};
  notion-so = self.callPackage ../pkgs/notion-so {};

  aws-shortcuts = self.callPackage ../pkgs/rea/aws-shortcuts {};
  rea-as = self.callPackage ../pkgs/rea/rea-as {};
  rea-slip-utils = self.callPackage ../pkgs/rea/rea-slip-utils {};
  rea-cli = self.callPackage ../pkgs/rea/rea-cli {};
}
