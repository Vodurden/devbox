# IDE Support tools for scala. The actual language should be installed with a project-specific shell.nix
{ config, pkgs, ... }:

{
  primary-user.home-manager.home.packages = with pkgs; [
    sbt
    scalastyle
    scalafmt
    metals-emacs
  ];
}
