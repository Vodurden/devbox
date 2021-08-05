{ ... }:

{
  imports = [
    ./nixos/primary-user.nix
    ./nixos/clevo-nvidia-autofan.nix
    ./nixos/tuxedo-control-center.nix
    ./nixos/nintendo.nix
    ./nixos/g810-led.nix
  ];

  primary-user.home-manager = _: {
    imports = [
      ./home-manager/bash-my-aws.nix
    ];
  };
}
