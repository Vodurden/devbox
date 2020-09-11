{ ... }:

{
  imports = [
    ./nixos/primary-user.nix
    ./nixos/clevo-nvidia-autofan.nix
    ./nixos/tuxedo-control-center.nix
  ];

  primary-user.home-manager = _: {
    imports = [
      ./home-manager/aws-shortcuts.nix
      ./home-manager/bash-my-aws.nix
    ];
  };
}
