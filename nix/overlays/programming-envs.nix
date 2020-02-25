self: super: {
  scalaEnv = with self; super.buildEnv {
    name = "scala-env";
    paths = [
      scala
      sbt
      scalastyle
      scalafmt
      metals-emacs
    ];
  };

  node8Env = with self; super.buildEnv {
    name = "node8-env";
    paths = [
      nodejs-8_x
      flow
      nodePackages.bower
      nodePackages.tern
      nodePackages.js-beautify
      nodePackages.eslint
      nodePackages.yarn
    ];
  };
}
