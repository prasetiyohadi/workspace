#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=linux.x86_64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=ctlptl
APP_URL=https://github.com/tilt-dev/ctlptl/releases/download
APP_VERSION=0.5.0
APP_PATH=/usr/local/bin/$APP_BIN
APP_SRC=$APP_BIN.$APP_VERSION.$OS_TYPE
APP_PKG=$APP_SRC.tar.gz
APP_URL=$APP_URL/v$APP_VERSION/$APP_PKG

check_version() {
    $APP_BIN version
}

install_linux() {
    curl -fsSL $APP_URL | tar -xzvC /tmp $APP_BIN
    sudo mv /tmp/$APP_BIN /usr/local/bin/$APP_BIN
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
