self: _: {
  tuxedo-cc-wmi = self.callPackage ../pkgs/tuxedo-cc-wmi {};

  scalastyle = self.callPackage ../pkgs/scalastyle {};
  metals-emacs = self.callPackage ../pkgs/metals-emacs {};
  bash-my-aws = self.callPackage ../pkgs/bash-my-aws {};

  minion = self.callPackage ../pkgs/minion {};
  clevo-indicator = self.callPackage ../pkgs/clevo-indicator {};
  notion-so = self.callPackage ../pkgs/notion-so {};

  aws-shortcuts = self.callPackage ../pkgs/rea/aws-shortcuts {};
  rea-as = self.callPackage ../pkgs/rea/rea-as {};
  rea-slip-utils = self.callPackage ../pkgs/rea/rea-slip-utils {};
}
