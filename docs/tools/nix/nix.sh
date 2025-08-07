#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-gnu

setup_linux() {
    # install nix for linux
    curl -L https://nixos.org/nix/install | sh
    # activate nix environment
    source ~/.nix-profile/etc/profile.d/nix.sh
    # verify installation
    nix-env --version
    # install lorri
    # lorri need to be started as daemon `lorri daemon` in other terminal
    # or see https://github.com/target/lorri/blob/master/contrib/daemon.md
    nix-env -if https://github.com/target/lorri/archive/master.tar.gz
    # install direnv
    # setup direnv hook for your shell https://direnv.net/docs/hook.html
    nix-env -if https://github.com/direnv/direnv/archive/master.tar.gz
    # install niv
    nix-env -iA nixpkgs.niv
}

main() {
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
