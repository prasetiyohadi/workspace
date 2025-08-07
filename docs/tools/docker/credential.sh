#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=docker-credential-pass
APP_URL=https://github.com/docker/docker-credential-helpers/releases/download
APP_VERSION=0.6.4
APP_PATH=/usr/local/bin/$APP_BIN
APP_SRC=$APP_BIN-v$APP_VERSION-$OS_TYPE
APP_PKG=$APP_SRC.tar.gz
APP_URL=$APP_URL/v$APP_VERSION/$APP_PKG

check_version() {
    $APP_BIN version
}

install_linux() {
    if [ -f /etc/redhat-release ]; then
        sudo dnf install --assumeyes pass
    fi
    mkdir -p /usr/local/bin
    wget -O /tmp/$APP_PKG $APP_URL
    sudo tar -C /usr/local/bin -zxf /tmp/$APP_PKG
    sudo chmod +x $APP_PATH
}

setup_linux() {
    echo "This script will install $APP_BIN version $APP_VERSION."
    if [ -s "$APP_PATH" ]; then
        check_version
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
