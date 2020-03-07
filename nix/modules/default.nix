{ ... }:

{
  imports = [
    ./nixos/primary-user.nix
  ];

  primary-user.home-manager = _: {
    imports = [
      ./home-manager/aws-shortcuts.nix
      ./home-manager/bash-my-aws.nix
    ];
  };
}
