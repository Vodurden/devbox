self: _: {
  scalastyle = self.callPackage ../pkgs/scalastyle {};
  metals-emacs = self.callPackage ../pkgs/metals-emacs {};
  bash-my-aws = self.callPackage ../pkgs/bash-my-aws {};

  minion = self.callPackage ../pkgs/minion {};
  clevo-indicator = self.callPackage ../pkgs/clevo-indicator {};

  aws-shortcuts = self.callPackage ../pkgs/rea/aws-shortcuts {};
  rea-as = self.callPackage ../pkgs/rea/rea-as {};
  rea-slip-utils = self.callPackage ../pkgs/rea/rea-slip-utils {};
}
