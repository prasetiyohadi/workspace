#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_LINUX_AMD64=amd64
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
APP_BIN=k0s
APP_URL=https://github.com/k0sproject/k0s/releases/download
APP_VERSION=0.7.0
APP_PATH=/usr/local/sbin/$APP_BIN
APP_SRC=$APP_BIN-v$APP_VERSION-$OS_TYPE
APP_URL=$APP_URL/v$APP_VERSION/$APP_SRC

check_version() {
    $APP_BIN version
}

install_linux() {
    mkdir -p ~/bin
    sudo curl -Lo $APP_PATH $APP_URL
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
