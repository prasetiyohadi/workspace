#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=tidy-viewer
HAS_CARGO="$(type "cargo" &> /dev/null && echo true || echo false)"

install() {
    cargo install $APP_BIN
    echo "Add alias tv='tidy-viewer' to ~/.bashrc or ~/.zshrc"
}

setup_linux() {
    echo "This script will install $APP_BIN using cargo."
    if [ ! "$HAS_CARGO" == "true" ]; then
        echo "Install rustup/cargo first!"
    else
        install
    fi
}

main() {
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
