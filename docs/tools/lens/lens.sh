#!/usr/bin/env bash
set -euo pipefail

OS=${OSTYPE:-'linux-gnu'}
OS_ID=""
[ -f "/etc/os-release" ] && source /etc/os-release && OS_ID=$ID
OS_TYPE=$(echo "$OS" | tr -d ".[:digit:]")
OS_TYPE_DARWIN=darwin
OS_TYPE_LINUX_AMD64=amd64
OS_TYPE_LINUX_ARM=linux_arm
[ "$OS_TYPE" == "linux-gnu" ] && export OS_TYPE=$OS_TYPE_LINUX_AMD64
[ "$OS_TYPE" == "linux-gnueabihf" ] && export OS_TYPE=$OS_TYPE_LINUX_ARM
APP_BIN=lens
APP_PATH=/usr/bin/$APP_BIN
APP_URL=https://lens-binaries.s3-eu-west-1.amazonaws.com/ide
APP_VERSION=5.2.4-latest.20210923.1
APP_SRC=$(echo $APP_BIN|sed -e "s/\b\(.\)/\u\1/g")-$APP_VERSION.$OS_TYPE
APP_URL=$APP_URL/$APP_SRC

install_linux() {
    if [ "$OS_ID" == "debian" ] || [ "$OS_ID" == "ubuntu" ] \
        || [ "$OS_ID" == "pop" ]; then
        APP_PKG=$APP_SRC.deb
        APP_URL=$APP_URL.deb
        wget -O /tmp/$APP_PKG $APP_URL
        sudo apt-get update
        sudo dpkg -i /tmp/$APP_PKG
        rm -f /tmp/$APP_PKG
    fi
}

setup_darwin() {
    echo "This script will install $APP_BIN using brew."
    command -v brew > /dev/null && brew install --cask $APP_BIN
}

setup_linux() {
    echo "This script will install $APP_BIN version $APP_VERSION."
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
    if [ "$OS_TYPE" == "$OS_TYPE_DARWIN" ]; then
        setup_darwin
    elif [ "$OS_TYPE" == "$OS_TYPE_LINUX_AMD64" ]; then
        setup_linux
    fi
}

main
