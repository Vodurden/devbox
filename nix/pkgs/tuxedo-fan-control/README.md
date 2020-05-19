# How to update

1. Bump the ref of `tuxedo-fan-control` in [packages.json](./packages.json) to the latest on master on [tuxedocomputers/tuxedo-fan-control](https://github.com/tuxedocomputers/tuxedo-fan-control)
2. Run `generate-dependencies.sh`
3. Set the version in [default.nix](./default.nix). (Version can be found in [tuxedo-fan-control/package.json](https://github.com/tuxedocomputers/tuxedo-fan-control/blob/master/package.json))
4. Build and test
