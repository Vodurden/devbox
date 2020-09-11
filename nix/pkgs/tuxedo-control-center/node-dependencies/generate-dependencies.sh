#!/usr/bin/env nix-shell
#! nix-shell -i bash -p unstable.nodePackages.node2nix

set -eu -o pipefail

node2nix \
  --development
#  --nodejs-10 \
#  --input package.json \
#  --output node-packages.nix \
#  --composition node-composition.nix

# Download package.json and package-lock.json
# `yarn import` to generate `yarn.lock`, also generates empty `node_modules/` dir
