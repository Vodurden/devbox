#!/bin/sh

set +x

# Languages!
# Ruby, Python and Perl are installed by DevBox-Core (as
# dependencies by other packages)
pkg install -y \
    node \
    www/npm \
    lang/elixir \
    lang/rust

# Tools
pkg install -y \
    git
