#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux-gnu
APP_BIN=docker-machine-driver-kvm
APP_DIST=ubuntu16.04
APP_URL=https://github.com/dhiltgen/docker-machine-kvm/releases/download
APP_VERSION=0.10.0
APP_PATH=/usr/local/bin/$APP_BIN
APP_URL=$APP_URL/v$APP_VERSION/$APP_BIN-$APP_DIST

install_linux() {
    sudo curl -L  -o $APP_PATH
    sudo chmod +x $APP_PATH
}

setup_linux() {
    echo "This script will install $APP_BIN."
    if [ -s "$APP_PATH" ]; then
        read -p "$APP_PATH already exists. Replace[yn]? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            install_linux
        else
            echo "Installation cancelled."
        fi
    else
        install_linux
    fi
}

main() {
    if [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
