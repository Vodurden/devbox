#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

set -eu -o pipefail

node2nix \
  --nodejs-10 \
  --development \
  --input package.json \
  --output node-packages.nix \
  --composition node-composition.nix

# --node-env ../../../../development/node-packages/node-env.nix \

# --no-copy-node-env \
